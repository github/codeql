import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.frameworks.ActiveRecord
import codeql.ruby.Concepts
import codeql.ruby.DataFlow

query predicate activeRecordModelClasses(ActiveRecordModelClass cls) { any() }

query predicate activeRecordInstances(ActiveRecordInstance i) { any() }

query predicate activeRecordSqlExecutionRanges(ActiveRecordSqlExecutionRange range) { any() }

deprecated query predicate activeRecordModelClassMethodCalls(ActiveRecordModelClassMethodCall call) {
  any()
}

query predicate activeRecordModelClassMethodCallsReplacement(
  ActiveRecordModelClass cls, DataFlow::CallNode call
) {
  call = cls.getClassNode().trackModule().getAMethodCall(_)
}

deprecated query predicate potentiallyUnsafeSqlExecutingMethodCall(
  PotentiallyUnsafeSqlExecutingMethodCall call
) {
  any()
}

query predicate activeRecordModelInstantiations(
  ActiveRecordModelInstantiation i, ActiveRecordModelClass cls
) {
  i.getClass() = cls
}

query predicate persistentWriteAccesses(PersistentWriteAccess w, DataFlow::Node value) {
  w.getValue() = value
}
