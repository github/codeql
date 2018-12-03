# Improvements to JavaScript analysis

## General improvements

* Support for popular libraries has been improved. Consequently, queries may produce more results on code bases that use the following features:
  - client-side code, for example [React](https://reactjs.org/)
  - server-side code, for example [hapi](https://hapijs.com/)

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Double escaping or unescaping (`js/double-escaping`) | correctness, security, external/cwe/cwe-116 | Highlights potential double escaping or unescaping of special characters, indicating a possible violation of [CWE-116](https://cwe.mitre.org/data/definitions/116.html). Results are shown on LGTM by default. |
| Incomplete URL substring sanitization | correctness, security, external/cwe/cwe-020 | Highlights URL sanitizers that are likely to be incomplete, indicating a violation of [CWE-020](https://cwe.mitre.org/data/definitions/20.html). Results shown on LGTM by default. |
| Incorrect suffix check (`js/incorrect-suffix-check`) | correctness, security, external/cwe/cwe-020 | Highlights error-prone suffix checks based on `indexOf`, indicating a potential violation of [CWE-20](https://cwe.mitre.org/data/definitions/20.html). Results are shown on LGTM by default. |
| Useless comparison test (`js/useless-comparison-test`) | correctness | Highlights code that is unreachable due to a numeric comparison that is always true or always false. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                                  | **Expected impact**          | **Change**                                                                   |
|--------------------------------------------|------------------------------|------------------------------------------------------------------------------|
| Unused variable, import, function or class | Fewer false-positive results | This rule now flags fewer variables that are implictly used by JSX elements. |
|                                            |                              |                                                                              |

## Changes to QL libraries
