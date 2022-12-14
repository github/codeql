/** Provides classes and predicates related to handling APIs from external libraries. */

private import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.internal.DataFlowPrivate
private import semmle.code.java.dataflow.TaintTracking

/**
 * A test library.
 */
private class TestLibrary extends RefType {
  TestLibrary() {
    this.getPackage()
        .getName()
        .matches([
            "org.junit%", "junit.%", "org.mockito%", "org.assertj%",
            "com.github.tomakehurst.wiremock%", "org.hamcrest%", "org.springframework.test.%",
            "org.springframework.mock.%", "org.springframework.boot.test.%", "reactor.test%",
            "org.xmlunit%", "org.testcontainers.%", "org.opentest4j%", "org.mockserver%",
            "org.powermock%", "org.skyscreamer.jsonassert%", "org.rnorth.visibleassertions",
            "org.openqa.selenium%", "com.gargoylesoftware.htmlunit%",
            "org.jboss.arquillian.testng%", "org.testng%"
          ])
  }
}

private string containerAsJar(Container container) {
  if container instanceof JarFile then result = container.getBaseName() else result = "rt.jar"
}

/** Holds if the given callable is not worth supporting. */
private predicate isUninteresting(Callable c) {
  c.getDeclaringType() instanceof TestLibrary or
  c.(Constructor).isParameterless()
}

/**
 * An external API from either the Standard Library or a 3rd party library.
 */
class ExternalApi extends Callable {
  ExternalApi() { not this.fromSource() and not isUninteresting(this) }

  /**
   * Gets information about the external API in the form expected by the CSV modeling framework.
   */
  string getApiName() {
    result =
      this.getDeclaringType().getPackage() + "." + this.getDeclaringType().getSourceDeclaration() +
        "#" + this.getName() + paramsString(this)
  }

  /**
   * Gets the jar file containing this API. Normalizes the Java Runtime to "rt.jar" despite the presence of modules.
   */
  string jarContainer() { result = containerAsJar(this.getCompilationUnit().getParentContainer*()) }

  /** Gets a node that is an input to a call to this API. */
  private DataFlow::Node getAnInput() {
    exists(Call call | call.getCallee().getSourceDeclaration() = this |
      result.asExpr().(Argument).getCall() = call or
      result.(ArgumentNode).getCall().asCall() = call
    )
  }

  /** Gets a node that is an output from a call to this API. */
  private DataFlow::Node getAnOutput() {
    exists(Call call | call.getCallee().getSourceDeclaration() = this |
      result.asExpr() = call or
      result.(DataFlow::PostUpdateNode).getPreUpdateNode().(ArgumentNode).getCall().asCall() = call
    )
  }

  /** Holds if this API has a supported summary. */
  predicate hasSummary() {
    this = any(SummarizedCallable sc).asCallable() or
    TaintTracking::localAdditionalTaintStep(this.getAnInput(), _)
  }

  predicate isSource() {
    this.getAnOutput() instanceof RemoteFlowSource or sourceNode(this.getAnOutput(), _)
  }

  /** Holds if this API is a known sink. */
  predicate isSink() { sinkNode(this.getAnInput(), _) }

  /** Holds if this API is supported by existing CodeQL libraries, that is, it is either a recognized source or sink or has a flow summary. */
  predicate isSupported() { this.hasSummary() or this.isSource() or this.isSink() }
}

/** DEPRECATED: Alias for ExternalApi */
deprecated class ExternalAPI = ExternalApi;

/**
 * Gets the limit for the number of results produced by a telemetry query.
 */
int resultLimit() { result = 1000 }

/**
 * Holds if it is relevant to count usages of `api`.
 */
signature predicate relevantApi(ExternalApi api);

/**
 * Given a predicate to count relevant API usages, this module provides a predicate
 * for restricting the number or returned results based on a certain limit.
 */
module Results<relevantApi/1 getRelevantUsages> {
  private int getUsages(string apiName) {
    result =
      strictcount(Call c, ExternalApi api |
        c.getCallee().getSourceDeclaration() = api and
        not c.getFile() instanceof GeneratedFile and
        apiName = api.getApiName() and
        getRelevantUsages(api)
      )
  }

  private int getOrder(string apiInfo) {
    apiInfo =
      rank[result](string info, int usages |
        usages = getUsages(info)
      |
        info order by usages desc, info
      )
  }

  /**
   * Holds if there exists an API with `apiName` that is being used `usages` times
   * and if it is in the top results (guarded by resultLimit).
   */
  predicate restrict(string apiName, int usages) {
    usages = getUsages(apiName) and
    getOrder(apiName) <= resultLimit()
  }
}
