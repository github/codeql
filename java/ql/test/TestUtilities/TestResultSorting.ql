/**
 * @kind test-postprocess
 */
query predicate resultRelations(string name) { name in ["B", "D", "F"] }

from int line, string name
where name = rank[line](string n | n in ["A", "C", "E"] | n)
select name, 0, 0, "empty"
