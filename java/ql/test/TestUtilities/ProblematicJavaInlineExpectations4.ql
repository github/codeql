/**
 * @kind test-postprocess
 */
module;

query predicate resultRelations(string name, int arity) { name = "#select" and arity = 5 }

select "#select", 1, 1, "foo"
