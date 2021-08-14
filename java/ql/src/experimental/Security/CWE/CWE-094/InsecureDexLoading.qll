import java
import semmle.code.java.dataflow.FlowSources

/**
 * A taint-tracking configuration detecting unsafe use of a
 * `DexClassLoader` by an Android app.
 */
class InsecureDexConfiguration extends TaintTracking::Configuration {
  InsecureDexConfiguration() { this = "Insecure Dex File Load" }

  override predicate isSource(DataFlow::Node source) { source instanceof InsecureDexSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof InsecureDexSink }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    flowStep(pred, succ)
  }
}

/** A data flow source for insecure Dex class loading vulnerabilities. */
abstract class InsecureDexSource extends DataFlow::Node { }

/** A data flow sink for insecure Dex class loading vulnerabilities. */
abstract class InsecureDexSink extends DataFlow::Node { }

private predicate flowStep(DataFlow::Node pred, DataFlow::Node succ) {
  // propagate from a `java.io.File` via the `File.getAbsolutePath` call.
  exists(MethodAccess m |
    m.getMethod().getDeclaringType() instanceof TypeFile and
    m.getMethod().hasName("getAbsolutePath") and
    m.getQualifier() = pred.asExpr() and
    m = succ.asExpr()
  )
  or
  // propagate from a `java.io.File` via the `File.toString` call.
  exists(MethodAccess m |
    m.getMethod().getDeclaringType() instanceof TypeFile and
    m.getMethod().hasName("toString") and
    m.getQualifier() = pred.asExpr() and
    m = succ.asExpr()
  )
  or
  // propagate to newly created `File` if the parent directory of the new `File` is tainted
  exists(ConstructorCall cc |
    cc.getConstructedType() instanceof TypeFile and
    cc.getArgument(0) = pred.asExpr() and
    cc = succ.asExpr()
  )
}

/**
 * An argument to a `DexClassLoader` call taken as a sink for
 * insecure Dex class loading vulnerabilities.
 */
private class DexClassLoader extends InsecureDexSink {
  DexClassLoader() {
    exists(ConstructorCall cc |
      cc.getConstructedType().hasQualifiedName("dalvik.system", "DexClassLoader")
    |
      this.asExpr() = cc.getArgument(0)
    )
  }
}

/**
 * A `File` instance which reads from an SD card
 * taken as a source for insecure Dex class loading vulnerabilities.
 */
private class ExternalFile extends InsecureDexSource {
  ExternalFile() {
    exists(ConstructorCall cc, Argument a |
      cc.getConstructedType() instanceof TypeFile and
      a = cc.getArgument(0) and
      a.(CompileTimeConstantExpr).getStringValue().matches("%sdcard%")
    |
      this.asExpr() = a
    )
  }
}

/**
 * A directory or file which may be stored in an world writable directory
 * taken as a source for insecure Dex class loading vulnerabilities.
 */
private class ExternalStorageDirSource extends InsecureDexSource {
  ExternalStorageDirSource() {
    exists(Method m |
      m.getDeclaringType().hasQualifiedName("android.os", "Environment") and
      m.hasName("getExternalStorageDirectory")
      or
      m.getDeclaringType().hasQualifiedName("android.content", "Context") and
      m.hasName([
          "getExternalFilesDir", "getExternalFilesDirs", "getExternalMediaDirs",
          "getExternalCacheDir", "getExternalCacheDirs"
        ])
    |
      this.asExpr() = m.getAReference()
    )
  }
}
