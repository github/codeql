lgtm,codescanning
* The query "Open URL redirect" (`go/unvalidated-url-redirection`) now recognizes values returned by method `http.Request.FormValue` as possibly user controlled, allowing it to flag more true positive results.
