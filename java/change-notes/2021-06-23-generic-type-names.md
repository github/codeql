lgtm,codescanning
* Static inner classes and static methods' enclosing and declaring types are now unbound rather than raw types. This means that, for example, Map.Entry's name is now `Map$Entry` not `Map<>$Entry` as before. This may impact custom queries that explicitly named these types.
