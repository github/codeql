/** Provides definitions related to the namespace `Microsoft`. */

import csharp

/** The `Microsoft` namespace. */
class MicrosoftNamespace extends Namespace {
  MicrosoftNamespace() {
    this.getParentNamespace() instanceof GlobalNamespace and
    this.hasName("Microsoft")
  }
}

/** The `Microsoft.Net.Http.Headers.HeaderNames` class. */
class MicrosoftNetHttpHeadersHeaderNames extends Class {
  MicrosoftNetHttpHeadersHeaderNames() {
    this.hasFullyQualifiedName("Microsoft.Net.Http.Headers", "HeaderNames")
  }

  /** Gets the `XFrameOptions` field. */
  Field getXFrameOptionsField() { result = this.getField("XFrameOptions") }

  /** Gets the `ContentSecurityPolicy` field. */
  Field getContentSecurityPolicyField() { result = this.getField("ContentSecurityPolicy") }
}
