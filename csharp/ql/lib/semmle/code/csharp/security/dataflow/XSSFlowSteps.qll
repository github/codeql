import csharp
private import codeql.util.Unit
private import semmle.code.csharp.frameworks.microsoft.AspNetCore

/** An additional flow step for cross-site scripting (XSS) vulnerabilities */
abstract class XssAdditionalFlowStep extends Unit {
  abstract predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2);
}

/** A call to the `View` method */
private class ViewCall extends MethodCall {
  ViewCall() { this.getTarget().hasQualifiedName("Microsoft.AspNetCore.Mvc", "Controller", "View") }

  /** Gets the `name` argument to this call, if any. */
  string getNameArgument() {
    exists(StringLiteral lit, int i | i in [0 .. 1] |
      this.getTarget().getParameter(i).getType() instanceof StringType and
      DataFlow::localExprFlow(lit, this.getArgument(i)) and
      result = lit.getValue()
    )
  }

  /** Gets the `model` argument to this call, if any. */
  Expr getModelArgument() {
    exists(int i | i in [0 .. 1] |
      this.getTarget().getParameter(i).getType() instanceof ObjectType and
      result = this.getArgument(i)
    )
  }

  /** Gets the MVC action method that this call is made from, if any. */
  Method getActionMethod() {
    result = this.getEnclosingCallable() and
    result = this.getController().getAnActionMethod()
  }

  /** Gets the MVC controller that this call is made from, if any. */
  MicrosoftAspNetCoreMvcController getController() {
    result = this.getEnclosingCallable().getDeclaringType()
  }

  /** Gets the name of the MVC controller that this call is made from, if any. */
  string getControllerName() { result + "Controller" = this.getController().getName() }
}

/** A compiler-generated Razor page. */
private class RazorPage extends Class {
  AssemblyAttribute attr;

  RazorPage() {
    attr.getFile() = this.getFile() and
    attr.getType()
        .hasQualifiedName("Microsoft.AspNetCore.Razor.Hosting", "RazorCompiledItemAttribute")
  }

  /**
   * Gets the filepath of the source file that this class was generated from,
   * relative to the application root.
   */
  string getSourceFilepath() { result = attr.getArgument(2).(StringLiteral).getValue() }
}

private class ViewCallFlowStep extends XssAdditionalFlowStep {
  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ViewCall vc, RazorPage rp, PropertyAccess modelProp |
      viewCallRefersToPage(vc, rp) and
      node1.asExpr() = vc.getModelArgument() and
      node2.asExpr() = modelProp and
      modelProp.getTarget().hasName("Model") and
      modelProp.getEnclosingCallable().getDeclaringType() = rp
    )
  }
}

private predicate viewCallRefersToPage(ViewCall vc, RazorPage rp) {
  viewCallRefersToPageAbsolute(vc, rp)
}

private predicate viewCallRefersToPageAbsolute(ViewCall vc, RazorPage rp) {
  ["/", "~/", ""] + vc.getNameArgument() = rp.getSourceFilepath()
}
