/** Provides classes to reason about vulnerabilites related to content URIs. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.android.Android

/** A URI that gets resolved by a `ContentResolver`. */
abstract class ContentUriResolutionSink extends DataFlow::Node {
  /** Gets the call node that resolves this URI. */
  abstract DataFlow::Node getCallNode();
}

/** A sanitizer for content URIs. */
abstract class ContentUriResolutionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps to configurations related to
 * content URI resolution vulnerabilities.
 */
abstract class ContentUriResolutionAdditionalTaintStep extends Unit {
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

  /** Gets the call node of this argument. */
  override DataFlow::Node getCallNode() {
    result = DataFlow::exprNode(this.asExpr().(Argument).getCall())
  }
}

private class UninterestingTypeSanitizer extends ContentUriResolutionSanitizer {
  UninterestingTypeSanitizer() {
    this.getType() instanceof BoxedType or
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof NumberType
  }
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
      DataFlow::localFlow(this.(ContentUriResolutionSink).getCallNode(),
        DataFlow::exprNode(decodeArg))
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
