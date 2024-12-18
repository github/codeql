/** Provides classes representing various flow sinks for data flow / taint tracking. */

private import semmle.code.java.dataflow.FlowSinks as FlowSinks

final class SinkNode = FlowSinks::ApiSinkNode;

/**
 * Module that adds all API like sinks to `SinkNode`, excluding sinks for cryptography based
 * queries, and queries where sinks are not succifiently defined (eg. using broad method name matching).
 */
private module AllApiSinks {
  private import semmle.code.java.security.AndroidSensitiveCommunicationQuery
  private import semmle.code.java.security.ArbitraryApkInstallation
  private import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery
  private import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery
  private import semmle.code.java.security.CleartextStorageCookieQuery
  private import semmle.code.java.security.CleartextStorageSharedPrefsQuery
  private import semmle.code.java.security.ExternallyControlledFormatStringQuery
  private import semmle.code.java.security.InsecureBasicAuth
  private import semmle.code.java.security.IntentUriPermissionManipulation
  private import semmle.code.java.security.InsecureLdapAuth
  private import semmle.code.java.security.InsecureTrustManager
  private import semmle.code.java.security.JndiInjection
  private import semmle.code.java.security.JWT
  private import semmle.code.java.security.OgnlInjection
  private import semmle.code.java.security.SensitiveResultReceiverQuery
  private import semmle.code.java.security.SensitiveUiQuery
  private import semmle.code.java.security.SpelInjection
  private import semmle.code.java.security.SpelInjectionQuery
  private import semmle.code.java.security.QueryInjection
  private import semmle.code.java.security.TempDirLocalInformationDisclosureQuery
  private import semmle.code.java.security.UnsafeAndroidAccess
  private import semmle.code.java.security.UnsafeContentUriResolution
  private import semmle.code.java.security.UnsafeDeserializationQuery
  private import semmle.code.java.security.UrlRedirect
  private import semmle.code.java.security.WebviewDebuggingEnabledQuery
  private import semmle.code.java.security.XPath
  private import semmle.code.java.security.XSS
}
