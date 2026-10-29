## 0.7.14

### Minor Analysis Improvements

* Data flow through variables declared in statements of the form `x := y.(type)` at the beginning of type switches has been fixed, which may result in more alerts.
* Added strings.ReplaceAll, http.ParseMultipartForm sanitizers and remove path sanitizer.
