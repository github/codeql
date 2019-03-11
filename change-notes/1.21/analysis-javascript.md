# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [socket.io](http://socket.io)

* The security queries now track data flow through Base64 decoders such as the Node.js `Buffer` class, the DOM function `atob`, as well as the npm packages [`base-64`](https://www.npmjs.com/package/base-64), [`js-base64`](https://www.npmjs.com/package/js-base64), [`Base64.js`](https://www.npmjs.com/package/Base64) and [`base64-js`](https://www.npmjs.com/package/base64-js).


## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## Changes to existing queries

| **Query**                                  | **Expected impact**          | **Change**                                                                   |
|--------------------------------------------|------------------------------|------------------------------------------------------------------------------|

## Changes to QL libraries
