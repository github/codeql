/**
 * @name Explicit thread priority
 * @description Setting thread priorities to control interactions between threads is not portable,
 *              and may not have the desired effect.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/thread-priority
 * @tags portability
 *       correctness
 *       concurrency
 */

import java

class PriorityMethod extends Method {
  PriorityMethod() {
    (this.getName() = "setPriority" or this.getName() = "getPriority") and
    this.getDeclaringType().hasQualifiedName("java.lang", "Thread")
  }
}

class PriorityMethodAccess extends MethodAccess {
  PriorityMethodAccess() { this.getMethod() instanceof PriorityMethod }
}

from PriorityMethodAccess ma
where ma.getCompilationUnit().fromSource()
select ma, "Avoid using thread priorities. The effect is unpredictable and not portable."
