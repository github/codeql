/** Provide classes to reason about Android Intents that can install APKs. */

import java
import semmle.code.java.frameworks.android.Intent
import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.FlowSources

/** A string literal that represents the MIME type for Android APKs. */
class PackageArchiveMimeTypeLiteral extends StringLiteral {
  PackageArchiveMimeTypeLiteral() { this.getValue() = "application/vnd.android.package-archive" }
}

/** The `android.content.Intent.ACTION_INSTALL_PACKAGE` constant. */
class InstallPackageAction extends Expr {
  InstallPackageAction() {
    this.(StringLiteral).getValue() = "android.intent.action.INSTALL_PACKAGE"
    or
    exists(VarAccess va |
      va.getVariable().hasName("ACTION_INSTALL_PACKAGE") and
      va.getQualifier().getType() instanceof TypeIntent
    )
  }
}

/** A method that sets the MIME type of an intent. */
class SetTypeMethod extends Method {
  SetTypeMethod() {
    this.hasName(["setType", "setTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/** A method that sets the data URI and the MIME type of an intent. */
class SetDataAndTypeMethod extends Method {
  SetDataAndTypeMethod() {
    this.hasName(["setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/** A method that sets the data URI of an intent. */
class SetDataMethod extends Method {
  SetDataMethod() {
    this.hasName(["setData", "setDataAndNormalize", "setDataAndType", "setDataAndTypeAndNormalize"]) and
    this.getDeclaringType() instanceof TypeIntent
  }
}

/** A dataflow sink for the URI of an intent. */
class SetDataSink extends ApiSinkNode, DataFlow::ExprNode {
  SetDataSink() {
    exists(MethodCall ma |
      this.getExpr() = ma.getQualifier() and
      ma.getMethod() instanceof SetDataMethod
    )
  }
}

/** A method that generates a URI. */
class UriConstructorMethod extends Method {
  UriConstructorMethod() {
    this.hasQualifiedName("android.net", "Uri", ["fromFile", "fromParts"]) or
    this.hasQualifiedName("androidx.core.content", "FileProvider", "getUriForFile")
  }
}

/**
 * A dataflow source representing the URIs which an APK not controlled by the
 * application may come from. Including external storage and web URLs.
 */
class ExternalApkSource extends ApiSourceNode {
  ExternalApkSource() {
    sourceNode(this, "android-external-storage-dir") or
    this.asExpr().(MethodCall).getMethod() instanceof UriConstructorMethod or
    this.asExpr().(StringLiteral).getValue().matches("file://%") or
    this instanceof ActiveThreatModelSource
  }
}

/** The `setAction` method of the `android.content.Intent` class. */
class SetActionMethod extends Method {
  SetActionMethod() {
    this.hasName("setAction") and
    this.getDeclaringType() instanceof TypeIntent
  }
}
