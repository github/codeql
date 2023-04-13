/**
 * Summarize a snapshot
 */

import python

from string key, string value
where
  key = "Extractor version" and py_flags_versioned("extractor.version", value, _)
  or
  key = "Snapshot build time" and
  exists(date d | snapshotDate(d) and value = d.toString())
  or
  key = "Interpreter version" and
  exists(string major, string minor |
    py_flags_versioned("extractor_python_version.major", major, _) and
    py_flags_versioned("extractor_python_version.minor", minor, _) and
    value = major + "." + minor
  )
  or
  key = "Build platform" and
  exists(string raw | py_flags_versioned("sys.platform", raw, _) |
    if raw = "win32"
    then value = "Windows"
    else
      if raw = "linux2"
      then value = "Linux"
      else
        if raw = "darwin"
        then value = "OSX"
        else value = raw
  )
  or
  key = "Source location" and sourceLocationPrefix(value)
  or
  key = "Lines of code (source)" and
  value =
    sum(ModuleMetrics m | exists(m.getFile().getRelativePath()) | m.getNumberOfLinesOfCode())
        .toString()
  or
  key = "Lines of code (total)" and
  value = sum(ModuleMetrics m | any() | m.getNumberOfLinesOfCode()).toString()
select key, value
