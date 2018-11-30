# Improvements to C# analysis

## General improvements

* Control flow graph improvements:
  * The control flow graph construction now takes simple Boolean conditions on local scope variables into account. For example, in `if (b) x = 0; if (b) x = 1;`, the control flow graph will reflect that taking the `true` (resp. `false`) branch in the first condition implies taking the same branch in the second condition. In effect, the first assignment to `x` will now be identified as being dead.
  * Code that is only reachable from a constant failing assertion, such as `Debug.Assert(false)`, is considered to be unreachable.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Using a package with a known vulnerability (cs/use-of-vulnerable-package) | security, external/cwe/cwe-937 | Finds project build files that import packages with known vulnerabilities. This is included by default. |
| Uncontrolled format string (cs/uncontrolled-format-string) | security, external/cwe/cwe-134 | Finds data flow from remote inputs to the format string in `String.Format`. This is included by default. |

## Changes to existing queries

| Inconsistent lock sequence (`cs/inconsistent-lock-sequence`) | More results | This query now finds inconsistent lock sequences globally across calls. |
| Local scope variable shadows member (`cs/local-shadows-member`) | Fewer results | Results have been removed where a constructor parameter shadows a member, because the parameter is probably used to initialize the member. |
| Cross-site scripting (`cs/web/xss`) | More results | This query now finds cross-site scripting vulnerabilities in ASP.NET Core applications. |
| *@name of query (Query ID)*| *Impact on results*    | *How/why the query has changed*                                  |

## Changes to code extraction

* Arguments passed using `in` are now extracted.
* Fix a bug where the `dynamic` type name was not extracted correctly in certain circumstances.
* Fixed a bug where method type signatures were extracted incorrectly in some circumstances.

## Changes to QL libraries

* `getArgument()` on `AccessorCall` has been improved so it now takes tuple assignments into account. For example, the argument for the implicit `value` parameter in the setter of property `P` is `0` in `(P, x) = (0, 1)`. Additionally, the argument for the `value` parameter in compound assignments is now only the expanded value, for example, in `P += 7` the argument is `P + 7` and not `7`.
* The predicate `isInArgument()` has been added to the `AssignableAccess` class. This holds for expressions that are passed as arguments using `in`.

## Changes to the autobuilder

* When determining the target of `msbuild` or `dotnet build`, first look for `.proj` files, then `.sln` files, and finally `.csproj`/`.vcxproj` files. In all three cases, choose the project/solution file closest to the root.
