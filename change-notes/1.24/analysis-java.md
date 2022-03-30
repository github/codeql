# Improvements to Java analysis

The following changes in version 1.24 affect Java analysis in all applications.

## General improvements

* You can now suppress alerts using either single-line block comments (`/* ... */`) or line comments (`// ...`).
* A `Customizations.qll` file has been added to allow customizations of the standard library that apply to all queries.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Disabled Spring CSRF protection (`java/spring-disabled-csrf-protection`) | security, external/cwe/cwe-352 | Finds disabled Cross-Site Request Forgery (CSRF) protection in Spring. Results are shown on LGTM by default. |
| Failure to use HTTPS or SFTP URL in Maven artifact upload/download (`java/maven/non-https-url`) | security, external/cwe/cwe-300, external/cwe/cwe-319, external/cwe/cwe-494, external/cwe/cwe-829 | Finds use of insecure protocols during Maven dependency resolution. Results are shown on LGTM by default. |
| LDAP query built from user-controlled sources (`java/ldap-injection`) | security, external/cwe/cwe-090 | Finds LDAP queries vulnerable to injection of unsanitized user-controlled input. Results are shown on LGTM by default. |
| Left shift by more than the type width (`java/lshift-larger-than-type-width`) | correctness | Finds left shifts of ints by 32 bits or more and left shifts of longs by 64 bits or more. Results are shown on LGTM by default. |
| Suspicious date format (`java/suspicious-date-format`) | correctness | Finds date format patterns that use placeholders that are likely to be incorrect. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Dereferenced variable may be null (`java/dereferenced-value-may-be-null`) | Fewer false positive results | Final fields with a non-null initializer are no longer reported. |
| Expression always evaluates to the same value (`java/evaluation-to-constant`) | Fewer false positive results | Expressions of the form `0 * x` are usually intended and no longer reported. Also left shift of ints by 32 bits and longs by 64 bits are no longer reported as they are not constant, these results are instead reported by the new query `java/lshift-larger-than-type-width`. |
| Useless null check (`java/useless-null-check`) | More true positive results | Useless checks on final fields with a non-null initializer are now reported. |

## Changes to libraries

* The data-flow library has been improved, which affects and improves most security queries. The improvements are:
    - Track flow through methods that combine taint tracking with flow through fields.
    - Track flow through clone-like methods, that is, methods that read contents of a field from a
      parameter and stores the value in the field of a returned object.
* Identification of test classes has been improved. Previously, one of the
  match conditions would classify any class with a name containing the string
  "Test" as a test class, but now this matching has been replaced with one that
  looks for the occurrence of actual unit-test annotations. This affects the
  general file classification mechanism and thus suppression of alerts, and
  also any security queries using taint tracking, as test classes act as
  default barriers stopping taint flow.
* Parentheses are now no longer modeled directly in the AST, that is, the
  `ParExpr` class is empty. Instead, a parenthesized expression can be
  identified with the `Expr.isParenthesized()` member predicate.
