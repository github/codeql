# Improvements to C# analysis

The following changes in version 1.24 affect C# analysis in all applications.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Insecure configuration for ASP.NET requestValidationMode (`cs/insecure-request-validation-mode`) | security, external/cwe/cwe-016 | Finds where this attribute has been set to a value less than 4.5, which turns off some validation features and makes the application less secure. |

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|

## Removal of old queries

## Changes to code extraction

## Changes to libraries

## Changes to autobuilder
