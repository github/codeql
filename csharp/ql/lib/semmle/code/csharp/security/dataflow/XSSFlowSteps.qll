import csharp
private import codeql.util.Unit
private import semmle.code.csharp.frameworks.microsoft.AspNetCore

/** An additional flow step for cross-site scripting (XSS) vulnerabilities */
class XssAdditionalFlowStep extends Unit {
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
  viewCallRefersToPageAbsolute(vc, rp) or
  viewCallRefersToPageRelative(vc, rp)
}

private predicate viewCallRefersToPageAbsolute(ViewCall vc, RazorPage rp) {
  ["/", ""] + vc.getNameArgument() = ["", "~"] + rp.getSourceFilepath()
}

private predicate viewCallRefersToPageRelative(ViewCall vc, RazorPage rp) {
  rp.getSourceFilepath() =
    min(int i, RelativeViewCallFilepath fp |
      fp.hasViewCallWithIndex(vc, i) and
      exists(RazorPage rp2 | rp2.getSourceFilepath() = fp.getNormalizedPath())
    |
      fp.getNormalizedPath() order by i
    )
}

private class RelativeViewCallFilepath extends NormalizableFilepath {
  ViewCall vc;
  int idx;

  RelativeViewCallFilepath() {
    exists(string actionName |
      actionName = vc.getNameArgument() and
      not actionName.matches("%.cshtml")
      or
      not exists(vc.getNameArgument()) and
      actionName = vc.getActionMethod().getName()
    |
      idx = 0 and
      this = "/Views/" + vc.getControllerName() + "/" + actionName + ".cshtml"
      or
      idx = 1 and
      this = "/Views/Shared/" + actionName + ".cshtml"
    )
  }

  predicate hasViewCallWithIndex(ViewCall vc2, int idx2) { vc = vc2 and idx = idx2 }
}

// TODO: this could be a shared library
/** A filepath that should be normalized. */
abstract private class NormalizableFilepath extends string {
  bindingset[this]
  NormalizableFilepath() { any() }

  /** Gets the normalized filepath for this string; traversing `/../` paths. */
  string getNormalizedPath() {
    exists(string norm |
      norm = this.getNormalizedUpTo(0).regexpReplaceAll("/+$", "") and
      (if this.matches("/%") then result = "/" + norm else result = norm)
    )
  }

  private string getComponent(int i) { result = this.splitAt("/", i) }

  private int getNumComponents() { result = strictcount(int i | exists(this.getComponent(i))) }

  private string getNormalizedUpTo(int i) {
    i in [0 .. this.getNumComponents()] and
    (
      i = this.getNumComponents() and
      result = ""
      or
      i < this.getNumComponents() and
      exists(string comp, string sofar |
        comp = this.getComponent(i) and sofar = this.getNormalizedUpTo(i + 1)
      |
        if comp = [".", ""]
        then result = sofar
        else
          if comp = ".." or not sofar.matches("../%")
          then result = comp + "/" + sofar
          else exists(string base | sofar = "../" + base | result = base)
      )
    )
  }
}
