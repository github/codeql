/** Provides definitions and flow steps related to Razor pages. */

private import csharp
private import codeql.util.Unit
private import codeql.util.FilePath
private import semmle.code.csharp.frameworks.microsoft.AspNetCore
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate

/** A call to the `View` method */
private class ViewCall extends MethodCall {
  ViewCall() {
    this.getTarget().hasFullyQualifiedName("Microsoft.AspNetCore.Mvc", "Controller", "View")
  }

  /** Gets the `name` argument to this call, if any. */
  string getNameArgument() {
    exists(StringLiteral lit |
      this.getTarget().getParameter(0).getType() instanceof StringType and
      DataFlow::localExprFlow(lit, this.getArgument(0)) and
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
      attr.getType().hasFullyQualifiedName("Microsoft.AspNetCore.Mvc", "AreaAttribute") and
      result = attr.getArgument(0).(StringLiteral).getValue()
    )
  }

  /** `result` is `true` if this call is from a controller that is an Area, and `false` otherwise. */
  boolean hasArea() { if exists(this.getAreaName()) then result = true else result = false }
}

/** A compiler-generated Razor page from a `.cshtml` file. */
class RazorViewClass extends Class {
  AssemblyAttribute attr;

  RazorViewClass() {
    exists(Class baseClass | baseClass = this.getBaseClass().getUnboundDeclaration() |
      baseClass.hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.Razor", "RazorPage`1")
      or
      baseClass.hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.RazorPages", "Page")
    ) and
    attr.getFile() = this.getFile() and
    attr.getType()
        .hasFullyQualifiedName("Microsoft.AspNetCore.Razor.Hosting", "RazorCompiledItemAttribute")
  }

  /**
   * Gets the filepath of the source file that this class was generated from.
   *
   * This is an absolute path if the database was extracted in standalone mode,
   * and is relative to to application root (the directory containing the .csproj file) otherwise.
   */
  string getSourceFilepath() { result = attr.getArgument(2).(StringLiteral).getValue() }
}

/**
 * Gets a possible prefix to be applied to view search paths to locate a Razor page.
 * This may be empty (for the case that the generated Razor page files contain paths relative to the application root),
 * or the absolute path of the directory containing the .csproj file (for the case that standalone extraction is used and the generated files contain absolute paths).
 */
private string getARazorPathPrefix() {
  result = ""
  or
  exists(File csproj |
    csproj.getExtension() = "csproj" and
    // possibly prepend '/' to match Windows absolute paths starting with `C:/` with paths appearing in the Razor file in standalone mode starting with `/C:/`
    result = ["/", ""] + csproj.getParentContainer().getAbsolutePath()
  )
}

private class ViewCallJumpNode extends DataFlow::NonLocalJumpNode {
  RazorViewClass rp;

  ViewCallJumpNode() {
    exists(ViewCall vc |
      viewCallRefersToPage(vc, rp) and
      this.asExpr() = vc.getModelArgument()
    )
  }

  override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
    preservesValue = true and
    exists(PropertyAccess modelProp |
      result.asExpr() = modelProp and
      modelProp.getTarget().hasName("Model") and
      modelProp.getEnclosingCallable().getDeclaringType() = rp
    )
  }
}

private predicate viewCallRefersToPage(ViewCall vc, RazorViewClass rp) {
  viewCallRefersToPageAbsolute(vc, rp) or
  viewCallRefersToPageRelative(vc, rp)
}

bindingset[path]
private string stripTilde(string path) { result = path.regexpReplaceAll("^~/", "/") }

private predicate viewCallRefersToPageAbsolute(ViewCall vc, RazorViewClass rp) {
  getARazorPathPrefix() + ["/", ""] + stripTilde(vc.getNameArgument()) = rp.getSourceFilepath()
}

private predicate viewCallRefersToPageRelative(ViewCall vc, RazorViewClass rp) {
  rp = min(int i, RazorViewClass rp2 | matchesViewCallWithIndex(vc, rp2, i) | rp2 order by i)
}

private predicate matchesViewCallWithIndex(ViewCall vc, RazorViewClass rp, int i) {
  exists(RelativeViewCallFilepath fp |
    fp.hasViewCallWithIndex(vc, i) and
    getARazorPathPrefix() + fp.getNormalizedPath() = rp.getSourceFilepath()
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
        .hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.Razor", "RazorViewEngineOptions", name)
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
      this = stripTilde(sub0)
    )
  }

  /** Holds if this string is the `idx`th path that will be searched for the `vc` call. */
  predicate hasViewCallWithIndex(ViewCall vc, int idx) { vc = vc_ and idx = idx_ }
}

/** A subclass of `Microsoft.AspNetCore.Mvc.RazorPages.PageModel` */
class PageModelClass extends Class {
  PageModelClass() {
    this.getABaseType+().hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.RazorPages", "PageModel")
  }

  /** Gets a handler method such as `OnGetAsync` */
  Method getAHandlerMethod() {
    result = this.getAMethod() and
    result.getName().matches("On%") and
    not exists(Attribute attr |
      attr = result.getAnAttribute() and
      attr.getType()
          .hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.RazorPages", "NonHandlerAttribute")
    )
  }

  /** Gets the Razor Page that has this PageModel. */
  RazorViewClass getPage() {
    exists(Property modelProp |
      modelProp.hasName("Model") and
      modelProp.getType() = this and
      modelProp.getDeclaringType() = result
    )
  }
}

private MethodCall getAPageCall(PageModelClass pm) {
  result.getEnclosingCallable() = pm.getAHandlerMethod() and
  result
      .getTarget()
      .hasFullyQualifiedName("Microsoft.AspNetCore.Mvc.RazorPages", "PageModel",
        ["Page", "RedirectToPage"])
}

private ThisAccess getThisCallInVoidHandler(PageModelClass pm) {
  result.getEnclosingCallable() = pm.getAHandlerMethod() and
  result.getEnclosingCallable().getReturnType() instanceof VoidType
}

private class PageModelJumpNode extends DataFlow::NonLocalJumpNode {
  PageModelClass pm;

  PageModelJumpNode() {
    this.asExpr() = getAPageCall(pm).getQualifier()
    or
    this.(PostUpdateNode).getPreUpdateNode().asExpr() = getThisCallInVoidHandler(pm)
  }

  override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
    preservesValue = true and
    exists(PropertyAccess modelProp |
      result.asExpr() = modelProp and
      modelProp.getTarget().hasName("Model") and
      modelProp.getEnclosingCallable().getDeclaringType() = pm.getPage()
    )
  }
}
