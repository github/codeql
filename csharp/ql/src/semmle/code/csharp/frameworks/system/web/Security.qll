/** Provides classes related to the namespace `System.Web.Security`. */

import csharp
private import semmle.code.csharp.frameworks.system.Web

/** The `System.Web.Security` namespace. */
class SystemWebSecurityNamespace extends Namespace {
  SystemWebSecurityNamespace() {
    this.getParentNamespace() instanceof SystemWebNamespace and
    this.hasName("Security")
  }
}

/** A class in the `System.Web.Security` namespace. */
class SystemWebSecurityClass extends Class {
  SystemWebSecurityClass() { this.getNamespace() instanceof SystemWebSecurityNamespace }
}

/** The `System.Web.Security.MembershipUser` class. */
class SystemWebSecurityMembershipUserClass extends SystemWebSecurityClass {
  SystemWebSecurityMembershipUserClass() { this.hasName("MembershipUser") }
}

/** The `System.Web.Security.Membership` class. */
class SystemWebSecurityMembershipClass extends SystemWebSecurityClass {
  SystemWebSecurityMembershipClass() { this.hasName("Membership") }

  /** Gets the `ValidateUser` method. */
  Method getValidateUserMethod() { result = this.getAMethod("ValidateUser") }
}

/** The `System.Web.Security.FormsAuthentication` class. */
class SystemWebSecurityFormsAuthenticationClass extends SystemWebSecurityClass {
  SystemWebSecurityFormsAuthenticationClass() { this.hasName("FormsAuthentication") }

  /** Gets the `Authenticate` method. */
  Method getAuthenticateMethod() { result = this.getAMethod("Authenticate") }

  /** Gets the `SignOut` method. */
  Method getSignOutMethod() { result = this.getAMethod("SignOut") }
}
