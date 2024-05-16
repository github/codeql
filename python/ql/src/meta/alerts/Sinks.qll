private import python
private import semmle.python.dataflow.new.DataFlow
private import meta.MetaMetrics
import semmle.python.security.dataflow.CleartextLoggingCustomizations
import semmle.python.security.dataflow.CleartextStorageCustomizations
import semmle.python.security.dataflow.CodeInjectionCustomizations
import semmle.python.security.dataflow.CommandInjectionCustomizations
import semmle.python.security.dataflow.LdapInjectionCustomizations
import semmle.python.security.dataflow.LogInjectionCustomizations
import semmle.python.security.dataflow.NoSqlInjectionCustomizations
import semmle.python.security.dataflow.PathInjectionCustomizations
import semmle.python.security.dataflow.PolynomialReDoSCustomizations
import semmle.python.security.dataflow.ReflectedXSSCustomizations
import semmle.python.security.dataflow.RegexInjectionCustomizations
import semmle.python.security.dataflow.ServerSideRequestForgeryCustomizations
import semmle.python.security.dataflow.SqlInjectionCustomizations
import semmle.python.security.dataflow.StackTraceExposureCustomizations
import semmle.python.security.dataflow.TarSlipCustomizations
import semmle.python.security.dataflow.UnsafeDeserializationCustomizations
import semmle.python.security.dataflow.UrlRedirectCustomizations
import semmle.python.security.dataflow.WeakSensitiveDataHashingCustomizations
import semmle.python.security.dataflow.XmlBombCustomizations
import semmle.python.security.dataflow.XpathInjectionCustomizations
import semmle.python.security.dataflow.XxeCustomizations

DataFlow::Node taintSink(string kind) {
  not result.getLocation().getFile() instanceof IgnoredFile and
  (
    kind = "CleartextLogging" and result instanceof CleartextLogging::Sink
    or
    kind = "CleartextStorage" and result instanceof CleartextStorage::Sink
    or
    kind = "CodeInjection" and result instanceof CodeInjection::Sink
    or
    kind = "CommandInjection" and result instanceof CommandInjection::Sink
    or
    kind = "LdapInjection (DN)" and result instanceof LdapInjection::DnSink
    or
    kind = "LdapInjection (Filter)" and result instanceof LdapInjection::FilterSink
    or
    kind = "LogInjection" and result instanceof LogInjection::Sink
    or
    kind = "PathInjection" and result instanceof PathInjection::Sink
    or
    kind = "PolynomialReDoS" and result instanceof PolynomialReDoS::Sink
    or
    kind = "ReflectedXss" and result instanceof ReflectedXss::Sink
    or
    kind = "RegexInjection" and result instanceof RegexInjection::Sink
    or
    kind = "NoSqlInjection (string sink)" and result instanceof NoSqlInjection::StringSink
    or
    kind = "NoSqlInjection (dict sink)" and result instanceof NoSqlInjection::DictSink
    or
    kind = "ServerSideRequestForgery" and result instanceof ServerSideRequestForgery::Sink
    or
    kind = "SqlInjection" and result instanceof SqlInjection::Sink
    or
    kind = "StackTraceExposure" and result instanceof StackTraceExposure::Sink
    or
    kind = "TarSlip" and result instanceof TarSlip::Sink
    or
    kind = "UnsafeDeserialization" and result instanceof UnsafeDeserialization::Sink
    or
    kind = "UrlRedirect" and result instanceof UrlRedirect::Sink
    or
    kind = "WeakSensitiveDataHashing (NormalHashFunction)" and
    result instanceof NormalHashFunction::Sink
    or
    kind = "WeakSensitiveDataHashing (ComputationallyExpensiveHashFunction)" and
    result instanceof ComputationallyExpensiveHashFunction::Sink
    or
    kind = "XmlBomb" and result instanceof XmlBomb::Sink
    or
    kind = "XpathInjection" and result instanceof XpathInjection::Sink
    or
    kind = "Xxe" and result instanceof Xxe::Sink
  )
}
