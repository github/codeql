## 0.7.7

### Deprecated APIs

* The class `Fmt::AppenderOrSprinter` of the `Fmt.qll` module has been deprecated. Use the new `Fmt::AppenderOrSprinterFunc` class instead. Its taint flow features have been migrated to models-as-data.

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `TLD`, `HTTP`, `SQL`, `URL` etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated and unused `Source` class from the `SharedXss` module of `Xss.qll`
* Support for flow sources in [AWS Lambda function handlers](https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html) has been added.
* Support for the [fasthttp framework](https://github.com/valyala/fasthttp/) has been added.
