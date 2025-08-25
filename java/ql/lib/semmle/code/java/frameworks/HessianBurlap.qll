/**
 * Provides classes and predicates for working with the HessianBurlap framework.
 */
overlay[local?]
module;

import java

/**
 * The classes `[com.alibaba.]com.caucho.hessian.io.AbstractHessianInput` or `[com.alibaba.]com.caucho.hessian.io.Hessian2StreamingInput`.
 */
class UnsafeHessianInput extends RefType {
  UnsafeHessianInput() {
    this.hasQualifiedName(["com.caucho.hessian.io", "com.alibaba.com.caucho.hessian.io"],
      ["AbstractHessianInput", "Hessian2StreamingInput"])
  }
}

/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 * A AbstractHessianInput or Hessian2StreamingInput subclass readObject method.
 * This is either `AbstractHessianInput.readObject` or `Hessian2StreamingInput.readObject`.
 */
deprecated class UnsafeHessianInputReadObjectMethod extends Method {
  UnsafeHessianInputReadObjectMethod() {
    this.getDeclaringType().getAnAncestor() instanceof UnsafeHessianInput and
    this.getName() = "readObject"
  }
}

/**
 * The class `com.caucho.burlap.io.BurlapInput`.
 */
class BurlapInput extends RefType {
  BurlapInput() { this.hasQualifiedName("com.caucho.burlap.io", "BurlapInput") }
}

/**
 * DEPRECATED: Now modeled using data extensions instead.
 *
 *  A method with the name `readObject` declared in `com.caucho.burlap.io.BurlapInput`.
 */
deprecated class BurlapInputReadObjectMethod extends Method {
  BurlapInputReadObjectMethod() {
    this.getDeclaringType() instanceof BurlapInput and
    this.getName() = "readObject"
  }
}

/** A method with the name `init` declared in `com.caucho.burlap.io.BurlapInput`. */
class BurlapInputInitMethod extends Method {
  BurlapInputInitMethod() {
    this.getDeclaringType() instanceof BurlapInput and
    this.getName() = "init"
  }
}
