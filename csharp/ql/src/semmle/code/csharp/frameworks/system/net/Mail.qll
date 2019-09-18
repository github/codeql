/** Provides classes related to the namespace `System.Net.Mail`. */

import csharp
private import semmle.code.csharp.frameworks.system.Net

/** The `System.Net.Mail` namespace. */
class SystemNetMailNamespace extends Namespace {
  SystemNetMailNamespace() {
    this.getParentNamespace() instanceof SystemNetNamespace and
    this.hasName("Mail")
  }
}

/** A class in the `System.Net.Mail` namespace. */
class SystemNetMailClass extends Class {
  SystemNetMailClass() { this.getNamespace() instanceof SystemNetMailNamespace }
}

/** The class `System.Net.Mail.MailMessage`. */
class SystemNetMailMailMessageClass extends SystemNetMailClass {
  SystemNetMailMailMessageClass() { this.hasName("MailMessage") }

  /** Gets the `Body` property. */
  Property getBodyProperty() { result = this.getProperty("Body") }

  /** Gets the `Subject` property. */
  Property getSubjectProperty() { result = this.getProperty("Subject") }
}
