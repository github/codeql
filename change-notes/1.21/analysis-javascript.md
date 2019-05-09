# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [koa](https://github.com/koajs/koa)
  - [socket.io](http://socket.io)
  - [Node.js](http://nodejs.org)
  - [Firebase](https://firebase.google.com/)
  - [Express](https://expressjs.com/)
  - [shelljs](https://www.npmjs.com/package/shelljs)
  - [cheerio](https://www.npmjs.com/package/cheerio)

* The security queries now track data flow through Base64 decoders such as the Node.js `Buffer` class, the DOM function `atob`, and a number of npm packages intcluding [`abab`](https://www.npmjs.com/package/abab), [`atob`](https://www.npmjs.com/package/atob), [`btoa`](https://www.npmjs.com/package/btoa), [`base-64`](https://www.npmjs.com/package/base-64), [`js-base64`](https://www.npmjs.com/package/js-base64), [`Base64.js`](https://www.npmjs.com/package/Base64) and [`base64-js`](https://www.npmjs.com/package/base64-js).

* The security queries now treat comparisons with symbolic constants as sanitizers, resulting in fewer false positives.

* TypeScript 3.4 features are now supported.


## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Arbitrary file write during zip extraction ("Zip Slip") | More results | This rule now considers more libraries, including tar as well as zip. |
| Client-side URL redirect       | More results and fewer false-positive results | This rule now recognizes additional uses of the document URL. This rule now treats URLs as safe in more cases where the hostname cannot be tampered with. |
| Double escaping or unescaping | More results | This rule now considers the flow of regular expressions literals. |
| Expression has no effect       | Fewer false-positive results | This rule now treats uses of `Object.defineProperty` more conservatively. |
| Incomplete regular expression for hostnames | More results | This rule now tracks regular expressions for host names further. |
| Incomplete string escaping or encoding | More results | This rule now considers the flow of regular expressions literals, and it no longer flags the removal of trailing newlines. |
| Password in configuration file | Fewer false positive results | This query now excludes passwords that are inserted into the configuration file using a templating mechanism. |
| Replacement of a substring with itself | More results | This rule now considers the flow of regular expressions literals. |
| Server-side URL redirect       | Fewer false-positive results | This rule now treats URLs as safe in more cases where the hostname cannot be tampered with. |
| Type confusion through parameter tampering | Fewer false-positive results | This rule now recognizes additional emptiness checks. |
| Useless assignment to property | Fewer false-positive results | This rule now ignore reads of additional getters. |
| Unreachable statement | Unreachable throws no longer give an alert | This ignores unreachable throws, as they could be intentional (for example, to placate the TS compiler). |

## Changes to QL libraries

* `RegExpLiteral` is now a `DataFlow::SourceNode`.
* `JSDocTypeExpr` now has source locations and is a subclass of `Locatable` and `TypeAnnotation`.
* Various predicates named `getTypeAnnotation()` now return `TypeAnnotation` instead of `TypeExpr`.
  In rare cases, this may cause compilation errors. Cast the result to `TypeExpr` if this happens.
