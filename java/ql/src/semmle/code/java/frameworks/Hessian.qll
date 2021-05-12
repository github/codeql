/**
 * Provides classes and predicates for working with the Hession framework.
 */

import java

/**
 * The class `com.caucho.hessian.io.HessianInput` or `com.caucho.hessian.io.Hessian2Input`.
 */
class UnSafeHessianInput extends RefType {
  UnSafeHessianInput() {
    this.hasQualifiedName("com.caucho.hessian.io", ["HessianInput", "Hessian2Input"])
  }
}

/**
 * A HessianInput readObject method. This is either `HessianInput.readObject` or `Hessian2Input.readObject`.
 */
class UnSafeHessianInputReadObjectMethod extends Method {
  UnSafeHessianInputReadObjectMethod() {
    this.getDeclaringType() instanceof UnSafeHessianInput and
    this.getName() = "readObject"
  }
}

/**
 * The class `com.caucho.burlap.io.BurlapInput`.
 */
class BurlapInput extends RefType {
  BurlapInput() { this.hasQualifiedName("com.caucho.burlap.io", "BurlapInput") }
}

/** A method with the name `readObject` declared in `com.caucho.burlap.io.BurlapInput`. */
class BurlapInputReadObjectMethod extends Method {
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
