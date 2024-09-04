#!/usr/bin/env python

import re
import subprocess
import sys
import os
import argparse

# Some of these limits are conservative and the required versions could be
# comfortably increased, especially if they're no newer than the versions that
# Java depends on.
default_limits = {
    'GCC': '3.0',

    # Default limit for versions of GLIBC symbols used by target program.
    # GLIBC_2.17 was released on 2012-12-25.
    # https://sourceware.org/glibc/wiki/Glibc%20Timeline
    'GLIBC': '2.17',

    # Default limit for versions of GLIBCXX (and GLIBCPP) symbols used
    # by target program. GLIBCXX_3.4 implies at least libstdc++.6.0,
    # and was adopted by GCC 3.4, release on 18/4/2004.
    # https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html
    'GLIBCXX': '3.4',
    'GLIBCPP': '3.4',
    'CXXABI': '1.3',
}

# List of libraries which must not be dynamically loaded
# On linux, the llvm libc++ libraries are statically linked and should not appear
# in the output of `ldd`
no_dynlink_libs = [
  "libstdc++",
  "libc++",
  "libc++abi",
  "libunwind",
]

def get_glibc_version():
  version = subprocess.check_output(['ldd', '--version']).decode("utf-8").split('\n')[0]
  return float(version.split(' ')[-1])

def isTrue(var):
  return var in os.environ and os.environ[var].lower() in ['true', 'yes', '1']

def memoize(f):
  '''Memoize decorator'''
  memo = {}
  def helper(x):
    if x not in memo:
      memo[x] = f(x)
    return memo[x]
  return helper

def normalise_ver(ver):
  '''Convert a dot delimited numerical version string into list of integers.

     This conversion facilitates comparisons between version numbers.'''
  return [int(p) for p in ver.split('.')]

def too_new(cat, ver, limits):
  '''Compare version string ver with the limit for cat.
     Return True if ver is greater than the limit, or if there is no limit for cat.'''
  if cat in limits:
    limit = limits[cat]
    return normalise_ver(ver) > normalise_ver(limit)
  else:
    return True

@memoize
def get_libs(prog):
  '''Get list of dynamically linked libraries'''
  # Find paths to all libraries linked
  re_lib = re.compile('^.* (/.*) \(0x[0-9a-f]+\)$')
  try:
    subprocess.check_output(['ldd', prog], stderr=subprocess.STDOUT).decode('utf-8').split('\n')
  except subprocess.CalledProcessError as e:
    # ldd will have a non zero exitcode of the binary is not dynamically linked.
    return []
  except:
    raise

  return [m.group(1) for m in [ re_lib.search(l) for l in subprocess.check_output(['ldd', prog]).decode('utf-8').split('\n') ] if m]

def gather_min_symbol_versions(prog, limits):
  '''Inspect the given executable 'prog' using `ldd` to discover which libraries it is linked
     against. For each library, use `readelf` to discover the symbols therein, and for each
     symbol with a GLIBC, GLIBCXX or GLIBCPP version record the latest version of each symbol
     found that does not exceed the given limits, or the earliest available version if no
     version is found within the limits.

     Return a dict mapping symbol names to strings of the form "GLIBC_2.5". The dict
     thus indicates the earliest available versions of each symbol.'''
  libs = get_libs(prog)
  # Find earliest versions of all symbols
  sym_ver = dict()
  re_sym = re.compile('(\\w+)@+(.+)_([0-9.]+)')
  for lib in libs:
    for (sym, cat, ver) in re.findall(re_sym, subprocess.check_output(['readelf', '-Ws', lib]).decode('utf-8')):
      if sym in sym_ver:
         (cat2, ver2) = sym_ver[sym]
         if cat != cat2:
           raise Exception('Mismatched categories for symbol: ' + str(sym, cat, ver, cat2, ver2))
         if (normalise_ver(ver) < normalise_ver(ver2) and     too_new(cat2, ver2, limits)) or \
            (normalise_ver(ver) > normalise_ver(ver2) and not too_new(cat, ver, limits)):
           sym_ver[sym] = (cat, ver)
      else:
        sym_ver[sym] = (cat, ver)
  return sym_ver

def gather_linked_symbols(prog):
  '''Inspect the given executable 'prog' using `nm` to discover which symbols it links,
     and for each symbol with a GLIBC, GLIBCXX, or GLIBCPP version record the version
     in a dict mapping symbol names to versions.'''
  re_obj  = re.compile('U (\\w+)@+(.+)_([0-9.]+)')
  return re_obj.findall(subprocess.check_output(['nm', '-u', prog]).decode('utf-8'))

def verify_dynlinked_libraries(prog):
  '''Return the intersection set between dynamically linked libraries
     that should not be dynamically loaded. See `no_dynlink_libs`.'''
  libs = get_libs(prog)
  bad_libs = []
  for lib in libs:
    lib_name = os.path.basename(lib).split(".")[0]
    if lib_name in no_dynlink_libs:
      bad_libs += [lib]

  return bad_libs

def main():
  if isTrue('CODEQL_SKIP_COMPATIBILITY') and not isTrue('CI'):
    # Respect CODEQL_SKIP_COMPATIBILITY which tells us to skip this check, unless we are on CI
    sys.exit(0)

  # Verify parameters
  parser = argparse.ArgumentParser()
  parser.add_argument("program")
  # create outfile - this is needed for the bazel aspect integration
  parser.add_argument("output", nargs="?", type=argparse.FileType('w'))
  prog = parser.parse_args().program

  # Gather versions of symbols actually linked
  prog_symbols = gather_linked_symbols(prog)
  # Check whether any symbols exceed the maximum version restrictions
  bad_syms = [ (sym, cat, ver) for sym, cat, ver in prog_symbols if too_new(cat, ver, default_limits) ]
  if bad_syms != []:
    # Scan for minimum versions of symbols available in linked libraries
    available_symbols = gather_min_symbol_versions(prog, default_limits)
    for sym, cat, ver in bad_syms:
      print(sym + ' is too new or from an unknown category: it requires ' + cat + '_' + ver
                + ', but we are limited to ' + str(default_limits))
    if sym in available_symbols:
      (cat, ver) = available_symbols[sym]
      if not too_new(cat, ver, default_limits):
        print('\tconsider adding: SET_GLIBC_VERSION(%s_%s,%s) { ... } to glibc_compatibility.cpp, ' % (cat, ver, sym))
        print('\tand add \'-Wl,--wrap=%s\' when linking. ' % (sym))
      else:
        print('\tThe earliest available symbol has version %s_%s' % (cat, ver))

  bad_libs = verify_dynlinked_libraries(prog)
  if bad_libs != []:
    print("Binary dynamically links against:")
    for bad_lib in bad_libs:
      print("\t%s" % (bad_lib))
    print("These libraries should be statically linked on linux")

  if bad_syms != [] or bad_libs != []:
    sys.exit(1)
  sys.exit(0)

if __name__ == '__main__':
    main()
