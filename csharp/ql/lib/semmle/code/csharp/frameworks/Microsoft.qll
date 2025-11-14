/** Provides definitions related to the namespace `Microsoft`. */
overlay[local?]
module;

import csharp

/** The `Microsoft` namespace. */
class MicrosoftNamespace extends Namespace {
  MicrosoftNamespace() {
    this.getParentNamespace() instanceof GlobalNamespace and
    this.hasName("Microsoft")
  }
}
