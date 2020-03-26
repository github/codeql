# Improvements to Python analysis

The following changes in version 1.24 affect Python analysis in all applications.

## General improvements

Support for Django version 2.x and 3.x

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Uncontrolled command line (`py/command-line-injection`) | More results | We now model the `fabric` and `invoke` pacakges for command execution. |

### Web framework support

The QL-library support for the web frameworks Bottle, CherryPy, Falcon, Pyramid, TurboGears, Tornado, and Twisted have
been fixed so they provide a proper HttpRequestTaintSource, instead of a TaintSource. This will enable results for the following queries:

- py/path-injection
- py/command-line-injection
- py/reflective-xss
- py/sql-injection
- py/code-injection
- py/unsafe-deserialization
- py/url-redirection

The QL-library support for the web framework Twisted have been fixed so they provide a proper
HttpResponseTaintSink, instead of a TaintSink. This will enable results for the following
queries:

- py/reflective-xss
- py/stack-trace-exposure

## Changes to libraries
