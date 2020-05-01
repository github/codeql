# Improvements to Go analysis

## General improvements

* A model for the Macaron HTTP library's `Context.Redirect` function was added.

## New queries

| **Query**                                                                    | **Tags**                                                                                | **Purpose**                                                                                                                                                                         |
|------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## Changes to existing queries

| **Query**                                    | **Expected impact**   | **Change**                                                                                                                                                            |
|----------------------------------------------|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Bad redirect check (`go/bad-redirect-check`) | More accurate results | The query now checks for a use of the value checked by the result in a redirect call, and no longer uses names as a heuristic for whether the checked value is a URL. |

