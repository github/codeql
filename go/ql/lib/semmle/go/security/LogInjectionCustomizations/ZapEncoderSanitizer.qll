/**
 * Provides a taint tracking configuration for zap encoders that are known to remove or escape
 * newline characters, thus mitigating log injection (CWE-117).
 */

import go

/**
 * isKnownSanitizer(Function f)
 * - True for explicit sanitizer functions (add fully-qualified names as needed).
 */
predicate isKnownSanitizer(Function f) {
  exists(string fullname |
    fullname = f.getDeclaringType().getPackage().getName() + "." + f.getName() and
    (
      fullname = "github.com/myorg/mylib.EscapeForLog" or
      fullname = "github.com/myorg/mylib.SanitizeForZap"
    )
  )
}

/**
 * isZapEncoderLike(Type t)
 * - True for types that implement go.uber.org/zap/zapcore.Encoder
 * - If you prefer explicit whitelisting, replace/extend this predicate.
 */
predicate isZapEncoderLike(Type t) {
  exists(InterfaceType it |
    it.getPackage().getName() = "go.uber.org/zap/zapcore" and
    it.getName() = "Encoder" and
    t.implementsInterface(it)
  )
}

/**
 * isFlowThroughZapEncoder(Function f)
 * - True for functions/methods that act on encoder types (AddString, Encode, etc.)
 */
predicate isFlowThroughZapEncoder(Function f) {
  exists(Type recv |
    f.getDeclaringType() = recv and
    isZapEncoderLike(recv)
  )
  or
  (
    f.getName() = "AddString" or
    f.getName() = "AddStringer" or
    f.getName() = "AddReflected" or
    f.getName() = "EncodeEntry" or
    f.getName() = "Encode"
  )
}

/**
 * isSanitizer(Function f)
 * - Top-level predicate used by queries to test for sanitization steps.
 */
predicate isSanitizer(Function f) {
  isKnownSanitizer(f) or isFlowThroughZapEncoder(f)
}