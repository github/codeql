import java
import semmle.code.java.controlflow.UnreachableBlocks

/**
 * Exclude from the unreachable block analysis constant fields that look like they are flags for
 * controlling debugging, profiling or logging features.
 *
 * Debugging, profiling and logging flags that are compile time constants are usually intended to be
 * toggled by the developer at compile time to provide extra information when developing the
 * application, or when triaging a problem. By including this sub-class, blocks that are unreachable
 * because they are guarded by a check of such a flag are considered reachable.
 *
 * Note: we explicitly limit this to debugging, profiling and logging flags. True feature toggles
 * are treated as constant true/false, because it is much less likely that they are toggled in
 * practice.
 */
class ExcludeDebuggingProfilingLogging extends ExcludedConstantField {
  ExcludeDebuggingProfilingLogging() {
    exists(string validFieldName |
      validFieldName = "debug" or
      validFieldName = "profiling" or
      validFieldName = "profile" or
      validFieldName = "time" or
      validFieldName = "verbose" or
      validFieldName = "report" or
      validFieldName = "dbg" or
      validFieldName = "timing" or
      validFieldName = "assert" or
      validFieldName = "log"
    |
      getName().regexpMatch(".*(?i)" + validFieldName + ".*")
    ) and
    // Boolean type
    (
      getType().hasName("boolean") or
      getType().(BoxedType).hasQualifiedName("java.lang", "Boolean")
    )
  }
}
