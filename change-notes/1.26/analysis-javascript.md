# Improvements to JavaScript analysis

## General improvements

* Angular-specific taint sources and sinks are now recognized by the security queries.

* Support for React has improved, with better handling of react hooks, react-router path parameters, lazy-loaded components, and components transformed using `react-redux` and/or `styled-components`.

* Dynamic imports are now analyzed more precisely.

* Support for the following frameworks and libraries has been improved:
  - [@angular/*](https://www.npmjs.com/package/@angular/core)
  - [AWS Serverless](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html)
  - [Alibaba Serverless](https://www.alibabacloud.com/help/doc-detail/156876.htm)
  - [debounce](https://www.npmjs.com/package/debounce)
  - [bluebird](https://www.npmjs.com/package/bluebird)
  - [call-limit](https://www.npmjs.com/package/call-limit)
  - [classnames](https://www.npmjs.com/package/classnames)
  - [clsx](https://www.npmjs.com/package/clsx)
  - [express](https://www.npmjs.com/package/express)
  - [fast-json-stable-stringify](https://www.npmjs.com/package/fast-json-stable-stringify)
  - [fast-safe-stringify](https://www.npmjs.com/package/fast-safe-stringify)
  - [http](https://nodejs.org/api/http.html)
  - [javascript-stringify](https://www.npmjs.com/package/javascript-stringify)
  - [js-stringify](https://www.npmjs.com/package/js-stringify)
  - [json-stable-stringify](https://www.npmjs.com/package/json-stable-stringify)
  - [json-stringify-safe](https://www.npmjs.com/package/json-stringify-safe)
  - [json3](https://www.npmjs.com/package/json3)
  - [jQuery throttle / debounce](https://github.com/cowboy/jquery-throttle-debounce)
  - [lodash](https://www.npmjs.com/package/lodash)
  - [lodash.debounce](https://www.npmjs.com/package/lodash.debounce)
  - [lodash.throttle](https://www.npmjs.com/package/lodash.throttle)
  - [needle](https://www.npmjs.com/package/needle)
  - [object-inspect](https://www.npmjs.com/package/object-inspect)
  - [pretty-format](https://www.npmjs.com/package/pretty-format)
  - [react](https://www.npmjs.com/package/react)
  - [react-router-dom](https://www.npmjs.com/package/react-router-dom)
  - [react-redux](https://www.npmjs.com/package/react-redux)
  - [redis](https://www.npmjs.com/package/redis)
  - [redux](https://www.npmjs.com/package/redux)
  - [stringify-object](https://www.npmjs.com/package/stringify-object)
  - [styled-components](https://www.npmjs.com/package/styled-components)
  - [throttle-debounce](https://www.npmjs.com/package/throttle-debounce)
  - [underscore](https://www.npmjs.com/package/underscore)

* Analyzing files with the ".cjs" extension is now supported.
* ES2021 features are now supported.

## New queries

| **Query**                                                                       | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|


## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Potentially unsafe external link (`js/unsafe-external-link`) | Fewer results | This query no longer flags URLs constructed using a template system where only the hash or query part of the URL is dynamic. |
| Incomplete URL substring sanitization (`js/incomplete-url-substring-sanitization`) | More results | This query now recognizes additional URLs when the substring check is an inclusion check. |
| Ambiguous HTML id attribute (`js/duplicate-html-id`) | Results no longer shown | Precision tag reduced to "low". The query is no longer run by default. |
| Unused loop iteration variable (`js/unused-loop-variable`) | Fewer results | This query no longer flags variables in a destructuring array assignment that are not the last variable in the destructed array. |
| Unsafe shell command constructed from library input (`js/shell-command-constructed-from-input`) | More results | This query now recognizes more commands where colon, dash, and underscore are used. |
| Unsafe jQuery plugin (`js/unsafe-jquery-plugin`) | More results | This query now detects more unsafe uses of nested option properties. |
| Client-side URL redirect (`js/client-side-unvalidated-url-redirection`) | More results | This query now recognizes some unsafe uses of `importScripts()` inside WebWorkers. |
| Missing CSRF middleware (`js/missing-token-validation`) | More results | This query now recognizes writes to cookie and session variables as potentially vulnerable to CSRF attacks. |
| Missing CSRF middleware (`js/missing-token-validation`) | Fewer results | This query now recognizes more ways of protecting against CSRF attacks. |
| Client-side cross-site scripting (`js/xss`) | More results | This query now tracks data flow from `location.hash` more precisely. |


## Changes to libraries
* The predicate `TypeAnnotation.hasQualifiedName` now works in more cases when the imported library was not present during extraction.
* The class `DomBasedXss::Configuration` has been deprecated, as it has been split into `DomBasedXss::HtmlInjectionConfiguration` and `DomBasedXss::JQueryHtmlOrSelectorInjectionConfiguration`. Unless specifically working with jQuery sinks, subclasses should instead be based on `HtmlInjectionConfiguration`. To use both configurations in a query, see [Xss.ql](https://github.com/github/codeql/blob/main/javascript/ql/src/Security/CWE-079/Xss.ql) for an example.
