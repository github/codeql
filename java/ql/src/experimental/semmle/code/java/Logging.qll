/**
 * Provides classes and predicates for working with loggers.
 */

import java

/** Models a call to a logging method. */
class LoggingCall extends MethodAccess {
  LoggingCall() {
    exists(RefType t, Method m |
      t.hasQualifiedName("org.apache.log4j", "Category") or // Log4j 1
      t.hasQualifiedName("org.apache.logging.log4j", ["Logger", "LogBuilder"]) or // Log4j 2
      t.hasQualifiedName("org.apache.commons.logging", "Log") or
      // JBoss Logging (`org.jboss.logging.Logger` in some implementations like JBoss Application Server 4.0.4 did not implement `BasicLogger`)
      t.hasQualifiedName("org.jboss.logging", ["BasicLogger", "Logger"]) or
      t.hasQualifiedName("org.slf4j.spi", "LoggingEventBuilder") or
      t.hasQualifiedName("org.slf4j", "Logger") or
      t.hasQualifiedName("org.scijava.log", "Logger") or
      t.hasQualifiedName("com.google.common.flogger", "LoggingApi") or
      t.hasQualifiedName("java.lang", "System$Logger") or
      t.hasQualifiedName("java.util.logging", "Logger")
    |
      (
        m.getDeclaringType().getASourceSupertype*() = t or
        m.getDeclaringType().extendsOrImplements*(t)
      ) and
      m.getReturnType() instanceof VoidType and
      this = m.getAReference()
    )
    or
    exists(RefType t, Method m | t.hasQualifiedName("android.util", "Log") |
      m.hasName(["d", "e", "i", "v", "w", "wtf"]) and
      m.getDeclaringType() = t and
      this = m.getAReference()
    )
  }

  /** Returns an argument which would be logged by this call. */
  Argument getALogArgument() { result = this.getArgument(_) }
}
