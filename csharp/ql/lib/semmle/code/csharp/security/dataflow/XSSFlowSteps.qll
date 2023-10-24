/** Definitions for additional flow steps for cross-site scripting (XSS) vulnerabilities. */

import csharp
private import codeql.util.Unit
private import codeql.util.FilePath
private import semmle.code.csharp.frameworks.microsoft.AspNetCore

/**
 * A unit class for providing additional flow steps for cross-site scripting (XSS) vulnerabilities.
 * Extend to provide additional flow steps.
 */
class XssAdditionalFlowStep extends Unit {
  /** Holds if there is an additional dataflow step from `node1` to `node2`. */
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

  /**
   * Gets the action name that this call refers to, if any.
   * This is either the name argument, or the name of the action method calling this if there is no name argument.
   */
  string getActionName() {
    result = this.getNameArgument()
    or
    not exists(this.getNameArgument()) and
    result = this.getActionMethod().getName()
  }

  /** Gets the MVC controller that this call is made from, if any. */
  MicrosoftAspNetCoreMvcController getController() {
    result = this.getEnclosingCallable().getDeclaringType()
  }

  /** Gets the name of the MVC controller that this call is made from, if any. */
  string getControllerName() { result + "Controller" = this.getController().getName() }

  /** Gets the name of the Area that the controller of this call belongs to, if any. */
  string getAreaName() {
    exists(Attribute attr |
      attr = this.getController().getAnAttribute() and
      attr.getType().hasQualifiedName("Microsoft.AspNetCore.Mvc", "AreaAttribute") and
      result = attr.getArgument(0).(StringLiteral).getValue()
    )
  }

  /** `result` is `true` if this call is from a controller that is an Area, and `false` otherwise. */
  boolean hasArea() { if exists(this.getAreaName()) then result = true else result = false }
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
  ["", "~"] + rp.getSourceFilepath() =
    min(int i, RelativeViewCallFilepath fp |
      fp.hasViewCallWithIndex(vc, i) and
      exists(RazorPage rp2 | ["", "~"] + rp2.getSourceFilepath() = fp.getNormalizedPath())
    |
      fp.getNormalizedPath() order by i
    )
}

/** Gets the `i`th template for view discovery. */
private string getViewSearchTemplate(int i, boolean isArea) {
  i = 0 and result = "/Areas/{2}/Views/{1}/{0}.cshtml" and isArea = true
  or
  i = 1 and result = "/Areas/{2}/Views/Shared/{0}.cshtml" and isArea = true
  or
  i = 2 and result = "/Views/{1}/{0}.cshtml" and isArea = false
  or
  i = 3 and result = "/Views/Shared/{0}.cshtml" and isArea = [true, false]
  or
  i = 4 and result = "/Pages/Shared/{0}.cshtml" and isArea = true
  or
  i = 5 and result = getAViewSearchTemplateInCode(isArea)
}

/** Gets an additional template used for view discovery defined in code. */
private string getAViewSearchTemplateInCode(boolean isArea) {
  exists(StringLiteral str, MethodCall addCall |
    addCall.getTarget().hasName("Add") and
    DataFlow::localExprFlow(str, addCall.getArgument(0)) and
    addCall.getQualifier() = getAViewLocationList(isArea) and
    result = str.getValue()
  )
}

/** Gets a list expression containing view search locations */
private Expr getAViewLocationList(boolean isArea) {
  exists(string name |
    result
        .(PropertyRead)
        .getProperty()
        .hasQualifiedName("Microsoft.AspNetCore.Mvc.Razor", "RazorViewEngineOptions", name)
  |
    name = "ViewLocationFormats" and isArea = false
    or
    name = "AreaViewLocationFormats" and isArea = true
    // PageViewLocationFormats and AreaPageViewLocationFormats are used for calls within a page rather than a controller
  )
}

/** A filepath that should be searched for a View call. */
private class RelativeViewCallFilepath extends NormalizableFilepath {
  ViewCall vc_;
  int idx_;

  RelativeViewCallFilepath() {
    exists(string template, string sub2, string sub1, string sub0 |
      template = getViewSearchTemplate(idx_, vc_.hasArea())
    |
      (
        if template.matches("%{2}%")
        then sub2 = template.replaceAll("{2}", vc_.getAreaName())
        else sub2 = template
      ) and
      (
        if template.matches("%{1}%")
        then sub1 = sub2.replaceAll("{1}", vc_.getControllerName())
        else sub1 = sub2
      ) and
      sub0 = sub1.replaceAll("{0}", vc_.getActionName()) and
      this = sub0
    )
  }

  /** Holds if this string is the `idx`th path that will be searched for the `vc` call. */
  predicate hasViewCallWithIndex(ViewCall vc, int idx) { vc = vc_ and idx = idx_ }
}
