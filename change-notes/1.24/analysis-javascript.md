# Improvements to JavaScript analysis

## General improvements

* Support for the following frameworks and libraries has been improved:
  - [react](https://www.npmjs.com/package/react)

## New queries

| **Query**                                                                 | **Tags**                                                          | **Purpose**                                                                                                                                                                            |
|---------------------------------------------------------------------------|-------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|


## Changes to existing queries

| **Query**                      | **Expected impact**          | **Change**                                                                |
|--------------------------------|------------------------------|---------------------------------------------------------------------------|
| Clear-text logging of sensitive information (`js/clear-text-logging`) | More results | More results involving `process.env` and indirect calls to logging methods are recognized. |
| Unbound event handler receiver (`js/unbound-event-handler-receiver`) | Fewer false positive results | This query now recognizes additional ways event handler receivers can be bound. | 

## Changes to libraries

