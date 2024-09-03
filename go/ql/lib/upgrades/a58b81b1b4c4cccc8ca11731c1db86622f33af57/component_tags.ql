class StructType extends @structtype {
  string toString() { result = "struct type" }
}

from StructType st, int index
where component_types(st, index, _, _)
select st, index, ""
