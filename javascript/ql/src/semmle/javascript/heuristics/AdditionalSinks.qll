/**
 * Provides classes that heuristically increase the extent of the sinks in security queries.
 *
 * Note: This module should not be a permanent part of the standard library imports.
 */

import javascript
private import SyntacticHeuristics
private import semmle.javascript.security.dataflow.CodeInjectionCustomizations
private import semmle.javascript.security.dataflow.CommandInjectionCustomizations
private import semmle.javascript.security.dataflow.DomBasedXss as DomBasedXss
private import semmle.javascript.security.dataflow.ReflectedXss as ReflectedXss
private import semmle.javascript.security.dataflow.SqlInjectionCustomizations
private import semmle.javascript.security.dataflow.NosqlInjectionCustomizations
private import semmle.javascript.security.dataflow.TaintedPathCustomizations
private import semmle.javascript.security.dataflow.RegExpInjectionCustomizations
private import semmle.javascript.security.dataflow.ClientSideUrlRedirectCustomizations
private import semmle.javascript.security.dataflow.ServerSideUrlRedirectCustomizations
private import semmle.javascript.security.dataflow.InsecureRandomnessCustomizations

/**
 * A heuristic sink for data flow in a security query.
 */
abstract class HeuristicSink extends DataFlow::Node { }

private class HeuristicCodeInjectionSink extends HeuristicSink, CodeInjection::Sink {
  HeuristicCodeInjectionSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(command|cmd|exec|code|script|program)")
    or
    isArgTo(this, "(?i)(eval|run)") // "exec" clashes too often with `RegExp.prototype.exec`
    or
    exists(string srcPattern |
      // function/lambda syntax anywhere
      srcPattern = "(?s).*function\\s*\\(.*\\).*" or
      srcPattern = "(?s).*(\\(.*\\)|[A-Za-z_]+)\\s?=>.*"
    |
      isConcatenatedWithString(this, srcPattern)
    )
    or
    // dynamic property name
    isConcatenatedWithStrings("(?is)[a-z]+\\[", this, "(?s)\\].*")
  }
}

private class HeuristicCommandInjectionSink extends HeuristicSink, CommandInjection::Sink {
  HeuristicCommandInjectionSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(command|cmd|exec|code|script|program)") or
    isArgTo(this, "(?i)(a?sync)?(eval|run)(a?sync)?") // "exec" clashes too often with `RegExp.prototype.exec`
  }
}

private class HeuristicDomBasedXssSink extends HeuristicSink, DomBasedXss::DomBasedXss::Sink {
  HeuristicDomBasedXssSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(html|innerhtml)") or
    isArgTo(this, "(?i)(html|render)") or
    this instanceof StringOps::HtmlConcatenationLeaf or
    isConcatenatedWithStrings("(?is).*<[a-z ]+.*", this, "(?s).*>.*")
  }
}

private class HeuristicReflectedXssSink extends HeuristicSink, ReflectedXss::ReflectedXss::Sink {
  HeuristicReflectedXssSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(html|innerhtml)") or
    isArgTo(this, "(?i)(html|render)") or
    this instanceof StringOps::HtmlConcatenationLeaf or
    isConcatenatedWithStrings("(?is).*<[a-z ]+.*", this, "(?s).*>.*")
  }
}

private class HeuristicSqlInjectionSink extends HeuristicSink, SqlInjection::Sink {
  HeuristicSqlInjectionSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(sql|query)") or
    isArgTo(this, "(?i)(query)") or
    isConcatenatedWithString(this,
      "(?s).*(ALTER|COUNT|CREATE|DATABASE|DELETE|DISTINCT|DROP|FROM|GROUP|INSERT|INTO|LIMIT|ORDER|SELECT|TABLE|UPDATE|WHERE).*")
  }
}

private class HeuristicNosqlInjectionSink extends HeuristicSink, NosqlInjection::Sink {
  HeuristicNosqlInjectionSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(nosql|query)") or
    isArgTo(this, "(?i)(query)")
  }
}

private class HeuristicTaintedPathSink extends HeuristicSink, TaintedPath::Sink {
  HeuristicTaintedPathSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(file|folder|dir|absolute)") // "path" is too noisy in practice
    or
    isArgTo(this, "(?i)(get|read)file")
    or
    exists(string pathPattern |
      // paths with at least two parts, and either a trailing or leading slash
      pathPattern = "(?i)([a-z0-9_.-]+/){2,}" or
      pathPattern = "(?i)(/[a-z0-9_.-]+){2,}"
    |
      isConcatenatedWithString(this, pathPattern)
    )
    or
    isConcatenatedWithStrings(".*/", this, "/.*")
  }
}

private class HeuristicRegexpInjectionSink extends HeuristicSink, RegExpInjection::Sink {
  HeuristicRegexpInjectionSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(regexp?)") or
    isArgTo(this, "(?i)(match)")
  }
}

private class HeuristicClientSideUrlRedirectSink extends HeuristicSink, ClientSideUrlRedirect::Sink {
  HeuristicClientSideUrlRedirectSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(redirect)") or
    isArgTo(this, "(?i)(redirect)")
  }
}

private class HeuristicServerSideUrlRedirectSink extends HeuristicSink, ServerSideUrlRedirect::Sink {
  HeuristicServerSideUrlRedirectSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(redirect)") or
    isArgTo(this, "(?i)(redirect)")
  }
}

private class HeuristicInsecureRandomTokenSink extends HeuristicSink, InsecureRandomness::Sink {
  HeuristicInsecureRandomTokenSink() {
    isAssignedToOrConcatenatedWith(this, "(?i)(token|csrf|unique)")
  }
}
