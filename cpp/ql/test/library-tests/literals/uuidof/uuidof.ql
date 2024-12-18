import cpp

query predicate classUuids(Class cls, string uuid) {
  if exists(cls.getUuid()) then uuid = cls.getUuid() else uuid = ""
}

query predicate uuidofOperators(UuidofOperator op, string type, string uuid) {
  (if exists(op.getValue()) then uuid = op.getValue() else uuid = "") and
  type = op.getType().toString()
}
