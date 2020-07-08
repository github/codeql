import python

/*
 * Parameters with defaults that are used as an optimization.
 * E.g. def f(x, len=len): ...
 * (In general, this kind of optimization is not recommended.)
 */

predicate optimizing_parameter(Parameter p) {
  exists(string name, Name glob | p.getDefault() = glob |
    glob.getId() = name and
    p.asName().getId() = name
  )
}
