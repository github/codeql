# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [socket.io](http://socket.io)

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Expression has no effect       | Fewer false-positive results | This rule now treats uses of `Object.defineProperty` more conservatively. |
| Useless assignment to property | Fewer false-positive results | This rule now ignore reads of additional getters. |

## Changes to QL libraries
