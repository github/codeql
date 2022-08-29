---
category: newQuery
---
* Added the query `js/tainted-path-from-library-input` which tracks possible
  injections of paths that come from not sanitizing library input parameters.
  Its behaviour is comparable to the standard query
  `js/path-injection`, but it does only consider library input parameters
  as sources of invalid paths, instead of HTTP requests.