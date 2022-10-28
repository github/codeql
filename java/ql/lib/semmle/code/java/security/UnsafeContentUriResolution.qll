/** Provides classes to reason about vulnerabilites related to content URIs. */

import java
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.frameworks.android.Android
private import semmle.code.java.security.PathSanitizer

/** A URI that gets resolved by a `ContentResolver`. */
abstract class ContentUriResolutionSink extends DataFlow::Node { }

/** A sanitizer for content URIs. */
abstract class ContentUriResolutionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps to configurations related to
 * content URI resolution vulnerabilities.
 */
class ContentUriResolutionAdditionalTaintStep extends Unit {
  /** Holds if the step from `node1` to `node2` should be considered an additional taint step. */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** The URI argument of a call to a `ContentResolver` URI-opening method. */
private class DefaultContentUriResolutionSink extends ContentUriResolutionSink {
  DefaultContentUriResolutionSink() {
    exists(MethodAccess ma |
      ma.getMethod() instanceof UriOpeningContentResolverMethod and
      this.asExpr() = ma.getAnArgument() and
      this.getType().(RefType).hasQualifiedName("android.net", "Uri")
    )
  }
}

/** A `ContentResolver` method that resolves a URI. */
private class UriOpeningContentResolverMethod extends Method {
  UriOpeningContentResolverMethod() {
    this.hasName([
        "openInputStream", "openOutputStream", "openAssetFile", "openAssetFileDescriptor",
        "openFile", "openFileDescriptor", "openTypedAssetFile", "openTypedAssetFileDescriptor",
      ]) and
    this.getDeclaringType() instanceof AndroidContentResolver
  }
}

private class UninterestingTypeSanitizer extends ContentUriResolutionSanitizer {
  UninterestingTypeSanitizer() {
    this.getType() instanceof BoxedType or
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof NumberType
  }
}

private class PathSanitizer extends ContentUriResolutionSanitizer instanceof PathInjectionSanitizer {
}

private class FilenameOnlySanitizer extends ContentUriResolutionSanitizer {
  FilenameOnlySanitizer() {
    exists(Method m | this.asExpr().(MethodAccess).getMethod() = m |
      m.hasQualifiedName("java.io", "File", "getName") or
      m.hasQualifiedName("kotlin.io", "FilesKt", ["getNameWithoutExtension", "getExtension"]) or
      m.hasQualifiedName("org.apache.commons.io", "FilenameUtils", "getName")
    )
  }
}

/**
 * A `ContentUriResolutionSink` that flows to an image-decoding function.
 * Such functions raise exceptions when the input is not a valid image,
 * which prevents accessing arbitrary non-image files.
 */
private class DecodedAsAnImageSanitizer extends ContentUriResolutionSanitizer {
  DecodedAsAnImageSanitizer() {
    exists(Argument decodeArg, MethodAccess decode |
      decode.getArgument(0) = decodeArg and
      decode
          .getMethod()
          .hasQualifiedName("android.graphics", "BitmapFactory",
            [
              "decodeByteArray", "decodeFile", "decodeFileDescriptor", "decodeResource",
              "decodeStream"
            ])
    |
      TaintTracking::localExprTaint(this.(ContentUriResolutionSink).asExpr().(Argument).getCall(),
        decodeArg)
    )
  }
}
