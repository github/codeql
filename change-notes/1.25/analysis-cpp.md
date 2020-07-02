# Improvements to C/C++ analysis

The following changes in version 1.25 affect C/C++ analysis in all applications.

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Uncontrolled format string (`cpp/tainted-format-string`) |  | This query is now displayed by default on LGTM. |
| Uncontrolled format string (through global variable) (`cpp/tainted-format-string-through-global`) |  | This query is now displayed by default on LGTM. |

## Changes to libraries

* The library `VCS.qll` and all queries that imported it have been removed.
* The data-flow library has been improved, which affects most security queries by potentially
  adding more results. Flow through functions now takes nested field reads/writes into account.
  For example, the library is able to track flow from `taint()` to `sink()` via the method
  `getf2f1()` in
  ```c
  struct C {
      int f1;
  };

  struct C2
  {
      C f2;

      int getf2f1() {
          return f2.f1; // Nested field read
      }

      void m() {
          f2.f1 = taint();
          sink(getf2f1()); // NEW: taint() reaches here
      }
  };
  ```
* The security pack taint tracking library (`semmle.code.cpp.security.TaintTracking`) now considers that equality checks may block the flow of taint.  This results in fewer false positive results from queries that use this library.
* The length of a tainted string (such as the return value of a call to `strlen` or `strftime` with tainted parameters) is no longer itself considered tainted by the `models` library.  This leads to fewer false positive results in queries that use any of our taint libraries.
