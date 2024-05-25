#
# This is a port of com.semmle.extractor.projectstructure.ProjectLayout
# and must be kept in sync
#

"""Project-layout files are used to transform or exclude paths. The format
is described at https://semmle.com/wiki/display/SD/project-layout+format"""

__ALL__ = [ 'load', 'ProjectLayout' ]

import collections
import re
from functools import total_ordering
import sys

def get_renamer(filename):
    layout = load(filename)
    def rename(path):
        renamed = layout.artificial_path(path)
        return path if renamed is None else renamed
    return rename

def load(filename):
    """Load a project-layout file from 'filename'."""
    with open(filename, 'rb') as f:
        content = f.read().decode('utf-8')
        lines = [ line.strip() for line in content.split('\n') ]
    return ProjectLayout(lines)

def _escape_string_literal_for_regexp(literal, preserve):
    ESCAPE = u"(){}[].^$+\\*?"
    def escape(char):
        if char in ESCAPE and not char in preserve:
            return u"\\" + char
        else:
            return char
    return u"".join(escape(c) for c in literal)


class ProjectLayout(object):
    """ A project-layout file optionally begins with an '@'
    followed by the name the project should be renamed to.
    Optionally, it can then be followed by a list of
    include/exclude patterns (see below) which are kept
    as untransformed paths. This is followed by one or
    more clauses. Each clause has the following form:

    #virtual-path
    path/to/include
    another/path/to/include
    -/path/to/include/except/this

    i.e. one or more paths (to include) and zero or more paths
    prefixed by minus-signs (to exclude)."""

    def __init__(self, lines):
        """Construct a project-layout object from an array of strings, each
        corresponding to one line of the project-layout. This constructor is
        for testing. Usually, use the 'load' function."""

        self._project = None
        # Map from virtual path prefixes (following the '#' in the
        # project-layout)  to the sequence of patterns that fall into that
        # section. Declared as an OrderedDict since iteration order matters --
        # the blocks are processed in the same order as they occur in the
        # project-layout.
        self._rewrites = collections.OrderedDict()
        virtual = u""
        section = _Section()
        self._rewrites[virtual] = section
        num = 0
        for line in lines:
            num += 1
            if not line:
                continue
            if line[0] == u'@':
                if self._project is not None:
                    raise _error(u"Multiple project names in project-layout", num)
                self._project = self._tail(line)
            elif line[0] == u'#':
                virtual = self._tail(line)
                if virtual in self._rewrites:
                    raise _error(u"Duplicate virtual path prefix " + virtual, num)
                section = _Section(virtual)
                self._rewrites[virtual] = section
            elif line[0] == u'-':
                section.add(_Rewrite(self._tail(line), num))
            else:
                section.add(_Rewrite(line, num, virtual))

    @classmethod
    def _tail(cls, line):
        return line[1:].strip()

    def project_name(self, default=None):
        """ Get the project name, if specified by the project-layout.
        If default is specified, it will be returned if no project name
        is specified. Otherwise, an exception is thrown."""

        if self._project is not None:
            return self._project
        if default is not None:
            return default
        raise Exception(u"Project specificatino does not define a project name.")

    def sections(self):
        """return the section headings (aka virtual paths)"""
        return self._rewrites.keys()

    def section_is_empty(self, section):
        """Determine whether or not a particular section in this
        project-layout is empty (has no include/exclude patterns)."""

        if section in self._rewrites:
            return self._rewrites[section].is_empty()
        raise Exception(u"Section does not exist: " + section)

    def rename_section(self, old, new):
        """Reaname a section in this project-layout."""

        if not old in self._rewrites:
            raise Exception(u"Section does not exist: " + old)
        section = self._rewrites.pop(old)
        section.rename(new)
        self._rewrites[new] = section

    def sub_layout(self, section_name):
        """Return a project-layout file for just one of the sections in this
        project-layout. This is done by copying all the rules from the
        section, and changing the section heading (beginning with '#')
        to a project name (beginning with '@')."""

        section = self._rewrites.get(section_name, None)
        if section is None:
            raise Exception(u"Section does not exist: " + section)
        return section.to_layout()

    def artificial_path(self, path):
        """Maps a path to its corresponding artificial path according to the
        rules in this project-layout. If the path is excluded (either
        explicitly, or because it is not mentioned in the project-layout)
        then None is returned.

        Paths should start with a leading forward-slash."""

        prefixes = _Section.prefixes(path)
        for section in self._rewrites.values():
            rewrite = section.match(prefixes);
            rewritten = None;
            if rewrite is not None:
                rewritten = rewrite.rewrite(path);
            if rewritten is not None:
                return rewritten
        return None

    def include_file(self, path):
        """Checks whether a path should be included in the project specified by
        this file. A file is included if it is mapped to some location.

        Paths should start with a leading forward-slash."""

        return self.artificial_path(path) is not None


class _Section(object):
    """Each section corresponds to a block beginning with  '#some/path'. There
    is also an initial section for any include/exclude patterns before the
    first '#'."""

    def __init__(self, virtual=u""):
        self._virtual = virtual
        self._simple_rewrites = collections.OrderedDict()
        self._complex_rewrites = []

    def to_layout(self):
        result = []
        rewrites = []
        rewrites.extend(self._simple_rewrites.values())
        rewrites.extend(self._complex_rewrites)
        rewrites.sort()

        result.append(u'@' + self._virtual)
        for rewrite in rewrites:
            result.append(str(rewrite))
        result.append(u'')
        return u'\n'.join(result)

    def rename(self, new):
        self._virtual = new
        for rewrite in self._simple_rewrites.values():
            rewrite.virtual = new
        for rewrite in self._complex_rewrites:
            rewrite.virtual = new

    def add(self, rewrite):
        if rewrite.is_simple():
            self._simple_rewrites[rewrite.simple_prefix()] = rewrite
        else:
            self._complex_rewrites.append(rewrite)

    def is_empty(self):
        return not self._simple_rewrites and not self._complex_rewrites

    @classmethod
    def prefixes(cls, path):
        result = [path]
        i = len(path)
        while (i > 1):
            i = path.rfind(u'/', 0, i)
            result.append(path[:i])
        result.append(u"/")
        return result;

    def match(self, prefixes):
        best = None
        for prefix in prefixes:
            match = self._simple_rewrites.get(prefix, None)
            if match is not None:
                if best is None or best._line < match._line:
                    best = match;
        # Last matching rewrite 'wins'
        for rewrite in reversed(self._complex_rewrites):
            if rewrite.matches(prefixes[0]):
                if best is None or best._line < rewrite._line:
                    best = rewrite;
                # no point continuing
                break;
        return best;

@total_ordering
class _Rewrite(object):
    """Each Rewrite corresponds to a single include or exclude line in the
    project-layout. For example, for following clause there would be three
    Rewrite objects:

    #Source
    /src
    /lib
    -/src/tests

    For includes use the two-argument constructor; for excludes the
    one-argument constructor."""

    # The intention is to allow the ** wildcard when followed by a slash only. The
    # following should be invalid:
    # - a / *** / b (too many stars)
    # - a / ** (** at the end should be omitted)
    # - a / **b (illegal)
    # - a / b** (illegal)
    # - ** (the same as a singleton '/')
    # This regular expression matches ** when followed by a non-/ character,
    # or the end of string.
    _verify_stars = re.compile(u".*(?:\\*\\*[^/].*|\\*\\*$|[^/]\\*\\*.*)")

    def __init__(self, path, line, virtual=None):
        if virtual is None:
            exclude = path
            self._line = line;
            self._original = u'-' + exclude;
            if not exclude.startswith(u"/"):
                exclude = u'/' + exclude
            if exclude.find(u"//") != -1:
                raise _error(u"Illegal '//' in exclude path", line)
            if self._verify_stars.match(exclude):
                raise _error(u"Illegal use of '**' in exclude path", line)
            if exclude.endswith(u"/"):
                exclude = exclude[0 : -1]
            self._pattern = self._compile_prefix(exclude);
            exclude = exclude.replace(u"//", u"/")
            if len(exclude) > 1 and exclude.endswith(u"/"):
                exclude = exclude[0 : -1]
            self._simple = None if exclude.find(u"*") != -1 else exclude
        else:
            include = path
            self._line = line;
            self._original = include;
            if not include.startswith(u"/"):
                include = u'/' + include
            doubleslash = include.find(u"//")
            if doubleslash != include.find(u"//"):
                raise _error(u"More than one '//' in include path (project-layout)", line)
            if self._verify_stars.match(include):
                raise _error(u"Illegal use of '**' in include path (project-layout)", line)
            if not virtual.startswith(u"/"):
                virtual = u"/" + virtual
            if virtual.endswith(u"/"):
                virtual = virtual[0 : -1]
            self._pattern = self._compile_prefix(include);
            include = include.replace(u"//", u"/");
            if len(include) > 1 and include.endswith(u"/"):
                include = include[0 : -1]
            self._simple = None if include.find(u"*") != -1 else include
        self._virtual = virtual;

    @classmethod
    def _compile_prefix(cls, pattern):
        """
        Patterns are matched by translation to regex. The following invariants
        are assumed to hold:

         - The pattern starts with a '/'.
         - There are no occurrences of '**' that is not surrounded by slashes
           (unless it is at the start of a pattern).
         - There is at most one double slash.

         The result of the translation has precisely one capture group, which
         (after successful matching) will contain the part of the path that
         should be glued to the virtual prefix.

         It proceeds by starting the capture group either after the double
         slash or at the start of the pattern, and then replacing '*' with
         '[^/]*' (meaning any number of non-slash characters) and '/**' with
         '(?:|/.*)' (meaning empty string or a slash followed by any number of
         characters including '/').

         The pattern is terminated by the term '(?:/.*|$)', saying 'either the
         next character is a '/' or the string ends' -- this avoids accidental
         matching of partial directory/file names.

         IMPORTANT: Run the ProjectLayoutTests when changing this!
        """

        pattern = _escape_string_literal_for_regexp(pattern, u"*")
        if pattern.find(u"//") != -1:
            pattern = pattern.replace(u"//", u"(/")
        else:
            pattern = u"(" + pattern
        if pattern.endswith(u"/"):
            pattern = pattern[0 : -1]
        pattern = pattern.replace(u"/**", u"-///-")
        pattern = pattern.replace(u"*", u"[^/]*")
        pattern = pattern.replace(u"-///-", u"(?:|/.*)")
        return re.compile(pattern + u"(?:/.*|$))")

    def is_simple(self):
        return self._simple is not None

    def simple_prefix(self):
        """Returns the path included/excluded by this rewrite, if it is
        simple, or <code>null</code> if it is not."""

        return self._simple

    def matches(self, path):
        return bool(self._pattern.match(path))

    def rewrite(self, path):
        if self._virtual is None:
            return None
        matcher = self._pattern.match(path)
        if not matcher:
            return None
        return self._virtual + matcher.group(1);

    def __unicode__(self):
        return self._original

    def __lt__(self, other):
        return self._line < other._line

    __hash__ = None

def _error(message, line):
    raise Exception(u"%s (line %d)" % (message, line))
