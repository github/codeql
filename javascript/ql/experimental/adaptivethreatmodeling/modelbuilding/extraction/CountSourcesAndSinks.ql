/*
 * For internal use only.
 *
 * Counts sources and sinks for JavaScript security queries.
 */

import javascript
import semmle.javascript.dataflow.Configuration
// javascript/ql/lib/semmle/javascript/security/dataflow$ ls *Query.qll | sed -e 's/\(.*\)Query.qll/import semmle.javascript.security.dataflow.\1Query as \1/'
import semmle.javascript.security.dataflow.BrokenCryptoAlgorithmQuery as BrokenCryptoAlgorithm
import semmle.javascript.security.dataflow.BuildArtifactLeakQuery as BuildArtifactLeak
import semmle.javascript.security.dataflow.CleartextLoggingQuery as CleartextLogging
import semmle.javascript.security.dataflow.CleartextStorageQuery as CleartextStorage
import semmle.javascript.security.dataflow.ClientSideUrlRedirectQuery as ClientSideUrlRedirect
import semmle.javascript.security.dataflow.CodeInjectionQuery as CodeInjection
import semmle.javascript.security.dataflow.CommandInjectionQuery as CommandInjection
import semmle.javascript.security.dataflow.ConditionalBypassQuery as ConditionalBypass
import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentialsQuery as CorsMisconfigurationForCredentials
import semmle.javascript.security.dataflow.DeepObjectResourceExhaustionQuery as DeepObjectResourceExhaustion
import semmle.javascript.security.dataflow.DifferentKindsComparisonBypassQuery as DifferentKindsComparisonBypass
import semmle.javascript.security.dataflow.DomBasedXssQuery as DomBasedXss
import semmle.javascript.security.dataflow.ExceptionXssQuery as ExceptionXss
import semmle.javascript.security.dataflow.ExternalAPIUsedWithUntrustedDataQuery as ExternalApiUsedWithUntrustedData
import semmle.javascript.security.dataflow.FileAccessToHttpQuery as FileAccessToHttp
import semmle.javascript.security.dataflow.HardcodedCredentialsQuery as HardcodedCredentials
import semmle.javascript.security.dataflow.HardcodedDataInterpretedAsCodeQuery as HardcodedDataInterpretedAsCode
import semmle.javascript.security.dataflow.HostHeaderPoisoningInEmailGenerationQuery as HostHeaderPoisoningInEmailGeneration
import semmle.javascript.security.dataflow.HttpToFileAccessQuery as HttpToFileAccess
import semmle.javascript.security.dataflow.ImproperCodeSanitizationQuery as ImproperCodeSanitization
import semmle.javascript.security.dataflow.IncompleteHtmlAttributeSanitizationQuery as IncompleteHtmlAttributeSanitization
import semmle.javascript.security.dataflow.IndirectCommandInjectionQuery as IndirectCommandInjection
import semmle.javascript.security.dataflow.InsecureDownloadQuery as InsecureDownload
import semmle.javascript.security.dataflow.InsecureRandomnessQuery as InsecureRandomness
import semmle.javascript.security.dataflow.InsufficientPasswordHashQuery as InsufficientPasswordHash
import semmle.javascript.security.dataflow.LogInjectionQuery as LogInjection
import semmle.javascript.security.dataflow.LoopBoundInjectionQuery as LoopBoundInjection
import semmle.javascript.security.dataflow.NosqlInjectionQuery as NosqlInjection
import semmle.javascript.security.dataflow.PostMessageStarQuery as PostMessageStar
import semmle.javascript.security.dataflow.PrototypePollutingAssignmentQuery as PrototypePollutingAssignment
import semmle.javascript.security.dataflow.PrototypePollutionQuery as PrototypePollution
import semmle.javascript.security.dataflow.ReflectedXssQuery as ReflectedXss
import semmle.javascript.security.dataflow.RegExpInjectionQuery as RegExpInjection
import semmle.javascript.security.dataflow.RemotePropertyInjectionQuery as RemotePropertyInjection
import semmle.javascript.security.dataflow.RequestForgeryQuery as RequestForgery
import semmle.javascript.security.dataflow.ServerSideUrlRedirectQuery as ServerSideUrlRedirect
import semmle.javascript.security.dataflow.ShellCommandInjectionFromEnvironmentQuery as ShellCommandInjectionFromEnvironment
import semmle.javascript.security.dataflow.SqlInjectionQuery as SqlInjection
import semmle.javascript.security.dataflow.StackTraceExposureQuery as StackTraceExposure
import semmle.javascript.security.dataflow.StoredXssQuery as StoredXss
import semmle.javascript.security.dataflow.TaintedFormatStringQuery as TaintedFormatString
import semmle.javascript.security.dataflow.TaintedPathQuery as TaintedPath
import semmle.javascript.security.dataflow.TemplateObjectInjectionQuery as TemplateObjectInjection
import semmle.javascript.security.dataflow.TypeConfusionThroughParameterTamperingQuery as TypeConfusionThroughParameterTampering
import semmle.javascript.security.dataflow.UnsafeDeserializationQuery as UnsafeDeserialization
import semmle.javascript.security.dataflow.UnsafeDynamicMethodAccessQuery as UnsafeDynamicMethodAccess
import semmle.javascript.security.dataflow.UnsafeHtmlConstructionQuery as UnsafeHtmlConstruction
import semmle.javascript.security.dataflow.UnsafeJQueryPluginQuery as UnsafeJQueryPlugin
import semmle.javascript.security.dataflow.UnsafeShellCommandConstructionQuery as UnsafeShellCommandConstruction
import semmle.javascript.security.dataflow.UnvalidatedDynamicMethodCallQuery as UnvalidatedDynamicMethodCall
import semmle.javascript.security.dataflow.XmlBombQuery as XmlBomb
import semmle.javascript.security.dataflow.XpathInjectionQuery as XpathInjection
import semmle.javascript.security.dataflow.XssThroughDomQuery as XssThroughDom
import semmle.javascript.security.dataflow.XxeQuery as Xxe
import semmle.javascript.security.dataflow.ZipSlipQuery as ZipSlip

DataFlow::Node getASink(Configuration cfg) { cfg.isSink(result) or cfg.isSink(result, _) }

DataFlow::Node getASource(Configuration cfg) { cfg.isSource(result) or cfg.isSource(result, _) }

from Configuration cfg, int sources, int sinks
where count(getASource(cfg)) = sources and count(getASink(cfg)) = sinks
select cfg, sources, sinks
