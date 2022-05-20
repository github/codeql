lgtm,codescanning
* The query "Server-side request forgery (SSRF)" (`java/ssrf`) has been promoted from experimental to the main query pack. Its results will now appear by default. This query was originally [submitted as an experimental query by @porcupineyhairs](https://github.com/github/codeql/pull/3454).
* Models for `URI` and `HttpRequest` in the `java.net` package have been improved. This may lead to more results from any query where these types' methods are relevant.
* Models for Apache HttpComponents' `RequestLine` and `BasicRequestLine` types. This may lead to more results from any query where these types' methods are relevant.
