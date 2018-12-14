/**
 * @name Useless run() method in thread
 * @description Thread instances that neither get an argument of type 'Runnable' passed to their
 *              constructor nor override the 'Thread.run' method are likely to have no effect.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/empty-run-method-in-thread
 * @tags reliability
 *       correctness
 *       concurrency
 */

import java

class ThreadClass extends Class {
  ThreadClass() { this.hasQualifiedName("java.lang", "Thread") }

  /**
   * Any constructor of `java.lang.Thread` _without_ a parameter of type `Runnable`;
   * these require overriding the `Thread.run()` method in order to do anything useful.
   */
  Constructor getAConstructorWithoutRunnableParam() {
    result = this.getAConstructor() and
    (
      result.getNumberOfParameters() = 0
      or
      result.getNumberOfParameters() = 1 and
      result.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "String")
      or
      result.getNumberOfParameters() = 2 and
      result.getParameter(0).getType().(RefType).hasQualifiedName("java.lang", "ThreadGroup") and
      result.getParameter(1).getType().(RefType).hasQualifiedName("java.lang", "String")
    )
  }

  /**
   * Any constructor of `java.lang.Thread` _with_ a parameter of type `Runnable`;
   * these ensure that the `Thread.run()` method calls the `Runnable.run()` method.
   */
  Constructor getAConstructorWithRunnableParam() {
    result = this.getAConstructor() and
    not exists(Constructor c | c = result | result = this.getAConstructorWithoutRunnableParam())
  }
}

from ClassInstanceExpr cie, ThreadClass thread, Class emptythread
where
  emptythread.hasSupertype*(thread) and
  not exists(Class middle, Method run |
    run.hasName("run") and
    run.isPublic() and
    not run.isAbstract() and
    run.hasNoParameters() and
    middle.getAMethod() = run and
    middle.hasSupertype+(thread) and
    emptythread.hasSupertype*(middle)
  ) and
  not cie.getConstructor().callsConstructor*(thread.getAConstructorWithRunnableParam()) and
  cie.getType().(RefType).getSourceDeclaration() = emptythread
select cie,
  "Thread " + emptythread.getName() + " has a useless empty run() inherited from java.lang.Thread."
