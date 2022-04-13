## 0.0.13

## 0.0.12

### New Queries

* Added a new query, `rb/clear-text-storage-sensitive-data`. The query finds cases where sensitive information, such as user credentials, are stored as cleartext.
* Added a new query, `rb/incomplete-hostname-regexp`. The query finds instances where a hostname is incompletely sanitized due to an unescaped character in a regular expression.

## 0.0.11

## 0.0.10

### New Queries

* Added a new query, `rb/clear-text-logging-sensitive-data`. The query finds cases where sensitive information, such as user credentials, are logged as cleartext.

## 0.0.9

## 0.0.8

### New Queries

* Added a new query, `rb/weak-cookie-configuration`. The query finds cases where cookie configuration options are set to values that may make an application more vulnerable to certain attacks.

### Minor Analysis Improvements

* The query `rb/csrf-protection-disabled` has been extended to find calls to the Rails method `protect_from_forgery` that may weaken CSRF protection.

## 0.0.7

## 0.0.6

## 0.0.5

## 0.0.4

### New Queries

* A new query (`rb/request-forgery`) has been added. The query finds HTTP requests made with user-controlled URLs.
* A new query (`rb/csrf-protection-disabled`) has been added. The query finds cases where cross-site forgery protection is explictly disabled.

### Query Metadata Changes

* The precision of "Hard-coded credentials" (`rb/hardcoded-credentials`) has been decreased from "high" to "medium". This query will no longer be run and displayed by default on Code Scanning and LGTM.
