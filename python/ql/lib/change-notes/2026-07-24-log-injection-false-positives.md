---
category: minorAnalysis
---
* The `py/log-injection` query no longer reports a routed parameter whose type annotation a
  web framework validates to be a simple type, such as `int` or `uuid.UUID`, since such a
  value cannot contain a line break. The query also recognizes more ways of neutralizing a
  log message, including `str.translate`, `re.sub` with a pattern matching control
  characters, escaping conversions such as `repr` and `json.dumps`, and a
  `logging.Formatter` subclass that strips control characters from every record it renders.
  This reduces false positives in applications that use typed path parameters or sanitize
  when the record is written rather than where it is created.
