private import cpp

/**
 * A `Function` that is considered a "safe" external API from a security perspective.
 */
abstract class SafeExternalAPIFunction extends Function { }

/** The default set of "safe" external APIs. */
private class DefaultSafeExternalAPIFunction extends SafeExternalAPIFunction {
  DefaultSafeExternalAPIFunction() { this.hasGlobalName(["strcmp", "strlen", "memcmp"]) }
}
