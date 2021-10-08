import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.frameworks.ActiveRecord

query predicate activeRecordModelClasses(ActiveRecordModelClass cls) { any() }

query predicate activeRecordSqlExecutionRanges(ActiveRecordSqlExecutionRange range) { any() }

query predicate activeRecordModelClassMethodCalls(ActiveRecordModelClassMethodCall call) { any() }

query predicate potentiallyUnsafeSqlExecutingMethodCall(PotentiallyUnsafeSqlExecutingMethodCall call) {
  any()
}

query predicate activeRecordModelInstantiations(
  ActiveRecordModelInstantiation i, ActiveRecordModelClass cls
) {
  i.getClass() = cls
}
