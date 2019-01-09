/**
 * Imports the standard library and all taint-tracking configuration classes from the security queries.
 */

import javascript
import semmle.javascript.security.dataflow.BrokenCryptoAlgorithm
import semmle.javascript.security.dataflow.CleartextLogging
import semmle.javascript.security.dataflow.CleartextStorage
import semmle.javascript.security.dataflow.ClientSideUrlRedirect
import semmle.javascript.security.dataflow.CodeInjection
import semmle.javascript.security.dataflow.CommandInjection
import semmle.javascript.security.dataflow.ConditionalBypass
import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentials
import semmle.javascript.security.dataflow.DifferentKindsComparisonBypass
import semmle.javascript.security.dataflow.DomBasedXss as DomBasedXss
import semmle.javascript.security.dataflow.FileAccessToHttp
import semmle.javascript.security.dataflow.HardcodedCredentials
import semmle.javascript.security.dataflow.InsecureRandomness
import semmle.javascript.security.dataflow.InsufficientPasswordHash
import semmle.javascript.security.dataflow.NosqlInjection
import semmle.javascript.security.dataflow.ReflectedXss as ReflectedXss
import semmle.javascript.security.dataflow.RegExpInjection
import semmle.javascript.security.dataflow.RemotePropertyInjection
import semmle.javascript.security.dataflow.RequestForgery
import semmle.javascript.security.dataflow.ServerSideUrlRedirect
import semmle.javascript.security.dataflow.SqlInjection
import semmle.javascript.security.dataflow.StackTraceExposure
import semmle.javascript.security.dataflow.StoredXss as StoredXss
import semmle.javascript.security.dataflow.TaintedFormatString
import semmle.javascript.security.dataflow.TaintedPath
import semmle.javascript.security.dataflow.TypeConfusionThroughParameterTampering
import semmle.javascript.security.dataflow.UnsafeDeserialization
import semmle.javascript.security.dataflow.XmlBomb
import semmle.javascript.security.dataflow.XpathInjection
import semmle.javascript.security.dataflow.Xxe
