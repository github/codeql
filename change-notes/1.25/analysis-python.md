# Improvements to Python analysis

The following changes in version 1.25 affect Python analysis in all applications.

## General improvements


## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|


## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|


## Changes to libraries

* Importing `semmle.python.web.HttpRequest` will no longer import `UntrustedStringKind` transitively. `UntrustedStringKind` is the most commonly used non-abstract subclass of `ExternalStringKind`. If not imported (by one mean or another), taint-tracking queries that concern `ExternalStringKind` will not produce any results. Please ensure such queries contain an explicit import (`import semmle.python.security.strings.Untrusted`).
