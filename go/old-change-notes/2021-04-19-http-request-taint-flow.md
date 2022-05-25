lgtm,codescanning
* `net/http.Request` and `mime/multipart.Part`'s models have been improved. `Request`'s error returns are no longer considered tainted, and `Part`'s methods propagate taint (for example, the `Part.FileName()` of a tainted `Part` is itself tainted). This should lead to more accurate results from any query where `Request` or `Part` methods occurred in a taint-flow path.
