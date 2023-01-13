/*
 * For internal use only.
 *
 * Counts sources and sinks for Java security queries.
 */

import java
import semmle.code.java.dataflow.DataFlow::DataFlow as DataFlow
import semmle.code.java.dataflow.TaintTracking::TaintTracking as TaintTracking
// java/ql/lib/semmle/code/java/security$ ls *Query.qll | sed -e 's/\(.*\)Query.qll/import semmle.code.java.security.\1Query as \1/'
import semmle.code.java.security.AndroidIntentRedirectionQuery as AndroidIntentRedirection
import semmle.code.java.security.AndroidSensitiveCommunicationQuery as AndroidSensitiveCommunication
import semmle.code.java.security.AndroidWebViewCertificateValidationQuery as AndroidWebViewCertificateValidation
import semmle.code.java.security.CleartextStorageAndroidDatabaseQuery as CleartextStorageAndroidDatabase
import semmle.code.java.security.CleartextStorageAndroidFilesystemQuery as CleartextStorageAndroidFilesystem
import semmle.code.java.security.CleartextStorageClassQuery as CleartextStorageClass
import semmle.code.java.security.CleartextStorageCookieQuery as CleartextStorageCookie
import semmle.code.java.security.CleartextStoragePropertiesQuery as CleartextStorageProperties
import semmle.code.java.security.CleartextStorageQuery as CleartextStorage
import semmle.code.java.security.CleartextStorageSharedPrefsQuery as CleartextStorageSharedPrefs
import semmle.code.java.security.CommandLineQuery as CommandLine
import semmle.code.java.security.ConditionalBypassQuery as ConditionalBypass
import semmle.code.java.security.FragmentInjectionQuery as FragmentInjection
import semmle.code.java.security.GroovyInjectionQuery as GroovyInjection
import semmle.code.java.security.HardcodedCredentialsApiCallQuery as HardcodedCredentialsApiCall
import semmle.code.java.security.HardcodedCredentialsSourceCallQuery as HardcodedCredentialsSourceCall
import semmle.code.java.security.HttpsUrlsQuery as HttpsUrls
import semmle.code.java.security.ImplicitPendingIntentsQuery as ImplicitPendingIntents
import semmle.code.java.security.ImproperIntentVerificationQuery as ImproperIntentVerification
import semmle.code.java.security.InsecureBasicAuthQuery as InsecureBasicAuth
import semmle.code.java.security.InsecureTrustManagerQuery as InsecureTrustManager
import semmle.code.java.security.InsufficientKeySizeQuery as InsufficientKeySize
import semmle.code.java.security.IntentUriPermissionManipulationQuery as IntentUriPermissionManipulation
import semmle.code.java.security.JexlInjectionQuery as JexlInjection
import semmle.code.java.security.JndiInjectionQuery as JndiInjection
import semmle.code.java.security.LogInjectionQuery as LogInjection
import semmle.code.java.security.MissingJWTSignatureCheckQuery as MissingJWTSignatureCheck
import semmle.code.java.security.MvelInjectionQuery as MvelInjection
import semmle.code.java.security.OgnlInjectionQuery as OgnlInjection
import semmle.code.java.security.OverlyLargeRangeQuery as OverlyLargeRange
import semmle.code.java.security.PartialPathTraversalQuery as PartialPathTraversal
import semmle.code.java.security.RandomQuery as Random
import semmle.code.java.security.RsaWithoutOaepQuery as RsaWithoutOaep
import semmle.code.java.security.SensitiveKeyboardCacheQuery as SensitiveKeyboardCache
import semmle.code.java.security.SensitiveLoggingQuery as SensitiveLogging
import semmle.code.java.security.SpelInjectionQuery as SpelInjection
import semmle.code.java.security.SqlInjectionQuery as SqlInjection
import semmle.code.java.security.StaticInitializationVectorQuery as StaticInitializationVector
import semmle.code.java.security.TemplateInjectionQuery as TemplateInjection
import semmle.code.java.security.UnsafeAndroidAccessQuery as UnsafeAndroidAccess
import semmle.code.java.security.UnsafeCertTrustQuery as UnsafeCertTrust
import semmle.code.java.security.UnsafeContentUriResolutionQuery as UnsafeContentUriResolution
import semmle.code.java.security.UnsafeDeserializationQuery as UnsafeDeserialization
import semmle.code.java.security.WebviewDubuggingEnabledQuery as WebviewDubuggingEnabled
import semmle.code.java.security.XsltInjectionQuery as XsltInjection

DataFlow::Node getASink(TaintTracking::Configuration cfg) {
  cfg.isSink(result) or cfg.isSink(result, _)
}

DataFlow::Node getASource(TaintTracking::Configuration cfg) {
  cfg.isSource(result) or cfg.isSource(result, _)
}

from TaintTracking::Configuration cfg, int sources, int sinks
where count(getASource(cfg)) = sources and count(getASink(cfg)) = sinks
select cfg, sources, sinks
