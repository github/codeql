import java
import semmle.code.java.security.QueryInjection
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow

class PublicCallable extends Callable {
  PublicCallable() { this.isPublic() and this.getDeclaringType().isPublic() }
}

class PublicArgumentToSqlInjectionSinkConfiguration extends DataFlow::Configuration {
  PublicArgumentToSqlInjectionSinkConfiguration() {
    this = "PublicArgumentToSqlInjectionSinkConfiguration"
  }

  override predicate isSource(DataFlow::Node node) {
    node.asParameter() = any(PublicCallable c).getAParameter() and
    node.getType() instanceof TypeString
  }

  override predicate isSink(DataFlow::Node node) { node instanceof SqlInjectionSink }
}

class PublicArgumentToSqlInjectionSinkTaintConfiguration extends TaintTracking::Configuration {
  PublicArgumentToSqlInjectionSinkTaintConfiguration() {
    this = "PublicArgumentToSqlInjectionSinkTaintConfiguration"
  }

  override predicate isSource(DataFlow::Node node) {
    node.asParameter() = any(PublicCallable c).getAParameter() and
    node.getType() instanceof TypeString
  }

  override predicate isSink(DataFlow::Node node) { node instanceof SqlInjectionSink }
}

Callable getASqlInjectionVulnerableParameterValueFlow(int paramIdx) {
  exists(PublicArgumentToSqlInjectionSinkConfiguration config, DataFlow::ParameterNode source |
    config.hasFlow(source, _) and
    source.isParameterOf(result, paramIdx)
  )
}

Callable getASqlInjectionVulnerableParameterTaintFlow(int paramIdx) {
  exists(PublicArgumentToSqlInjectionSinkTaintConfiguration config, DataFlow::ParameterNode source |
    config.hasFlow(source, _) and
    source.isParameterOf(result, paramIdx)
  )
}

PublicCallable getASqlInjectionVulnerableParameterNameBasedGuess(int paramIdx) {
  exists(Parameter p |
    p.getName() = "sql" and
    p = result.getParameter(paramIdx)
  )
}

query PublicCallable getASqlInjectionVulnerableParameter(int paramIdx, string reason) {
  result = getASqlInjectionVulnerableParameterValueFlow(paramIdx) and
  reason = "valueFlowToKnownSink"
  or
  result = getASqlInjectionVulnerableParameterTaintFlow(paramIdx) and
  not result = getASqlInjectionVulnerableParameterValueFlow(paramIdx) and
  reason = "taintFlowToKnownSink"
  or
  result = getASqlInjectionVulnerableParameterNameBasedGuess(paramIdx) and
  not result = getASqlInjectionVulnerableParameterValueFlow(paramIdx) and
  not result = getASqlInjectionVulnerableParameterTaintFlow(paramIdx) and
  reason = "nameBasedGuess"
}

predicate hasOverloads(PublicCallable c) {
  exists(PublicCallable other |
    other.getDeclaringType() = c.getDeclaringType() and
    other.getName() = c.getName() and
    other != c
  )
}

string signatureIfNeeded(PublicCallable c) {
  if hasOverloads(c) then result = paramsString(c) else result = ""
}

query string getASqlInjectionVulnerableParameterSpecification() {
  exists(PublicCallable c, int paramIdx |
    c = getASqlInjectionVulnerableParameter(paramIdx, _) and
    result =
      c.getDeclaringType().getPackage() + ";" + c.getDeclaringType().getName() + ";" + "false;" +
        c.getName() + ";" + signatureIfNeeded(c) + ";;" + "Argument[" + paramIdx + "];" + "sql"
  )
}
