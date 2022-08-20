/**
 * GigaSpaces XAP (eXtreme Application Platform) is a distributed in-memory "datagrid".
 */

import java
import semmle.code.java.deadcode.DeadCode
import semmle.code.java.frameworks.gigaspaces.GigaSpaces

/**
 * A method that is called during event processing by GigaSpaces, on an event listener class.
 *
 * Note: We do not track registrations of the classes containing these methods. Instead, the method
 * is considered live if the listener is at some point constructed.
 */
class GigaSpacesEventCallableEntryPoint extends CallableEntryPointOnConstructedClass {
  GigaSpacesEventCallableEntryPoint() { isGigaSpacesEventMethod(this) }
}

/**
 * An event listener class that is reflectively constructed by GigaSpaces to handle event processing.
 */
class GigaSpacesEventDrivenReflectivelyConstructed extends ReflectivelyConstructedClass {
  GigaSpacesEventDrivenReflectivelyConstructed() { isGigaSpacesEventDrivenClass(this) }
}

/**
 * A method that is called when a GigaSpaces "SpaceClass" is written to, or read from, a space.
 *
 * Note: We do not track whether the space class is written to or read from a space. Instead, the
 * methods are considered live if the space class is at some point constructed.
 */
class GigaSpacesSpaceClassMethodEntryPoint extends CallableEntryPointOnConstructedClass {
  GigaSpacesSpaceClassMethodEntryPoint() {
    this instanceof GigaSpacesSpaceIdGetterMethod or
    this instanceof GigaSpacesSpaceIdSetterMethod or
    this instanceof GigaSpacesSpaceRoutingMethod
  }
}
