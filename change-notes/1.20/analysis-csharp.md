# Improvements to C# analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| *@name of query (Query ID)*  | *Impact on results*    | *How/why the query has changed*   |
|------------------------------|------------------------|-----------------------------------|
| Off-by-one comparison against container length (`cs/index-out-of-bounds`) | Fewer false positives | Results have been removed when there are additional guards on the index. |
| Dereferenced variable is always null (`cs/dereferenced-value-is-always-null`) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. The query is now enabled by default in LGTM. |
| Dereferenced variable may be null (`cs/dereferenced-value-may-be-null`) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. The query is now enabled by default in LGTM. |
| SQL query built from user-controlled sources (`cs/sql-injection`), Improper control of generation of code (`cs/code-injection`), Uncontrolled format string (`cs/uncontrolled-format-string`), Clear text storage of sensitive information (`cs/cleartext-storage-of-sensitive-information`), Exposure of private information (`cs/exposure-of-sensitive-information`) | More results | Data sources have been added from user controls in `System.Windows.Forms`. |
| Use of default ToString() (`cs/call-to-object-tostring`) | Fewer false positives | Results have been removed for `char` arrays passed to `StringBuilder.Append()`, which were incorrectly marked as using `ToString`. |
| Use of default ToString() (`cs/call-to-object-tostring`) | Fewer results | Results have been removed when the object is an interface or an abstract class. |
| Unused format argument (`cs/format-argument-unused`) | Fewer false positives | Results have been removed where the format string is empty. This is often used as a default value and is not an interesting result. |
| Double-checked lock is not thread-safe (`cs/unsafe-double-checked-lock`) | Fewer false positives, more true positives | Results have been removed where the underlying field was not updated in the `lock` statement, or where the field is a `struct`. Results have been added where there are other statements inside the `lock` statement. |

## Changes to code extraction

* Fix extraction of `for` statements where the condition declares new variables using `is`.
* Initializers of `stackalloc` arrays are now extracted.

## Changes to QL libraries

* The class `TrivialProperty` now includes library properties determined to be trivial using CIL analysis. This may increase the number of results for all queries that use data flow.
* Taint-tracking steps have been added for the `Json.NET` package. This will improve results for queries that use taint-tracking.

## Changes to the autobuilder
