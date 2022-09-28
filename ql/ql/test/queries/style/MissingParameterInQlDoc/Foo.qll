/** `param1`, `param2`, and `param3` are the parameters. */
predicate test1(int param1, int param2, int param3) { none() } // OK

/** `param1`, `par2` */
predicate test2(int param1, int param2) { none() } // NOT OK - `par2` is not a parameter, and `param2` has no documentation

/** `param1`, `par2 + par3` */
predicate test3(int param1, int par2, int par3) { none() } // OK

/** this mentions no parameters */
predicate test4(int param1, int param2) { none() } // OK - the QLDoc mentions none of the parameters, that's OK

/** the param1 parameter is mentioned in a non-code block, but the `par2` parameter is misspelled */
predicate test5(int param1, int param2) { none() } // NOT OK - the `param1` parameter is "documented" in clear text, but `par2` is misspelled
