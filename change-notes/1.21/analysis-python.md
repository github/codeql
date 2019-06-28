# Improvements to Python analysis


## General improvements

Points-to analysis has been re-implemented to support more language features and provide better reachability analysis.
The new implementation adds the following new features:

* Non-local tracking of bound methods and instances of `super()`
* Superior analysis of conditionals and thus improved reachability analysis.
* Superior modelling of descriptors, for example, classmethods and staticmethods.
* Superior tracking of values through parameters, especially `*` arguments.

A new object API has been provided to complement the new points-to implementation.
A new class `Value` replaces the old `Object` class. The `Value` class has a simpler and more consistent API compared to `Object`.
Some of the functionality of `FunctionObject` and `ClassObject` has been added to `Value` to reduce the number of casts to more specific classes.
For example, the QL to find calls to `os.path.open` has changed from
`ModuleObject::named("os").attr("path").(ModuleObject).attr("join").(FunctionObject).getACall()`
to
`Value::called("os.path.join").getACall()`

The old API is now deprecated, but will be continued to be supported for at least another year.

### Impact on existing queries.

As points-to analysis underpins many queries, and provides the call-graph and reachability analysis required for taint-tracking, the results of many queries may change.

The improved reachability analysis and non-local tracking of bound methods may identify new results.
The increased precision in tracking of values through `*` arguments may remove false positive results.

Overall the number of true positive results should increase and the number false negative results should decline.
We welcome feedback on the new implementation, particularly any surprising changes in results.

## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Accepting unknown SSH host keys when using Paramiko (`py/paramiko-missing-host-key-validation`) | security, external/cwe/cwe-295 | Finds instances where Paramiko is configured to accept unknown host keys. Results are shown [on LGTM](https://lgtm.com/rules/1508297729270/) by default. |
| Pythagorean calculation with sub-optimal numerics (`py/pythagorean`) | accuracy | Finds instances of hypotenuse calculation using `math.sqrt` instead of `math.hypot`. Results are not shown on LGTM by default. |
| Use of 'return' or 'yield' outside a function (`py/return-or-yield-outside-function`) | reliability, correctness | Finds instances where `return`, `yield`, and `yield from` are used outside a function. Results are not shown on LGTM by default. |

## Changes to code extraction

* String literals as expressions within literal string interpolation (f-strings) are now handled correctly.

* The Python extractor now handles invalid input more robustly. In particular, it exits gracefully when:

    * A non-existent file or directory is specified using the `--path` option, or as a file name.
    * An invalid number is specified for the `--max-procs` option.
