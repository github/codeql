/** Provides classes representing various flow sources for data flow / taint tracking. */

private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A data flow source node.
 */
abstract class SourceNode extends DataFlow::Node { }

/**
 * Module that adds all API like sources to `SourceNode`, excluding some sources for cryptography based
 * queries, and queries where sources are not succifiently defined (eg. using broad method name matching).
 */
private module ApiSources {
  private import FlowSources as FlowSources
  private import semmle.code.java.security.ArbitraryApkInstallation as ArbitraryApkInstallation
  private import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery as CleartextStorageAndroidDatabaseQuery
  private import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery as CleartextStorageAndroidFilesystemQuery
  private import semmle.code.java.security.CleartextStorageCookieQuery as CleartextStorageCookieQuery
  private import semmle.code.java.security.CleartextStorageSharedPrefsQuery as CleartextStorageSharedPrefsQuery
  private import semmle.code.java.security.ImplicitPendingIntentsQuery as ImplicitPendingIntentsQuery
  private import semmle.code.java.security.ImproperIntentVerificationQuery as ImproperIntentVerificationQuery
  private import semmle.code.java.security.InsecureTrustManager as InsecureTrustManager
  private import semmle.code.java.security.JWT as Jwt
  private import semmle.code.java.security.StackTraceExposureQuery as StackTraceExposureQuery
  private import semmle.code.java.security.ZipSlipQuery as ZipSlipQuery

  private class FlowSourcesSourceNode extends SourceNode instanceof FlowSources::SourceNode { }

  private class ArbitraryApkInstallationSources extends SourceNode instanceof ArbitraryApkInstallation::ExternalApkSource
  { }

  private class CleartextStorageAndroidDatabaseQuerySources extends SourceNode instanceof CleartextStorageAndroidDatabaseQuery::LocalDatabaseOpenMethodCallSource
  { }

  private class CleartextStorageAndroidFilesystemQuerySources extends SourceNode instanceof CleartextStorageAndroidFilesystemQuery::LocalFileOpenCallSource
  { }

  private class CleartextStorageCookieQuerySources extends SourceNode instanceof CleartextStorageCookieQuery::CookieSource
  { }

  private class CleartextStorageSharedPrefsQuerySources extends SourceNode instanceof CleartextStorageSharedPrefsQuery::SharedPreferencesEditorMethodCallSource
  { }

  private class ImplicitPendingIntentsQuerySources extends SourceNode instanceof ImplicitPendingIntentsQuery::ImplicitPendingIntentSource
  { }

  private class ImproperIntentVerificationQuerySources extends SourceNode instanceof ImproperIntentVerificationQuery::VerifiedIntentConfigSource
  { }

  private class InsecureTrustManagerSources extends SourceNode instanceof InsecureTrustManager::InsecureTrustManagerSource
  { }

  private class JwtSources extends SourceNode instanceof Jwt::JwtParserWithInsecureParseSource { }

  private class StackTraceExposureQuerySources extends SourceNode instanceof StackTraceExposureQuery::GetMessageFlowSource
  { }

  private class ZipSlipQuerySources extends SourceNode instanceof ZipSlipQuery::ArchiveEntryNameMethodSource
  { }

  /**
   * Add all models as data sources.
   */
  private class SourceNodeExternal extends SourceNode {
    SourceNodeExternal() { sourceNode(this, _) }
  }
}
