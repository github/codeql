# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [socket.io](http://socket.io)
  - [Node.js](http://nodejs.org)

* The security queries now track data flow through Base64 decoders such as the Node.js `Buffer` class, the DOM function `atob`, and a number of npm packages intcluding [`abab`](https://www.npmjs.com/package/abab), [`atob`](https://www.npmjs.com/package/atob), [`btoa`](https://www.npmjs.com/package/btoa), [`base-64`](https://www.npmjs.com/package/base-64), [`js-base64`](https://www.npmjs.com/package/js-base64), [`Base64.js`](https://www.npmjs.com/package/Base64) and [`base64-js`](https://www.npmjs.com/package/base64-js).


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
| Incomplete string escaping or encoding | More results | This rule now considers the flow of regular expressions literals. |
| Replacement of a substring with itself | More results | This rule now considers the flow of regular expressions literals. |
| Server-side URL redirect       | Fewer false-positive results | This rule now treats URLs as safe in more cases where the hostname cannot be tampered with. |
| Useless assignment to property | Fewer false-positive results | This rule now ignore reads of additional getters. |

## Changes to QL libraries

* `RegExpLiteral` is now a `DataFlow::SourceNode`.
