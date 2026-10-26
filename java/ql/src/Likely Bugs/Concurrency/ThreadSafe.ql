/**
 * @name Not thread-safe
 * @description This class is not thread-safe. It is annotated as `@ThreadSafe`, but it has a
 *              conflicting access to a field that is not synchronized with the same monitor.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id java/not-threadsafe
 * @tags quality
 *       reliability
 *       concurrency
 */

import java
import semmle.code.java.ConflictingAccess

predicate unmonitoredAccess(ExposedFieldAccess a, string msg, Expr entry, string entry_desc) {
  exists(ClassAnnotatedAsThreadSafe cls, ExposedField f |
    cls.unlockedPublicAccess(f, entry, _, a, true)
    or
    cls.unlockedPublicAccess(f, entry, _, a, false) and
    cls.hasPublicWriteAccess(f)
  ) and
  msg =
    "This field access (publicly accessible via $@) is not protected by any monitor, but the class is annotated as @ThreadSafe." and
  entry_desc = "this expression"
}

predicate notFullyMonitoredField(
  ExposedField f, string msg, ClassAnnotatedAsThreadSafe cls, string cls_name
) {
  (
    // Technically there has to be a write access for a conflict to exist.
    // But if you are locking your reads with different locks, you likely made a typo,
    // so in this case we alert without requiring `cls.has_public_write_access(f)`
    cls.singleMonitorMismatch(f)
    or
    cls.notFullyMonitored(f) and
    cls.hasPublicWriteAccess(f)
  ) and
  msg =
    "This field is not properly synchronized in that no single monitor covers all accesses, but the class $@ is annotated as @ThreadSafe." and
  cls_name = cls.getName()
}

from Top alert_element, Top alert_context, string alert_msg, string context_desc
where
  unmonitoredAccess(alert_element, alert_msg, alert_context, context_desc)
  or
  notFullyMonitoredField(alert_element, alert_msg, alert_context, context_desc)
select alert_element, alert_msg, alert_context, context_desc
