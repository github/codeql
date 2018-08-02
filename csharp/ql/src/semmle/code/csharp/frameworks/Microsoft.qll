/** Provides definitions related to the namespace `Microsoft`. */
import csharp

/** The `Microsoft` namespace. */
class MicrosoftNamespace extends Namespace {
  MicrosoftNamespace() {
    this.getParentNamespace() instanceof GlobalNamespace and
    this.hasName("Microsoft")
  }
}

/** DEPRECATED. Gets the `Microsoft` namespace. */
deprecated
MicrosoftNamespace getMicrosoftNamespace() { any() }
