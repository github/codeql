import codeql.ruby.DataFlow
import codeql.ruby.Concepts

query predicate ormFieldWrites(OrmWriteAccess acc, string fieldName, DataFlow::Node value) {
  fieldName = acc.getFieldNameAssignedTo(value)
}
