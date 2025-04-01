/**
 * @id java/run-method-called-on-java-lang-thread-directly
 * @name J-D-001: Method call to `java.lang.Thread` or its subclasses may indicate a logical bug
 * @description Calling `run()` on `java.lang.Thread` or its subclasses may indicate
 *              misunderstanding on the programmer's part.
 * @kind problem
 * @precision very-high
 * @problem.severity warning
 * @tags correctness
 *       performance
 *       concurrency
 */

import java
import semmle.code.java.dataflow.DataFlow

/**
 * The import statement that brings java.lang.Thread into scope.
 */
class JavaLangThreadImport extends ImportType {
  JavaLangThreadImport() { this.getImportedType().hasQualifiedName("java.lang", "Thread") }
}

/**
 * A class that inherits from `java.lang.Thread` either directly or indirectly.
 */
class JavaLangThreadSubclass extends Class {
  JavaLangThreadSubclass() {
    exists(JavaLangThreadImport javaLangThread |
      this.getASupertype+() = javaLangThread.getImportedType()
    )
  }
}

class ProblematicRunMethodCall extends MethodCall {
  ProblematicRunMethodCall() {
    this.getMethod().getName() = "run" and
    (
      exists(JavaLangThreadImport javaLangThread |
        this.getQualifier().getType() = javaLangThread.getImportedType()
      )
      or
      exists(JavaLangThreadSubclass javaLangThreadSubclass |
        this.getQualifier().getType() = javaLangThreadSubclass
      )
    )
  }
}

from ProblematicRunMethodCall problematicRunMethodCall
select problematicRunMethodCall, "The run method is called directly on a thread instance."
