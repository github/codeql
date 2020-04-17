# Improvements to C/C++ analysis

The following changes in version 1.24 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Implicit function declarations (`cpp/Likely Bugs/Underspecified Functions/ImplicitFunctionDeclaration.ql`) | correctness, maintainability | This query finds calls to undeclared functions that are compiled by a C compiler. Results are shown on LGTM by default. |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| All CWE-specific queries using taint tracking (`cpp/path-injection`, `cpp/cgi-xss`, `cpp/sql-injection`, `cpp/uncontrolled-process-operation`, `cpp/unbounded-write`, `cpp/tainted-format-string`, `cpp/tainted-format-string-through-global`, `cpp/uncontrolled-arithmetic`, `cpp/uncontrolled-allocation-size`, `cpp/user-controlled-bypass`, `cpp/cleartext-storage-buffer`, `cpp/tainted-permissions-check`) | More correct results | A new taint-tracking library is used, giving more precise results and offering _path explanations_ for results. There is a performance cost to this, and the LGTM suite will overall run slower than before. |
| Boost\_asio TLS Settings Misconfiguration (`cpp/boost/tls-settings-misconfiguration`) | Query id change | Query id renamed from `cpp/boost/tls_settings_misconfiguration` (underscores to dashes) |
| Buffer not sufficient for string (`cpp/overflow-calculated`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Hard-coded Japanese era start date (`cpp/japanese-era/exact-era-date`) |  | This query is no longer run on LGTM. |
| Memory is never freed (`cpp/memory-never-freed`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Memory may not be freed (`cpp/memory-may-not-be-freed`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| Mismatching new/free or malloc/delete (`cpp/new-free-mismatch`) | Fewer false positive results | Fixed false positive results in template code. |
| Missing return statement (`cpp/missing-return`) | Fewer false positive results | Functions containing `asm` statements are no longer highlighted by this query. |
| Missing return statement (`cpp/missing-return`) | More accurate locations | Locations reported by this query are now more accurate in some cases. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | More correct results | String arguments to formatting functions are now (usually) expected to be null terminated strings. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | More true positive results | This query now identifies a wider variety of buffer allocations using the `semmle.code.cpp.models.interfaces.Allocation` library. |
| No space for zero terminator (`cpp/no-space-for-terminator`) | Fewer false positive results | This query has been modified to be more conservative when identifying which pointers point to null-terminated strings.  This approach produces fewer, more accurate results. |
| Overflow in uncontrolled allocation size (`cpp/uncontrolled-allocation-size`) | Fewer false positive results | The query now produces fewer, more accurate results. Cases where the tainted allocation size is range checked are more reliably excluded. |
| Overloaded assignment does not return 'this' (`cpp/assignment-does-not-return-this`) | Fewer false positive results | This query no longer reports incorrect results in template classes. |
| Signed overflow check (`cpp/signed-overflow-check`), Pointer overflow check (`cpp/pointer-overflow-check`), Possibly wrong buffer size in string copy (`cpp/bad-strncpy-size`) | More correct results | A new library is used for determining which expressions have identical value, giving more precise results. There is a performance cost to this, and the LGTM suite will overall run slower than before. |
| Unsafe array for days of the year (`cpp/leap-year/unsafe-array-for-days-of-the-year`) |  | This query is no longer run on LGTM. |
| Unsigned comparison to zero (`cpp/unsigned-comparison-zero`) | More correct results | This query now also looks for comparisons of the form `0 <= x`. |

## Changes to libraries

* The built-in C++20 "spaceship operator" (`<=>`) is now supported via the QL
  class `SpaceshipExpr`. Overloaded forms are modeled as calls to functions
  named `operator<=>`.
* The data-flow library (`semmle.code.cpp.dataflow.DataFlow` and
  `semmle.code.cpp.dataflow.TaintTracking`) has been improved, which affects
  and improves some security queries. The improvements are:
  - Track flow through functions that combine taint tracking with flow through fields.
  - Track flow through clone-like functions, that is, functions that read contents of a field from a
    parameter and stores the value in the field of a returned object.
* The security pack taint tracking library
  (`semmle.code.cpp.security.TaintTracking`) uses a new intermediate
  representation. This provides a more precise analysis of flow through
  parameters and pointers. For new queries, however, we continue to recommend
  using `semmle.code.cpp.dataflow.TaintTracking`.
* The global value numbering library
  (`semmle.code.cpp.valuenumbering.GlobalValueNumbering`) uses a new
  intermediate representation to provide a more precise analysis of
  heap-allocated memory and pointers to stack variables.
* Created the `semmle.code.cpp.models.interfaces.Allocation` library to model
  allocation such as `new` expressions and calls to `malloc`. This in intended
  to replace the functionality in `semmle.code.cpp.commons.Alloc` with a more
  consistent and useful interface.
  * The predicate `freeCall` in `semmle.code.cpp.commons.Alloc` has been
    deprecated. The`Allocation` and `Deallocation` models in
    `semmle.code.cpp.models.interfaces` should be used instead.
  * Created the `semmle.code.cpp.models.interfaces.Deallocation` library to
    model deallocation such as `delete` expressions and calls to `free`. This
    in intended to replace the functionality in `semmle.code.cpp.commons.Alloc`
    with a more consistent and useful interface.
* The new class `StackVariable` should be used in place of `LocalScopeVariable`
  in most cases. The difference is that `StackVariable` does not include
  variables declared with `static` or `thread_local`.
  * As a rule of thumb, custom queries about the _values_ of variables should
    be changed from `LocalScopeVariable` to `StackVariable`, while queries
    about the _name or scope_ of variables should remain unchanged.
  * The `LocalScopeVariableReachability` library is deprecated in favor of
    `StackVariableReachability`. The functionality is the same.
* Taint tracking and data flow now features better modeling of commonly-used
  library functions:
  * `gets` and similar functions,
  * the most common operations on `std::string`,
  * `strdup` and similar functions, and
  * formatting functions such as `sprintf`.
