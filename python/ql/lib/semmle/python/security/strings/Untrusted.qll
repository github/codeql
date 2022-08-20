import python
import External

/**
 * A kind of taint representing an externally controlled string.
 * This class is a simple sub-class of `ExternalStringKind`.
 */
deprecated class UntrustedStringKind extends ExternalStringKind {
  UntrustedStringKind() { this = "externally controlled string" }
}
