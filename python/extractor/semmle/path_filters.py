import os
import re

def escape(pattern):
    '''Escape special characters'''
    ESCAPE = "(){}[].^$+\\?|"
    def escape_char(char):
        if char in ESCAPE:
            return "\\" + char
        else:
            return char
    return ''.join(escape_char(c) for c in pattern)

SEP = escape(os.sep)

STAR_STAR_REGEX = "([^%s]*%s)*" % (SEP, SEP)
STAR_REGEX = "[^%s]*" % SEP

def validate_pattern(pattern):
    '''Validate that an include/exclude pattern is of the correct syntax.'''
    kind, glob = pattern.split(":")
    if not kind in ("include", "exclude"):
        raise SyntaxError("Illegal type: '%s'" % kind)
    parts = glob.split("/")
    for p in parts:
        if "**" in p and p != "**":
            raise SyntaxError("Illegal path element: '%s'" % p)

def glob_part_to_regex(glob, add_sep):
    '''Convert glob part to regex pattern'''
    if glob == "**":
        return STAR_STAR_REGEX
    if '*' in glob:
        pattern = glob.replace('*', STAR_REGEX)
    else:
        pattern = glob
    if add_sep:
        return pattern + SEP
    else:
        return pattern

def glob_to_regex(glob, prefix=""):
    '''Convert entire glob to a compiled regex'''
    glob = glob.strip().strip("/")
    parts = glob.split("/")
    #Trailing '**' is redundant, so strip it off.
    if parts[-1] == "**":
        parts = parts[:-1]
        if not parts:
            return ".*"
    parts = [ glob_part_to_regex(escape(p), True) for p in parts[:-1] ] + [ glob_part_to_regex(escape(parts[-1]), False) ]
    # we need to escape the prefix, specifically because on windows the prefix will be
    # something like `C:\\folder\\subfolder\\` and without escaping the
    # backslash-path-separators will get interpreted as regex escapes (which might be
    # invalid sequences, causing the extractor to crash)
    full_pattern = escape(prefix) + ''.join(parts) + "(?:" + SEP + ".*|$)"
    return re.compile(full_pattern)

def filter_from_pattern(pattern, prev_filter, prefix):
    '''Create a filter function from a pattern and the previous filter.
    The pattern takes precedence over the previous filter
    '''
    validate_pattern(pattern)
    kind, glob = pattern.strip().split(":")
    result = kind == "include"
    regex = glob_to_regex(glob, prefix)
    def filter(path):
        if regex.match(path):
            return result
        return prev_filter(path)
    return filter
