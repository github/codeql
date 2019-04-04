# Improvements to C/C++ analysis

## General improvements

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| `()`-declared function called with too few arguments (`cpp/too-few-arguments`) | Correctness | Find all cases where the number of arguments is less than the number of parameters of the function, provided the function is also properly declared/defined elsewhere. | 
| `()`-declared function called with mismatched arguments (`cpp/mismatched-function-arguments`) | Correctness | Find all cases where the types of arguments do not match the types of parameters of the function, provided the function is also properly declared/defined elsewhere. | 

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Dead code due to goto or break statement (`cpp/dead-code-goto`) | Fewer false positive results | Functions containing preprocessor logic are now excluded from this analysis. |
| Mismatching new/free or malloc/delete (`cpp/new-free-mismatch`) | Fewer false positive results | Fixed an issue where functions were being identified as allocation functions inappropriately.  Also affects `cpp/new-array-delete-mismatch` and `cpp/new-delete-array-mismatch`. |
| Overflow in uncontrolled allocation size (`cpp/uncontrolled-allocation-size`) | More correct results | This query has been reworked so that it can find a wider variety of results. |
| Memory may not be freed (`cpp/memory-may-not-be-freed`) | More correct results | Support added for more Microsoft-specific allocation functions, including `LocalAlloc`, `GlobalAlloc`, `HeapAlloc` and `CoTaskMemAlloc`. |
| Memory is never freed (`cpp/memory-never-freed`) | More correct results | Support added for more Microsoft-specific allocation functions, including `LocalAlloc`, `GlobalAlloc`, `HeapAlloc` and `CoTaskMemAlloc`. |
| Resource not released in destructor (`cpp/resource-not-released-in-destructor`) | Fewer false positive results | Resource allocation and deallocation functions are now determined more accurately. |
| Comparison result is always the same | Fewer false positive results | The range analysis library is now more conservative about floating point values being possibly `NaN` |
| Wrong type of arguments to formatting function (`cpp/wrong-type-format-argument`) | More correct results and fewer false positive results | This query now more accurately identifies wide and non-wide string/character format arguments on different platforms.  Platform detection has also been made more accurate for the purposes of this query. |
| `()`-declared function called with too many arguments (`cpp/futile-params`) | Improved coverage | Query has been generalized to find all cases where the number of arguments exceedes the number of parameters of the function, provided the function is also properly declared/defined elsewhere. | 

## Changes to QL libraries
