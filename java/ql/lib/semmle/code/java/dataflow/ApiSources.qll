/** Provides classes representing various flow sources for data flow / taint tracking. */

private import semmle.code.java.dataflow.FlowSources as FlowSources

final class SourceNode = FlowSources::ApiSourceNode;

/**
 * Module that adds all API like sources to `SourceNode`, excluding some sources for cryptography based
 * queries, and queries where sources are not succifiently defined (eg. using broad method name matching).
 */
private module AllApiSources {
  private import semmle.code.java.security.ArbitraryApkInstallation
  private import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery
  private import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery
  private import semmle.code.java.security.CleartextStorageCookieQuery
  private import semmle.code.java.security.CleartextStorageSharedPrefsQuery
  private import semmle.code.java.security.ImplicitPendingIntentsQuery
  private import semmle.code.java.security.ImproperIntentVerificationQuery
  private import semmle.code.java.security.InsecureTrustManager
  private import semmle.code.java.security.JWT
  private import semmle.code.java.security.StackTraceExposureQuery
  private import semmle.code.java.security.SensitiveDataExposureThroughErrorMessageQuery
  private import semmle.code.java.security.ZipSlipQuery
}
