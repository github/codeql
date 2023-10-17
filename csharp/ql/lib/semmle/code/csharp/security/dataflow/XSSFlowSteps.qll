/** Definitions for additional flow steps for cross-site scripting (XSS) vulnerabilities. */

import csharp
private import codeql.util.Unit
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

/** Gets the `i`th template for view discovery. */
private string getViewSearchTemplate(int i) {
  i = 0 and result = "/Views/{1}/{0}.cshtml"
  or
  i = 1 and result = "/Views/Shared/{0}.cshtml"
  or
  i = 2 and result = getAViewSearchTemplateInCode()
}

/** Gets an additional template used for view discovery defined in code. */
private string getAViewSearchTemplateInCode() {
  exists(StringLiteral str, MethodCall addCall |
    addCall.getTarget().hasQualifiedName("System.Collections.Generic", "IList", "Add") and
    DataFlow::localExprFlow(str, addCall.getArgument(0)) and
    addCall.getQualifier() = getAViewLocationList() and
    result = str.getValue()
  )
}

/** Gets a list expression containing view search locations */
private Expr getAViewLocationList() {
  result
      .(PropertyRead)
      .getProperty()
      .hasQualifiedName("Microsoft.AspNetCore.Mvc.Razor", "RazorViewEngineOptions",
        [
          "ViewLocationFormats", "PageViewLocationFormats", "AreaViewLocationFormats",
          "AreaPageViewLocationFormats"
        ])
}

/** A filepath that should be searched for a View call. */
private class RelativeViewCallFilepath extends NormalizableFilepath {
  ViewCall vc_;
  int idx_;

  RelativeViewCallFilepath() {
    exists(string template | template = getViewSearchTemplate(idx_) |
      this =
        template.replaceAll("{0}", vc_.getActionName()).replaceAll("{1}", vc_.getControllerName())
      or
      not exists(vc_.getControllerName()) and
      not template.matches("%{1}%") and
      this = template.replaceAll("{0}", vc_.getActionName())
    )
  }

  /** Holds if this string is the `idx`th path that will be searched for the `vc` call. */
  predicate hasViewCallWithIndex(ViewCall vc, int idx) { vc = vc_ and idx = idx_ }
}

// TODO: this could be a shared library
/**
 * A filepath that should be normalized.
 * Extend to provide additional strings that should be normalized as filepaths.
 */
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
