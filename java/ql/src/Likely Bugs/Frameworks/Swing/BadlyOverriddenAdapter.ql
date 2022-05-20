/**
 * @name Bad implementation of an event Adapter
 * @description In a class that extends a Swing or Abstract Window Toolkit event adapter, an
 *              event handler that does not have exactly the same name as the event handler that it
 *              overrides means that the overridden event handler is not called.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/wrong-swing-event-adapter-signature
 * @tags reliability
 *       maintainability
 *       frameworks/swing
 */

import java

class Adapter extends Class {
  Adapter() {
    this.getName().matches("%Adapter") and
    (
      this.getPackage().hasName("java.awt.event") or
      this.getPackage().hasName("javax.swing.event")
    )
  }
}

from Class c, Adapter adapter, Method m
where
  adapter = c.getASupertype() and
  c = m.getDeclaringType() and
  exists(Method original | adapter = original.getDeclaringType() | m.getName() = original.getName()) and
  not exists(Method overridden | adapter = overridden.getDeclaringType() | m.overrides(overridden)) and
  // The method is not used for any other purpose.
  not exists(MethodAccess ma | ma.getMethod() = m)
select m,
  "Method " + m.getName() + " attempts to override a method in " + adapter.getName() +
    ", but does not have the same argument types. " + m.getName() +
    " will not be called when an event occurs."
