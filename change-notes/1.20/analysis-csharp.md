# Improvements to C# analysis

## Changes to existing queries

| **Query**                    | **Expected impact**    | **Change**                        |
|------------------------------|------------------------|-----------------------------------|
| Clear text storage of sensitive information (`cs/cleartext-storage-of-sensitive-information`) | More results | Now includes data sources for user controls in `System.Windows.Forms`. |
| Dereferenced variable is always null (`cs/dereferenced-value-is-always-null`) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. Results are now shown by default in LGTM. |
| Dereferenced variable may be null (`cs/dereferenced-value-may-be-null`) | Improved results | The query has been rewritten from scratch, and the analysis is now based on static single assignment (SSA) forms. Results are now shown by default in LGTM. |
| Double-checked lock is not thread-safe (`cs/unsafe-double-checked-lock`) | Fewer false positive and more true positive results | No longer highlights code where the underlying field was not updated in the `lock` statement, or where the field is a `struct`. Results have been added where there are other statements inside the `lock` statement. |
| Exposure of private information (`cs/exposure-of-sensitive-information`) | More results | Now includes data sources for user controls in `System.Windows.Forms`. |
| Improper control of generation of code (`cs/code-injection`) | More results | Now includes data sources for user controls in `System.Windows.Forms`. |
| Off-by-one comparison against container length (`cs/index-out-of-bounds`) | Fewer false positive results | No longer reports results when there are additional guards on the index. |
| SQL query built from user-controlled sources (`cs/sql-injection`) | More results | Now includes data sources for user controls in `System.Windows.Forms`. |
| Uncontrolled format string (`cs/uncontrolled-format-string`) | More results | Now includes data sources for user controls in `System.Windows.Forms`. |
| Unused format argument (`cs/format-argument-unused`) | Fewer false positive results | No longer reports results where the format string is empty. This is often used as a default value and is not an interesting result. |
| Use of default ToString() (`cs/call-to-object-tostring`) | Fewer false positive results | No longer reports results for `char` arrays passed to `StringBuilder.Append()`, which were incorrectly marked as using `ToString`. |
| Use of default ToString() (`cs/call-to-object-tostring`) | Fewer results | No longer reports results when the object is an interface or an abstract class. |
| Using a package with a known vulnerability (`cs/use-of-vulnerable-package`) | More results | This query detects packages vulnerable to CVE-2019-0657. |

## Changes to code extraction

* Fix extraction of `for` statements where the condition declares new variables using `is`.
* Initializers of `stackalloc` arrays are now extracted.

## Changes to QL libraries

* The class `TrivialProperty` now includes library properties determined to be trivial using CIL analysis. This may increase the number of results for all queries that use data flow.
* Taint-tracking steps have been added for the `Json.NET` package. This will improve results for queries that use taint tracking.
* Support has been added for EntityFrameworkCore, including
  - Stored data flow sources
  - Sinks for SQL expressions
  - Data flow through fields that are mapped to the database
* Support has been added for NHibernate-Core, including
  - Stored data flow sources
  - Sinks for SQL expressions
  - Data flow through fields that are mapped to the database 

