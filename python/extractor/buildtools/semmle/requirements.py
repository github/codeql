import copy
import tempfile
import re
from packaging.requirements import Requirement
from packaging.version import Version
from packaging.specifiers import SpecifierSet

IGNORED_REQUIREMENTS = re.compile("^(-e\\s+)?(git|svn|hg)(?:\\+.*)?://.*$")

def parse(lines):
    'Parse a list of requirement strings into a list of `Requirement`s'
    res = []
    #Process
    for line in lines:
        if '#' in line:
            line, _ = line.split('#', 1)
        if not line:
            continue
        if IGNORED_REQUIREMENTS.match(line):
            continue
        try:
            req = Requirement(line)
        except:
            print("Cannot parse requirements line '%s'" % line)
        else:
            res.append(req)
    return res

def parse_file(filename):
    with open(filename, 'r') as fd:
        return parse(fd.read().splitlines())

def save_to_file(reqs):
    'Takes a list of requirements, saves them to a temporary file and returns the filename'
    with tempfile.NamedTemporaryFile(prefix="semmle-requirements", suffix=".txt", mode="w", delete=False) as fd:
        for req in reqs:
            if req.url is None:
                fd.write(str(req))
            else:
                fd.write(req.url)
            fd.write("\n")
    return fd.name

def clean(reqs):
    'Look for self-contradictory specifier groups and remove the necessary specifier parts to make them consistent'
    result = []
    for req in reqs:
        specs = req.specifier
        cleaned_specs = _clean_specs(specs)
        req.specifier = cleaned_specs
        result.append(Requirement(str(req)))
        req.specifier = specs
    return result

def _clean_specs(specs):
    ok = SpecifierSet()
    #Choose a deterministic order such that >= comes before <=.
    for spec in sorted(iter(specs), key=str, reverse=True):
        for ok_spec in ok:
            if not _compatible_specifier(ok_spec, spec):
                break
        else:
            ok &= SpecifierSet(str(spec))
    return ok

def restrict(reqs):
    '''Restrict versions to "compatible" versions.
    For example restrict >=1.2 to all versions >= 1.2 that have 1 as the major version number.
    >=N... becomes >=N...,==N.* and >N... requirements becomes >N..,==N.*
    '''
    #First of all clean the requirements
    reqs = clean(reqs)
    result = []
    for req in reqs:
        specs = req.specifier
        req.specifier = _restrict_specs(specs)
        result.append(Requirement(str(req)))
        req.specifier = specs
    return result

def _restrict_specs(specs):
    restricted = copy.deepcopy(specs)
    #Iteration order doesn't really matter here so we choose the
    #same as for clean, just to be consistent
    for spec in sorted(iter(specs), key=str, reverse=True):
        if spec.operator in ('>', '>='):
            base_version = spec.version.split(".", 1)[0]
            restricted &= SpecifierSet('==' + base_version + '.*')
    return restricted

def _compatible_specifier(s1, s2):
    overlaps = 0
    overlaps += _min_version(s1) in s2
    overlaps += _max_version(s1) in s2
    overlaps += _min_version(s2) in s1
    overlaps += _max_version(s2) in s1
    if overlaps > 1:
        return True
    if overlaps == 1:
        #One overlap -- Generally compatible, but not for <x, >=x
        return not _is_strict(s1) and not _is_strict(s2)
    #overlaps == 0:
    return False

MIN_VERSION = Version('0.0a0')
MAX_VERSION = Version('1000000')

def _min_version(s):
    if s.operator in ('>', '>='):
        return s.version
    elif s.operator in ('<', '<=', '!='):
        return MIN_VERSION
    elif s.operator == '==':
        v = s.version
        if v[-1] == '*':
            return v[:-1] + '0'
        else:
            return s.version
    else:
        # '~='
        return s.version

def _max_version(s):
    if s.operator in ('<', '<='):
        return s.version
    elif s.operator in ('>', '>=', '!='):
        return MAX_VERSION
    elif s.operator in ('~=', '=='):
        v = s.version
        if v[-1] == '*' or s.operator == '~=':
            return v[:-1] + '1000000'
        else:
            return s.version

def _is_strict(s):
    return s.operator in ('>', '<')
