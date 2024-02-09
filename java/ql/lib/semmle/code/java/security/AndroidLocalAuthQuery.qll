/** Definitions for the insecure local authentication query. */

import java

/** A base class that is used as a callback for biometric authentication. */
private class AuthenticationCallbackClass extends Class {
  AuthenticationCallbackClass() {
    this.hasQualifiedName("android.hardware.fingerprint",
      "FingerprintManager$AuthenticationCallback")
    or
    this.hasQualifiedName("android.hardware.biometrics", "BiometricPrompt$AuthenticationCallback")
    or
    this.hasQualifiedName("androidx.biometric", "BiometricPrompt$AuthenticationCallback")
  }
}

/** An implementation of the `onAuthenticationSucceeded` method for an authentication callback. */
class AuthenticationSuccessCallback extends Method {
  AuthenticationSuccessCallback() {
    this.getDeclaringType().getASupertype+() instanceof AuthenticationCallbackClass and
    this.hasName("onAuthenticationSucceeded")
  }

  /** Gets the parameter containing the `authenticationResult`. */
  Parameter getResultParameter() { result = this.getParameter(0) }

  /** Gets a use of the result parameter that's used in a `super` call to the base `AuthenticationCallback` class. */
  private VarAccess getASuperResultUse() {
    exists(SuperMethodCall sup |
      sup.getEnclosingCallable() = this and
      result = sup.getArgument(0) and
      result = this.getResultParameter().getAnAccess() and
      this.getDeclaringType().getASupertype() instanceof AuthenticationCallbackClass
    )
  }

  /** Gets a use of the result parameter, other than one used in a `super` call. */
  VarAccess getAResultUse() {
    result = this.getResultParameter().getAnAccess() and
    not result = this.getASuperResultUse()
  }
}
