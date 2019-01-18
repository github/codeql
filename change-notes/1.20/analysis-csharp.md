# Improvements to C# analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| *@name of query (Query ID)*  | *Impact on results*    | *How/why the query has changed*   |
|------------------------------|------------------------|-----------------------------------|
| Off-by-one comparison against container length (cs/index-out-of-bounds) | Fewer false positives | Results have been removed when there are additional guards on the index. |
| Dereferenced variable is always null (cs/dereferenced-value-is-always-null) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. The query is now enabled by default in LGTM. |
| Dereferenced variable may be null (cs/dereferenced-value-may-be-null) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. The query is now enabled by default in LGTM. |

## Changes to code extraction

* Fix extraction of `for` statements where the condition declares new variables using `is`.
* Initializers of `stackalloc` arrays are now extracted.

## Changes to QL libraries

* The class `AccessorCall` (and subclasses `PropertyCall`, `IndexerCall`, and `EventCall`) have been redefined, so the expressions they represent are not necessarily the accesses themselves, but rather the expressions that give rise to the accessor calls. For example, in the property assignment `x.Prop = 0`, the call to the setter for `Prop` is no longer represented by the access `x.Prop`, but instead the whole assignment. Consequently, it is no longer safe to cast directly between `AccessorCall`s and `Access`es, and the predicate `AccessorCall::getAccess()` should be used instead.

## Changes to the autobuilder
