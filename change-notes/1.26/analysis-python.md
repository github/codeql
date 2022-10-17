# Improvements to Python analysis

The following changes in version 1.26 affect Python analysis in all applications.

## General improvements

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
|`py/unsafe-deserialization` | Different results. | The underlying data flow library has been changed. See below for more details. |
|`py/path-injection` | Different results. | The underlying data flow library has been changed. See below for more details. |
|`py/command-line-injection` | Different results. | The underlying data flow library has been changed. See below for more details. |
|`py/reflective-xss` | Different results. | The underlying data flow library has been changed. See below for more details. |
|`py/sql-injection` | Different results. | The underlying data flow library has been changed. See below for more details. |
|`py/code-injection` | Different results. | The underlying data flow library has been changed. See below for more details. |
## Changes to libraries
* Some of the security queries now use the shared data flow library for data flow and taint tracking. This has resulted in an overall more robust and accurate analysis. The libraries mentioned below have been modelled in this new framework. Other libraries (e.g. the web framework `CherryPy`) have not been modelled yet, and this may lead to a temporary loss of results for these frameworks.
* Improved modelling of the following serialization libraries:
  - `PyYAML`
  - `dill`
  - `pickle`
  - `marshal`
* Improved modelling of the following web frameworks:
  - `Django` (Note that modelling of class-based response handlers is currently incomplete.)
  - `Flask`
* Support for Werkzeug `MultiDict`.
* Support for the [Python Database API Specification v2.0 (PEP-249)](https://www.python.org/dev/peps/pep-0249/), including the following libraries:
  - `MySQLdb`
  - `mysql-connector-python`
  - `django.db`
* Improved modelling of the following command execution libraries:
  - `Fabric`
  - `Invoke`
* Improved modelling of security-related standard library modules, such as `os`, `popen2`, `platform`, and `base64`.
* The original versions of the updated queries have been preserved [here](https://github.com/github/codeql/tree/main/python/ql/src/experimental/Security-old-dataflow).
* Added taint tracking support for string formatting through f-strings.
