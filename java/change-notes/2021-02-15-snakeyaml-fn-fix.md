lgtm,codescanning
* The query "Unsafe Deserialization" (`java/unsafe-deserialization`) has been
  improved to report those cases where SnakeYaml `Constructor` is used to fix
  the unmarshaled object graph root's type but injection is still possible in
  nested nodes of the object graph.
