# Improvements to C/C++ analysis

The following changes in version 1.23 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) | reliability, japanese-era | This query is a combination of two old queries that were identical in purpose but separate as an implementation detail.  This new query replaces Hard-coded Japanese era start date in call (`cpp/japanese-era/constructor-or-method-with-exact-era-date`) and Hard-coded Japanese era start date in struct (`cpp/japanese-era/struct-with-exact-era-date`). |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Query name (`query id`) | Expected impact | Message. |
| Hard-coded Japanese era start date in call (`cpp/japanese-era/constructor-or-method-with-exact-era-date`) | Deprecated | This query has been deprecated.  Use the new combined query Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) instead. |
| Hard-coded Japanese era start date in struct (`cpp/japanese-era/struct-with-exact-era-date`) | Deprecated | This query has been deprecated.  Use the new combined query Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) instead. |

## Changes to QL libraries

- bullet list
