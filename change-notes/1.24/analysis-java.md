# Improvements to Java analysis

The following changes in version 1.24 affect Java analysis in all applications.

## General improvements

* Alert suppression can now be done with single-line block comments (`/* ... */`) as well as line comments (`// ...`).
* A `Customizations.qll` file has been added to allow customizations of the standard library that apply to all queries.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Disabled Spring CSRF protection (`java/spring-disabled-csrf-protection`) | security, external/cwe/cwe-352 | Finds disabled Cross-Site Request Forgery (CSRF) protection in Spring. |
| Failure to use HTTPS or SFTP URL in Maven artifact upload/download (`java/maven/non-https-url`) | security, external/cwe/cwe-300, external/cwe/cwe-319, external/cwe/cwe-494, external/cwe/cwe-829 | Finds use of insecure protocols during Maven dependency resolution. Results are shown on LGTM by default. |
| Suspicious date format (`java/suspicious-date-format`) | correctness | Finds date format patterns that use placeholders that are likely to be incorrect. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable may be null (`java/dereferenced-value-may-be-null`) | Fewer false positives | Final fields with a non-null initializer are no longer reported. |
| Expression always evaluates to the same value (`java/evaluation-to-constant`) | Fewer false positives | Expressions of the form `0 * x` are usually intended and no longer reported. |
| Useless null check (`java/useless-null-check`) | More true positives | Useless checks on final fields with a non-null initializer are now reported. |

## Changes to libraries

* Identification of test classes has been improved. Previously, one of the
  match conditions would classify any class with a name containing the string
  "Test" as a test class, but now this matching has been replaced with one that
  looks for the occurrence of actual unit-test annotations. This affects the
  general file classification mechanism and thus suppression of alerts, and
  also any security queries using taint tracking, as test classes act as
  default barriers stopping taint flow.
