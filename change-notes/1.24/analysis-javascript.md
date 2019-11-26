# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [react](https://www.npmjs.com/package/react)
  - [Handlebars](https://www.npmjs.com/package/handlebars)

## New queries

| **Query**                                                                       | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Client-side cross-site scripting through exception (`js/xss-through-exception`) | security, external/cwe/cwe-079, external/cwe/cwe-116              | Highlights potential XSS vulnerabilities where an exception is written to the DOM. Results are not shown on LGTM by default. |

## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Clear-text logging of sensitive information (`js/clear-text-logging`) | More results | More results involving `process.env` and indirect calls to logging methods are recognized. |
| Incomplete string escaping or encoding (`js/incomplete-sanitization`) | Fewer false positive results | This query now recognizes additional cases where a single replacement is likely to be intentional. |
| Unbound event handler receiver (`js/unbound-event-handler-receiver`) | Fewer false positive results | This query now recognizes additional ways event handler receivers can be bound. | 

## Changes to libraries

