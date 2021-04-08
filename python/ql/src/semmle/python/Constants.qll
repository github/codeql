/** Standard builtin types and modules */

import python

/** the Python major version number */
int major_version() {
  explicit_major_version(result)
  or
  not explicit_major_version(_) and
  /* If there is more than one version, prefer 2 for backwards compatibilty */
  (if py_flags_versioned("version.major", "2", "2") then result = 2 else result = 3)
}

/** the Python minor version number */
int minor_version() {
  exists(string v | py_flags_versioned("version.minor", v, major_version().toString()) |
    result = v.toInt()
  )
}

/** the Python micro version number */
int micro_version() {
  exists(string v | py_flags_versioned("version.micro", v, major_version().toString()) |
    result = v.toInt()
  )
}

private predicate explicit_major_version(int v) {
  exists(string version | py_flags_versioned("language.version", version, _) |
    version.charAt(0) = "2" and v = 2
    or
    version.charAt(0) = "3" and v = 3
  )
}
