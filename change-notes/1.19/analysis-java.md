# Improvements to Java analysis

## General improvements


## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Potential database resource leak (`java/database-resource-leak`) | Fewer false positive results | Results arising from `Mockito.verify(..)` objects are no longer reported. |

## Changes to code extraction


## Changes to QL libraries

