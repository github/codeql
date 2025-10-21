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

predicate unmonitored_access(
  ClassAnnotatedAsThreadSafe cls, ExposedFieldAccess a, Expr entry, string msg, string entry_desc
) {
  exists(ExposedField f |
    cls.unlocked_public_access(f, entry, _, a, true)
    or
    cls.unlocked_public_access(f, entry, _, a, false) and
    cls.has_public_write_access(f)
  ) and
  msg =
    "This field access (publicly accessible via $@) is not protected by any monitor, but the class is annotated as @ThreadSafe." and
  entry_desc = "this expression"
}

predicate not_fully_monitored_field(
  ClassAnnotatedAsThreadSafe cls, ExposedField f, string msg, string cls_name
) {
  (
    // Technically there has to be a write access for a conflict to exist.
    // But if you are locking your reads with different locks, you likely made a typo,
    // so in this case we alert without requiring `cls.has_public_write_access(f)`
    cls.single_monitor_mismatch(f)
    or
    cls.not_fully_monitored(f) and
    cls.has_public_write_access(f)
  ) and
  msg =
    "This field is not properly synchronized in that no single monitor covers all accesses, but the class $@ is annotated as @ThreadSafe." and
  cls_name = cls.getName()
}

from
  ClassAnnotatedAsThreadSafe cls, Top alert_element, Top alert_context, string alert_msg,
  string context_desc
where
  unmonitored_access(cls, alert_element, alert_context, alert_msg, context_desc)
  or
  not_fully_monitored_field(cls, alert_element, alert_msg, context_desc) and
  alert_context = cls
select alert_element, alert_msg, alert_context, context_desc
