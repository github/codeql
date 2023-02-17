/** Standard builtin types and modules */

import python

/** the Python major version number */
int major_version() { full_python_analysis_version(result, _, _) }

/** the Python minor version number */
int minor_version() { full_python_analysis_version(_, result, _) }

/** the Python micro version number */
int micro_version() { full_python_analysis_version(_, _, result) }

/** Gets the latest supported minor version for the given major version. */
private int latest_supported_minor_version(int major) {
  major = 2 and result = 7
  or
  major = 3 and result = 11
}

private predicate full_python_analysis_version(int major, int minor, int micro) {
  exists(string version_string | py_flags_versioned("language.version", version_string, _) |
    major = version_string.regexpFind("\\d+", 0, _).toInt() and
    (
      minor = version_string.regexpFind("\\d+", 1, _).toInt()
      or
      not exists(version_string.regexpFind("\\d+", 1, _)) and
      minor = latest_supported_minor_version(major)
    ) and
    (
      micro = version_string.regexpFind("\\d+", 2, _).toInt()
      or
      not exists(version_string.regexpFind("\\d+", 2, _)) and micro = 0
    )
  )
}
