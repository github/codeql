lgtm,codescanning
* A new query (`cpp/memset-may-be-deleted`) is added to the default query suite. The query finds calls to `memset` that may be removed by the compiler. This behavior can make information-leak vulnerabilities easier to exploit. This query was originally [submitted as an experimental query by @ihsinme](https://github.com/github/codeql/pull/4953).
