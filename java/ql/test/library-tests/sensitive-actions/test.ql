import java
import semmle.code.java.security.SensitiveActions

query predicate sensitiveMethodAccess(SensitiveMethodAccess ma) { any() }

query predicate sensitiveVarAccess(SensitiveVarAccess va) { any() }

query predicate sensitiveVariable(Variable v) {
  v.getName().regexpMatch(getCommonSensitiveInfoRegex())
}

query predicate sensitiveDataMethod(SensitiveDataMethod m) { m.fromSource() }
