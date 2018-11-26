# Improvements to JavaScript analysis

## General improvements

## New queries

| **Query**                                     | **Tags**                                             | **Purpose**                                                                                                                                                                 |
|-----------------------------------------------|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Double escaping or unescaping (`js/double-escaping') | correctness, security, external/cwe/cwe-116 | Highlights potential double escaping or unescaping of special characters, indicating a possible violation of [CWE-116](https://cwe.mitre.org/data/definitions/116.html). Results are shown on LGTM by default. |


## Changes to existing queries

| **Query**                                  | **Expected impact**          | **Change**                                                                   |
|--------------------------------------------|------------------------------|------------------------------------------------------------------------------|
| Unused variable, import, function or class | Fewer false-positive results | This rule now flags fewer variables that are implictly used by JSX elements. |
|                                            |                              |                                                                              |

## Changes to QL libraries
