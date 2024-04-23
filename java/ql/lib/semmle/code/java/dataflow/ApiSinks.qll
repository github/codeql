/** Provides classes representing various flow sinks for data flow / taint tracking. */

private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow

/**
 * A data flow sink node.
 */
abstract class SinkNode extends DataFlow::Node { }

/**
 * Module that adds all API like sinks to `SinkNode`, excluding sinks for cryptography based
 * queries, and queries where sinks are not succifiently defined (eg. using broad method name matching).
 */
private module ApiSinks {
  private import semmle.code.java.security.AndroidSensitiveCommunicationQuery as AndroidSensitiveCommunicationQuery
  private import semmle.code.java.security.ArbitraryApkInstallation as ArbitraryApkInstallation
  private import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery as CleartextStorageAndroidDatabaseQuery
  private import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery as CleartextStorageAndroidFilesystemQuery
  private import semmle.code.java.security.CleartextStorageCookieQuery as CleartextStorageCookieQuery
  private import semmle.code.java.security.CleartextStorageSharedPrefsQuery as CleartextStorageSharedPrefsQuery
  private import semmle.code.java.security.ExternallyControlledFormatStringQuery as ExternallyControlledFormatStringQuery
  private import semmle.code.java.security.InsecureBasicAuth as InsecureBasicAuth
  private import semmle.code.java.security.IntentUriPermissionManipulation as IntentUriPermissionManipulation
  private import semmle.code.java.security.InsecureLdapAuth as InsecureLdapAuth
  private import semmle.code.java.security.InsecureTrustManager as InsecureTrustManager
  private import semmle.code.java.security.JndiInjection as JndiInjection
  private import semmle.code.java.security.JWT as Jwt
  private import semmle.code.java.security.OgnlInjection as OgnlInjection
  private import semmle.code.java.security.SensitiveResultReceiverQuery as SensitiveResultReceiverQuery
  private import semmle.code.java.security.SensitiveUiQuery as SensitiveUiQuery
  private import semmle.code.java.security.SpelInjection as SpelInjection
  private import semmle.code.java.security.SpelInjectionQuery as SpelInjectionQuery
  private import semmle.code.java.security.QueryInjection as QueryInjection
  private import semmle.code.java.security.TempDirLocalInformationDisclosureQuery as TempDirLocalInformationDisclosureQuery
  private import semmle.code.java.security.UnsafeAndroidAccess as UnsafeAndroidAccess
  private import semmle.code.java.security.UnsafeContentUriResolution as UnsafeContentUriResolution
  private import semmle.code.java.security.UnsafeDeserializationQuery as UnsafeDeserializationQuery
  private import semmle.code.java.security.UrlRedirect as UrlRedirect
  private import semmle.code.java.security.WebviewDebuggingEnabledQuery as WebviewDebuggingEnabledQuery
  private import semmle.code.java.security.XPath as Xpath
  private import semmle.code.java.security.XSS as Xss

  private class AndoidIntentRedirectionQuerySinks extends SinkNode instanceof AndroidSensitiveCommunicationQuery::SensitiveCommunicationSink
  { }

  private class ArbitraryApkInstallationSinks extends SinkNode instanceof ArbitraryApkInstallation::SetDataSink
  { }

  private class CleartextStorageAndroidDatabaseQuerySinks extends SinkNode instanceof CleartextStorageAndroidDatabaseQuery::LocalDatabaseSink
  { }

  private class CleartextStorageAndroidFilesystemQuerySinks extends SinkNode instanceof CleartextStorageAndroidFilesystemQuery::LocalFileSink
  { }

  private class CleartextStorageCookieQuerySinks extends SinkNode instanceof CleartextStorageCookieQuery::CookieStoreSink
  { }

  private class CleartextStorageSharedPrefsQuerySinks extends SinkNode instanceof CleartextStorageSharedPrefsQuery::SharedPreferencesSink
  { }

  private class ExternallyControlledFormatStringQuerySinks extends SinkNode instanceof ExternallyControlledFormatStringQuery::StringFormatSink
  { }

  private class InsecureBasicAuthSinks extends SinkNode instanceof InsecureBasicAuth::InsecureBasicAuthSink
  { }

  private class InsecureTrustManagerSinks extends SinkNode instanceof InsecureTrustManager::InsecureTrustManagerSink
  { }

  private class IntentUriPermissionManipulationSinks extends SinkNode instanceof IntentUriPermissionManipulation::IntentUriPermissionManipulationSink
  { }

  private class InsecureLdapAuthSinks extends SinkNode instanceof InsecureLdapAuth::InsecureLdapUrlSink
  { }

  private class JndiInjectionSinks extends SinkNode instanceof JndiInjection::JndiInjectionSink { }

  private class JwtSinks extends SinkNode instanceof Jwt::JwtParserWithInsecureParseSink { }

  private class OgnlInjectionSinks extends SinkNode instanceof OgnlInjection::OgnlInjectionSink { }

  private class SensitiveResultReceiverQuerySinks extends SinkNode instanceof SensitiveResultReceiverQuery::SensitiveResultReceiverSink
  { }

  private class SensitiveUiQuerySinks extends SinkNode instanceof SensitiveUiQuery::TextFieldSink {
  }

  private class SpelInjectionSinks extends SinkNode instanceof SpelInjection::SpelExpressionEvaluationSink
  { }

  private class QueryInjectionSinks extends SinkNode instanceof QueryInjection::QueryInjectionSink {
  }

  private class TempDirLocalInformationDisclosureSinks extends SinkNode instanceof TempDirLocalInformationDisclosureQuery::MethodFileDirectoryCreationSink
  { }

  private class UnsafeAndroidAccessSinks extends SinkNode instanceof UnsafeAndroidAccess::UrlResourceSink
  { }

  private class UnsafeContentUriResolutionSinks extends SinkNode instanceof UnsafeContentUriResolution::ContentUriResolutionSink
  { }

  private class UnsafeDeserializationQuerySinks extends SinkNode instanceof UnsafeDeserializationQuery::UnsafeDeserializationSink
  { }

  private class UrlRedirectSinks extends SinkNode instanceof UrlRedirect::UrlRedirectSink { }

  private class WebviewDebugEnabledQuery extends SinkNode instanceof WebviewDebuggingEnabledQuery::WebviewDebugSink
  { }

  private class XPathSinks extends SinkNode instanceof Xpath::XPathInjectionSink { }

  private class XssSinks extends SinkNode instanceof Xss::XssSink { }

  /**
   * Add all models as data sinks.
   */
  private class SinkNodeExternal extends SinkNode {
    SinkNodeExternal() { sinkNode(this, _) }
  }
}
