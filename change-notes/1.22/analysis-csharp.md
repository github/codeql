# Improvements to C# analysis

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Constant condition (`cs/constant-condition`) | Fewer false positive results | Results have been removed for default cases (`_`) in switch expressions. |
| Dispose may not be called if an exception is thrown during execution (`cs/dispose-not-called-on-throw`) | Fewer false positive results | Results have been removed where an object is disposed both by a `using` statement and a `Dispose` call. |

## Changes to code extraction

## Changes to QL libraries

## Changes to autobuilder
