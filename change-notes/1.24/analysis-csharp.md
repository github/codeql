# Improvements to C# analysis

The following changes in version 1.24 affect C# analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Page request validation is disabled (`cs/web/request-validation-disabled`) | security, frameworks/asp.net, external/cwe/cwe-016 | Finds where ASP.NET page request validation has been disabled, which could makes the application less secure. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|

## Removal of old queries

## Changes to code extraction

## Changes to libraries

## Changes to autobuilder
