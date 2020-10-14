/**
 * Provides the core classes for working with AngularJS applications.
 *
 * As the module grows, large features might move to separate files.
 *
 * INTERNAL: Do not import this module directly, import `AngularJS` instead.
 *
 * NOTE: The API of this library is not stable yet and may change in
 *       the future.
 */

import javascript
private import AngularJS

/**
 * Holds if `nd` is a reference to the `angular` variable.
 */
DataFlow::SourceNode angular() {
  // either as a global
  result = DataFlow::globalVarRef("angular")
  or
  // or imported from a module named `angular`
  result = DataFlow::moduleImport("angular")
}

/**
 * Holds if `tl` appears to be a top-level using the AngularJS library.
 *
 * Should not depend on the `SourceNode` class.
 */
pragma[nomagic]
private predicate isAngularTopLevel(TopLevel tl) {
  exists(Import imprt |
    imprt.getTopLevel() = tl and
    imprt.getImportedPath().getValue() = "angular"
  )
  or
  exists(GlobalVarAccess global |
    global.getName() = "angular" and
    global.getTopLevel() = tl
  )
}

/**
 * Holds if `s` is a string in a top-level using the AngularJS library.
 *
 * Should not depend on the `SourceNode` class.
 */
pragma[nomagic]
private predicate isAngularString(Expr s) {
  isAngularTopLevel(s.getTopLevel()) and
  (
    s instanceof StringLiteral or
    s instanceof TemplateLiteral
  )
}

/**
 * String literals in Angular code are often used as identifiers or references, so we
 * want to track them.
 */
private class TrackStringsInAngularCode extends DataFlow::SourceNode::Range, DataFlow::ValueNode {
  TrackStringsInAngularCode() { isAngularString(astNode) }
}

/**
 * Holds if `m` is of the form `angular.module("name", ...)`.
 */
private DataFlow::CallNode angularModuleCall(string name) {
  result = angular().getAMemberCall("module") and
  result.getArgument(0).asExpr().mayHaveStringValue(name)
}

/**
 * An AngularJS module for which there is a definition or at least a lookup.
 */
private newtype TAngularModule = MkAngularModule(string name) { exists(angularModuleCall(name)) }

/**
 * An AngularJS module.
 */
class AngularModule extends TAngularModule {
  string name;

  AngularModule() { this = MkAngularModule(name) }

  /**
   * Get a definition for this module, that is, a call of the form
   * `angular.module("name", deps)`.
   */
  DataFlow::CallNode getADefinition() {
    result = angularModuleCall(name) and
    result.getNumArgument() > 1
  }

  /**
   * Gets a lookup of this module, that is, a call of the form
   * `angular.module("name")`.
   */
  DataFlow::CallNode getALookup() {
    result = angularModuleCall(name) and
    result.getNumArgument() = 1
  }

  /**
   * Get the array of dependencies from this module's definition.
   */
  ArrayExpr getDependencyArray() {
    getADefinition().getArgument(1).getALocalSource().asExpr() = result
  }

  /**
   * Gets another module that this module lists as a dependency.
   */
  AngularModule getADependency() {
    getDependencyArray().getAnElement().mayHaveStringValue(result.getName())
  }

  /**
   * Gets the name of this module.
   */
  string getName() { result = name }

  /**
   * Gets a textual representation of this module.
   */
  string toString() { result = name }
}

/**
 * Holds if `nd` is a reference to module `m`, that is, it is either
 * a definition of `m`, a lookup of `m`, or a chained method call on
 * `m`.
 */
DataFlow::CallNode moduleRef(AngularModule m) {
  result = m.getADefinition()
  or
  result = m.getALookup()
  or
  exists(DataFlow::CallNode inner, string methodName |
    inner = moduleRef(m) and
    result = inner.getAMethodCall(methodName) and
    // the one-argument variant of `info` is not chaining
    not (methodName = "info" and result.getNumArgument() = 1)
  )
}

/**
 * A call to a method from the `angular.Module` API.
 */
class ModuleApiCall extends DataFlow::CallNode {
  /** The module on which the method is called. */
  AngularModule mod;
  /** The name of the called method. */
  string methodName;

  ModuleApiCall() { this = moduleRef(mod).getAMethodCall(methodName) }

  /**
   * Gets the name of the invoked method.
   */
  string getMethodName() { result = methodName }
}

class ModuleApiCallDependencyInjection extends DependencyInjection {
  ModuleApiCall call;
  string methodName;

  ModuleApiCallDependencyInjection() {
    this = call and
    methodName = call.getMethodName()
  }

  /**
   * Gets the argument position for this method call that expects an injectable function.
   *
   * This method excludes the method names that are also present on the AngularJS '$provide' object.
   */
  private int injectableArgPos() {
    (
      methodName = "directive" or
      methodName = "filter" or
      methodName = "controller" or
      methodName = "animation"
    ) and
    result = 1
    or
    (methodName = "config" or methodName = "run") and
    result = 0
  }

  override DataFlow::Node getAnInjectableFunction() {
    result = call.getArgument(injectableArgPos())
  }
}

/**
 * Holds if `name` is the name of a built-in AngularJS directive
 * (cf. https://docs.angularjs.org/api/ng/directive/).
 */
private predicate builtinDirective(string name) {
  name = "ngApp" or
  name = "ngBind" or
  name = "ngBindHtml" or
  name = "ngBindTemplate" or
  name = "ngBlur" or
  name = "ngChange" or
  name = "ngChecked" or
  name = "ngClass" or
  name = "ngClassEven" or
  name = "ngClassOdd" or
  name = "ngClick" or
  name = "ngCloak" or
  name = "ngController" or
  name = "ngCopy" or
  name = "ngCsp" or
  name = "ngCut" or
  name = "ngDblclick" or
  name = "ngDisabled" or
  name = "ngFocus" or
  name = "ngForm" or
  name = "ngHide" or
  name = "ngHref" or
  name = "ngIf" or
  name = "ngInclude" or
  name = "ngInit" or
  name = "ngJq" or
  name = "ngKeydown" or
  name = "ngKeypress" or
  name = "ngKeyup" or
  name = "ngList" or
  name = "ngMaxlength" or
  name = "ngMinlength" or
  name = "ngModel" or
  name = "ngModelOptions" or
  name = "ngMousedown" or
  name = "ngMouseenter" or
  name = "ngMouseleave" or
  name = "ngMousemove" or
  name = "ngMouseover" or
  name = "ngMouseup" or
  name = "ngNonBindable" or
  name = "ngOpen" or
  name = "ngOptions" or
  name = "ngPaste" or
  name = "ngPattern" or
  name = "ngPluralize" or
  name = "ngReadonly" or
  name = "ngRepeat" or
  name = "ngRequired" or
  name = "ngSelected" or
  name = "ngShow" or
  name = "ngSrc" or
  name = "ngSrcset" or
  name = "ngStyle" or
  name = "ngSubmit" or
  name = "ngSwitch" or
  name = "ngTransclude" or
  name = "ngValue"
}

private newtype TDirectiveInstance =
  MkBuiltinDirective(string name) { builtinDirective(name) } or
  MkCustomDirective(DirectiveDefinition def) or
  MkCustomComponent(ComponentDefinition def)

/**
 * An AngularJS directive, either built-in or custom.
 */
class DirectiveInstance extends TDirectiveInstance {
  /**
   * Gets the name of this directive.
   */
  abstract string getName();

  /**
   * Gets a directive target matching this directive.
   */
  DirectiveTarget getATarget() {
    this.getName() = result.getName().(DirectiveTargetName).normalize()
  }

  /**
   * Gets a DOM element matching this directive.
   */
  DOM::ElementDefinition getAMatchingElement() { result = getATarget().getElement() }

  /** Gets a textual representation of this directive. */
  string toString() { result = getName() }

  /**
   * Gets a scope object for this directive.
   */
  AngularScope getAScope() { result.mayApplyTo(getAMatchingElement()) }
}

/**
 * A built-in AngularJS directive.
 */
class BuiltinDirective extends DirectiveInstance, MkBuiltinDirective {
  string name;

  BuiltinDirective() { this = MkBuiltinDirective(name) }

  override string getName() { result = name }
}

/**
 * A custom AngularJS directive, either a general directive defined by `angular.directive`
 * or a component defined by `angular.component`.
 */
abstract class CustomDirective extends DirectiveInstance {
  /** Gets the element defining this directive. */
  abstract DataFlow::Node getDefinition();

  /** Gets the data flow node from which member `name` of this directive is initialized. */
  abstract DataFlow::ValueNode getMemberInit(string name);

  /** Gets the member `name` of this directive. */
  DataFlow::SourceNode getMember(string name) { result.flowsTo(getMemberInit(name)) }

  /** Gets the method `name` of this directive. */
  Function getMethod(string name) { DataFlow::valueNode(result) = getMember(name) }

  /** Gets a link function of this directive. */
  abstract Function getALinkFunction();

  /** Holds if this directive's properties are bound to the controller. */
  abstract predicate bindsToController();

  /** Holds if this directive introduces an isolate scope. */
  abstract predicate hasIsolateScope();

  /** Gets a node that contributes to the return value of the factory function. */
  abstract DataFlow::SourceNode getAnInstantiation();

  /** Gets the controller function of this directive, if any. */
  InjectableFunction getController() { result = getMember("controller") }

  /** Gets the template URL of this directive, if any. */
  string getTemplateUrl() { getMember("templateUrl").asExpr().mayHaveStringValue(result) }

  /**
   * Gets a template file for this directive, if any.
   */
  HTML::HtmlFile getATemplateFile() {
    result.getAbsolutePath().regexpMatch(".*/\\Q" + getTemplateUrl() + "\\E")
  }

  /**
   * Gets a scope object for this directive.
   */
  override AngularScope getAScope() {
    if hasIsolateScope()
    then result = MkIsolateScope(this)
    else result = DirectiveInstance.super.getAScope()
  }

  private string getRestrictionString() {
    getMember("restrict").asExpr().mayHaveStringValue(result)
  }

  private predicate hasTargetType(DirectiveTargetType type) {
    not exists(getRestrictionString()) or
    getRestrictionString().indexOf(type.toString()) != -1
  }

  override DirectiveTarget getATarget() {
    result = DirectiveInstance.super.getATarget() and
    hasTargetType(result.getType())
  }
}

/**
 * A custom AngularJS directive defined by `angular.directive`.
 */
class GeneralDirective extends CustomDirective, MkCustomDirective {
  /** The definition of this directive. */
  DirectiveDefinition definition;

  GeneralDirective() { this = MkCustomDirective(definition) }

  override string getName() { result = definition.getName() }

  override DataFlow::Node getDefinition() { result = definition }

  /** Gets a node that contributes to the return value of the factory function. */
  override DataFlow::SourceNode getAnInstantiation() {
    exists(Function factory, InjectableFunction f |
      f = definition.getAFactoryFunction() and
      factory = f.asFunction() and
      result.flowsToExpr(factory.getAReturnedExpr())
    )
  }

  override DataFlow::ValueNode getMemberInit(string name) {
    getAnInstantiation().hasPropertyWrite(name, result)
  }

  /** Gets the compile function of this directive, if any. */
  Function getCompileFunction() { result = getMethod("compile") }

  /**
   * Gets a pre/post link function of this directive defined on its definition object.
   * If `kind` is `"pre"`, the result is a `preLink` function. If `kind` is `"post"`,
   * the result is a `postLink` function..
   *
   * See https://docs.angularjs.org/api/ng/service/$compile for documentation of
   * the directive definition API. We do not model the precedence of `compile` over
   * `link`.
   */
  private DataFlow::FunctionNode getLinkFunction(string kind) {
    // { link: function postLink() { ... } }
    kind = "post" and
    result = getMember("link")
    or
    // { link: { pre: function preLink() { ... }, post: function postLink() { ... } } }
    (kind = "pre" or kind = "post") and
    result = getMember("link").getAPropertySource(kind)
    or
    // { compile: function() { ... return link; } }
    exists(Expr compileReturn, DataFlow::SourceNode compileReturnSrc |
      compileReturn = getCompileFunction().getAReturnedExpr() and
      compileReturnSrc.flowsToExpr(compileReturn)
    |
      // link = function postLink() { ... }
      kind = "post" and
      result = compileReturnSrc
      or
      // link = { pre: function preLink() { ... }, post: function postLink() { ... } }
      (kind = "pre" or kind = "post") and
      result = compileReturnSrc.getAPropertySource(kind)
    )
  }

  /** Gets the pre-link function of this directive. */
  Function getPreLinkFunction() { result = getLinkFunction("pre").getAstNode() }

  /** Gets the post-link function of this directive. */
  Function getPostLinkFunction() { result = getLinkFunction("post").getAstNode() }

  override Function getALinkFunction() { result = getLinkFunction(_).getAstNode() }

  override predicate bindsToController() {
    getMemberInit("bindToController").asExpr().mayHaveBooleanValue(true)
  }

  override predicate hasIsolateScope() { getMember("scope").asExpr() instanceof ObjectExpr }
}

/**
 * An AngularJS component defined by `angular.component`.
 */
class ComponentDirective extends CustomDirective, MkCustomComponent {
  /** The definition of this component. */
  ComponentDefinition comp;

  ComponentDirective() { this = MkCustomComponent(comp) }

  override string getName() { result = comp.getName() }

  override DataFlow::Node getDefinition() { result = comp }

  pragma[nomagic]
  override DataFlow::ValueNode getMemberInit(string name) {
    comp.getConfig().hasPropertyWrite(name, result)
  }

  override Function getALinkFunction() { none() }

  override predicate bindsToController() { none() }

  override predicate hasIsolateScope() { any() }

  override DataFlow::SourceNode getAnInstantiation() { result = comp.getConfig() }
}

private newtype TDirectiveTargetType =
  E() or
  A() or
  C() or
  M()

/**
 * The type of a directive target, indicating whether it is an element ("E"),
 * an attribute ("A"), a class name ("C") or a comment ("M").
 */
class DirectiveTargetType extends TDirectiveTargetType {
  /**
   * Gets a textual representation of this target type.
   */
  string toString() {
    this = E() and result = "E"
    or
    this = A() and result = "A"
    or
    this = C() and result = "C"
    or
    this = M() and result = "M"
  }
}

/**
 * A syntactic element to which an AngularJS directive can be attached.
 */
abstract class DirectiveTarget extends Locatable {
  /**
   * Gets the name of this directive target, which is used to match it up
   * with any AngularJS directives that apply to it.
   *
   * This name is not normalized.
   */
  abstract string getName();

  /**
   * Gets the element which AngularJS directives attached to this target
   * match.
   */
  abstract DOM::ElementDefinition getElement();

  /**
   * Gets the type of this directive target.
   */
  abstract DirectiveTargetType getType();
}

/**
 * A DOM element, viewed as directive target.
 */
private class DomElementAsElement extends DirectiveTarget {
  DOM::ElementDefinition element;

  DomElementAsElement() { this = element }

  override string getName() { result = element.getName() }

  override DOM::ElementDefinition getElement() { result = element }

  override DirectiveTargetType getType() { result = E() }
}

/**
 * A DOM attribute, viewed as a directive target.
 */
private class DomAttributeAsElement extends DirectiveTarget {
  DOM::AttributeDefinition attr;

  DomAttributeAsElement() { this = attr }

  override string getName() { result = attr.getName() }

  override DOM::ElementDefinition getElement() { result = attr.getElement() }

  override DirectiveTargetType getType() { result = A() }

  DOM::AttributeDefinition asAttribute() { result = attr }
}

/**
 * The name of a directive target.
 *
 * This class implements directive name normalization as described in
 * https://docs.angularjs.org/guide/directive: leading `x-` or `data-`
 * is stripped, then the `:`, `-` or `_`-delimited name is converted to
 * camel case.
 */
class DirectiveTargetName extends string {
  DirectiveTargetName() { this = any(DirectiveTarget e).getName() }

  /**
   * Gets the `i`th component of this name, where `-`,
   * `:` and `_` count as component delimiters.
   */
  string getRawComponent(int i) {
    result = toLowerCase().regexpFind("(?<=^|[-:_])[a-zA-Z0-9]+(?=$|[-:_])", i, _)
  }

  /**
   * Holds if the first component of this name is `x` or `data`,
   * and hence should be stripped when normalizing.
   */
  predicate stripFirstComponent() { getRawComponent(0) = "x" or getRawComponent(0) = "data" }

  /**
   * Gets the `i`th component of this name after processing:
   * the first component is stripped if it is `x` or `data`,
   * and all components except the first are capitalized.
   */
  string getProcessedComponent(int i) {
    exists(int j, string raw |
      i >= 0 and
      if stripFirstComponent() then j = i + 1 else j = i
    |
      raw = getRawComponent(j) and
      if i = 0 then result = raw else result = capitalize(raw)
    )
  }

  /**
   * Gets the camelCase version of this name.
   */
  string normalize() {
    result = concat(string c, int i | c = getProcessedComponent(i) | c, "" order by i)
  }
}

/**
 * A call to a getter method of the `$location` service, viewed as a source of
 * user-controlled data.
 *
 * To avoid false positives, we don't consider `$location.url` and similar as
 * remote flow sources, since they are only partly user-controlled.
 *
 * See https://docs.angularjs.org/api/ng/service/$location for details.
 */
private class LocationFlowSource extends RemoteFlowSource {
  LocationFlowSource() {
    exists(ServiceReference service, MethodCallExpr mce, string m, int n |
      service.getName() = "$location" and
      this.asExpr() = mce and
      mce = service.getAMethodCall(m) and
      n = mce.getNumArgument()
    |
      m = "search" and n < 2
      or
      m = "hash" and n = 0
    )
  }

  override string getSourceType() { result = "$location" }
}

/**
 * An access to a property of the `$routeParams` service, viewed as a source
 * of user-controlled data.
 *
 * See https://docs.angularjs.org/api/ngRoute/service/$routeParams for more details.
 */
private class RouteParamSource extends RemoteFlowSource {
  RouteParamSource() {
    exists(ServiceReference service |
      service.getName() = "$routeParams" and
      this = service.getAPropertyAccess(_)
    )
  }

  override string getSourceType() { result = "$routeParams" }
}

/**
 * AngularJS expose a jQuery-like interface through `angular.html(..)`.
 * The interface may be backed by an actual jQuery implementation.
 */
private class JQLiteObject extends JQuery::ObjectSource::Range {
  JQLiteObject() {
    this = angular().getAMemberCall("element")
    or
    exists(Parameter param | this = DataFlow::parameterNode(param) |
      // element parameters to user-functions invoked by AngularJS
      param = any(LinkFunction link).getElementParameter()
      or
      exists(GeneralDirective d |
        param = d.getCompileFunction().getParameter(0)
        or
        exists(DataFlow::FunctionNode f, int i |
          f.flowsToExpr(d.getCompileFunction().getAReturnedExpr()) and i = 1
          or
          f = d.getMember("template") and i = 0
          or
          f = d.getMember("templateUrl") and i = 0
        |
          param = f.getAstNode().(Function).getParameter(i)
        )
      )
    )
    or
    exists(ServiceReference element |
      element.getName() = "$rootElement" or
      element.getName() = "$document"
    |
      this = element.getAReference()
    )
  }
}

/**
 * A call to an AngularJS function.
 *
 * Used for exposing behavior that is similar to the behavior of other libraries.
 */
abstract class AngularJSCall extends CallExpr {
  /**
   * Holds if `e` is an argument that this call interprets as HTML.
   */
  abstract predicate interpretsArgumentAsHtml(Expr e);

  /**
   * Holds if `e` is an argument that this call stores globally, e.g. in a cookie.
   */
  abstract predicate storesArgumentGlobally(Expr e);

  /**
   * Holds if `e` is an argument that this call interprets as code.
   */
  abstract predicate interpretsArgumentAsCode(Expr e);
}

/**
 * A call to a method on the AngularJS object itself.
 */
private class AngularMethodCall extends AngularJSCall {
  MethodCallExpr mce;

  AngularMethodCall() {
    mce = angular().getAMemberCall(_).asExpr() and
    mce = this
  }

  override predicate interpretsArgumentAsHtml(Expr e) {
    mce.getMethodName() = "element" and
    e = mce.getArgument(0)
  }

  override predicate storesArgumentGlobally(Expr e) { none() }

  override predicate interpretsArgumentAsCode(Expr e) { none() }
}

/**
 * A call to a builtin service or one of its methods.
 */
private class BuiltinServiceCall extends AngularJSCall {
  CallExpr call;

  BuiltinServiceCall() {
    exists(BuiltinServiceReference service |
      service.getAMethodCall(_) = this or
      service.getACall() = this
    |
      call = this
    )
  }

  override predicate interpretsArgumentAsHtml(Expr e) {
    exists(ServiceReference service, string methodName |
      service.getName() = "$sce" and
      call = service.getAMethodCall(methodName)
    |
      // specialized call
      (methodName = "trustAsHtml" or methodName = "trustAsCss") and
      e = call.getArgument(0)
      or
      // generic call with enum argument
      methodName = "trustAs" and
      exists(DataFlow::PropRead prn |
        prn.asExpr() = call.getArgument(0) and
        (prn = service.getAPropertyAccess("HTML") or prn = service.getAPropertyAccess("CSS")) and
        e = call.getArgument(1)
      )
    )
  }

  override predicate storesArgumentGlobally(Expr e) {
    exists(ServiceReference service, string serviceName, string methodName |
      service.getName() = serviceName and
      call = service.getAMethodCall(methodName)
    |
      // AngularJS caches (only available during runtime, so similar to sessionStorage)
      (serviceName = "$cacheFactory" or serviceName = "$templateCache") and
      methodName = "put" and
      e = call.getArgument(1)
      or
      serviceName = "$cookies" and
      (methodName = "put" or methodName = "putObject") and
      e = call.getArgument(1)
    )
  }

  override predicate interpretsArgumentAsCode(Expr e) {
    exists(ScopeServiceReference scope, string methodName |
      methodName = "$apply" or
      methodName = "$applyAsync" or
      methodName = "$eval" or
      methodName = "$evalAsync" or
      methodName = "$watch" or
      methodName = "$watchCollection" or
      methodName = "$watchGroup"
    |
      call = scope.getAMethodCall(methodName) and
      e = call.getArgument(0)
    )
    or
    exists(ServiceReference service |
      service.getName() = "$compile" or
      service.getName() = "$parse" or
      service.getName() = "$interpolate"
    |
      call = service.getACall() and
      e = call.getArgument(0)
    )
    or
    exists(ServiceReference service, CallExpr filterInvocation |
      // `$filter('orderBy')(collection, expression)`
      service.getName() = "$filter" and
      call = service.getACall() and
      call.getArgument(0).mayHaveStringValue("orderBy") and
      filterInvocation.getCallee() = call and
      e = filterInvocation.getArgument(1)
    )
  }
}

/**
 * A link-function used in a custom AngularJS directive.
 */
class LinkFunction extends Function {
  LinkFunction() { this = any(GeneralDirective d).getALinkFunction() }

  /**
   * Gets the scope parameter of this function.
   */
  Parameter getScopeParameter() { result = getParameter(0) }

  /**
   * Gets the element parameter of this function (contains a jqLite-wrapped DOM element).
   */
  Parameter getElementParameter() { result = getParameter(1) }

  /**
   * Gets the attributes parameter of this function.
   */
  Parameter getAttributesParameter() { result = getParameter(2) }

  /**
   * Gets the controller parameter of this function.
   */
  Parameter getControllerParameter() { result = getParameter(3) }

  /**
   * Gets the transclude-function parameter of this function.
   */
  Parameter getTranscludeFnParameter() { result = getParameter(4) }
}

/**
 * An abstract representation of a set of AngularJS scope objects.
 */
private newtype TAngularScope =
  MkHtmlFileScope(HTML::HtmlFile file) {
    any(DirectiveInstance d).getAMatchingElement().getFile() = file or
    any(CustomDirective d).getATemplateFile() = file
  } or
  MkIsolateScope(CustomDirective dir) { dir.hasIsolateScope() } or
  MkElementScope(DOM::ElementDefinition elem) {
    any(DirectiveInstance d | not d.(CustomDirective).hasIsolateScope()).getAMatchingElement() =
      elem
  }

/**
 * An abstract representation of a set of AngularJS scope objects.
 */
class AngularScope extends TAngularScope {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /**
   * Gets an access to this scope object.
   */
  Expr getAnAccess() {
    exists(CustomDirective d | this = d.getAScope() |
      exists(Parameter p |
        p = d.getController().getDependencyParameter("$scope") or
        p = d.getALinkFunction().getParameter(0)
      |
        result.mayReferToParameter(p)
      )
      or
      exists(DataFlow::ThisNode dis |
        dis.flowsToExpr(result) and
        dis.getBinder().getAstNode() = d.getController().asFunction() and
        d.bindsToController()
      )
      or
      d.hasIsolateScope() and result = d.getMember("scope").asExpr()
    )
    or
    exists(DirectiveController c, DOM::ElementDefinition elem, Parameter p |
      c.boundTo(elem) and
      this.mayApplyTo(elem) and
      p = c.getFactoryFunction().getDependencyParameter("$scope") and
      result.mayReferToParameter(p)
    )
  }

  /**
   * Holds if this scope may be the scope object of `elt`, i.e. the value of `angular.element(elt).scope()`.
   */
  predicate mayApplyTo(DOM::ElementDefinition elt) {
    this = MkIsolateScope(any(CustomDirective d | d.getAMatchingElement() = elt))
    or
    this = MkElementScope(elt)
    or
    this = MkHtmlFileScope(elt.getFile()) and elt instanceof HTML::Element
  }
}

/**
 * An abstract representation of all the AngularJS scope objects in an HTML file.
 */
class HtmlFileScope extends AngularScope, MkHtmlFileScope {
  HTML::HtmlFile f;

  HtmlFileScope() { this = MkHtmlFileScope(f) }

  override string toString() { result = "scope in " + f.getBaseName() }
}

/**
 * An abstract representation of the AngularJS isolate scope of a directive.
 */
class IsolateScope extends AngularScope, MkIsolateScope {
  CustomDirective dir;

  IsolateScope() { this = MkIsolateScope(dir) }

  override string toString() { result = "isolate scope for " + dir.getName() }

  /**
   * Gets the directive of this isolate scope.
   */
  CustomDirective getDirective() { result = dir }
}

/**
 * An abstract representation of all the AngularJS scope objects for a DOM element.
 */
class ElementScope extends AngularScope, MkElementScope {
  DOM::ElementDefinition elem;

  ElementScope() { this = MkElementScope(elem) }

  override string toString() { result = "scope for " + elem }
}

/**
 * Holds if `nd` is a reference to the `$routeProvider` service, that is,
 * it is either an access of `$routeProvider`, or a chained method call on
 * `$routeProvider`.
 */
DataFlow::SourceNode routeProviderRef() {
  result = builtinServiceRef("$routeProvider")
  or
  exists(string m | m = "when" or m = "otherwise" | result = routeProviderRef().getAMethodCall(m))
}

/**
 * A setup of an AngularJS "route", using the `$routeProvider` API.
 */
class RouteSetup extends DataFlow::CallNode, DependencyInjection {
  int optionsArgumentIndex;

  RouteSetup() {
    exists(string methodName | this = routeProviderRef().getAMethodCall(methodName) |
      methodName = "otherwise" and optionsArgumentIndex = 0
      or
      methodName = "when" and optionsArgumentIndex = 1
    )
  }

  /**
   * Gets the value of property `name` of the params-object provided to this call.
   */
  DataFlow::SourceNode getRouteParam(string name) {
    result.flowsTo(getOptionArgument(optionsArgumentIndex, name))
  }

  /**
   * Gets the "controller" value of this call, possibly resolving a service name.
   */
  InjectableFunction getController() {
    exists(DataFlow::SourceNode controllerProperty |
      // Note that `.getController` cannot be used here, since that involves a cast to InjectableFunction, and that cast only succeeds because of this method
      controllerProperty = getRouteParam("controller")
    |
      result = controllerProperty
      or
      exists(ControllerDefinition def |
        controllerProperty.asExpr().mayHaveStringValue(def.getName())
      |
        result = def.getAService()
      )
    )
  }

  override DataFlow::Node getAnInjectableFunction() { result = getRouteParam("controller") }
}

/**
 * An AngularJS controller instance.
 */
abstract class Controller extends DataFlow::Node {
  /**
   * Holds if this controller is bound to `elem`.
   */
  abstract predicate boundTo(DOM::ElementDefinition elem);

  /**
   * Holds if this controller is bound to `elem` as `alias`.
   */
  abstract predicate boundToAs(DOM::ElementDefinition elem, string alias);

  /**
   * Gets the factory function of this controller.
   */
  abstract InjectableFunction getFactoryFunction();
}

/**
 * A controller instantiated through a directive, e.g. `<div ngController="myController"/>`.
 */
private class DirectiveController extends Controller {
  ControllerDefinition def;

  DirectiveController() { this = def }

  private predicate boundAnonymously(DOM::ElementDefinition elem) {
    exists(DirectiveInstance instance, DomAttributeAsElement attr |
      instance.getName() = "ngController" and
      instance.getATarget() = attr and
      elem = attr.getElement() and
      attr.asAttribute().getStringValue() = def.getName()
    )
  }

  override predicate boundTo(DOM::ElementDefinition elem) {
    boundAnonymously(elem) or boundToAs(elem, _)
  }

  override predicate boundToAs(DOM::ElementDefinition elem, string alias) {
    exists(DirectiveInstance instance, DomAttributeAsElement attr |
      instance.getName() = "ngController" and
      instance.getATarget() = attr and
      elem = attr.getElement() and
      exists(string attributeValue, string pattern |
        attributeValue = attr.asAttribute().getStringValue() and
        pattern = "([^ ]+) +as +([^ ]+)"
      |
        attributeValue.regexpCapture(pattern, 1) = def.getName() and
        attributeValue.regexpCapture(pattern, 2) = alias
      )
    )
  }

  override InjectableFunction getFactoryFunction() { result = def.getAFactoryFunction() }
}

/**
 * A controller instantiated through routes, e.g. `$routeProvider.otherwise({controller: ...})`.
 */
private class RouteInstantiatedController extends Controller {
  RouteSetup setup;

  RouteInstantiatedController() { this = setup }

  override InjectableFunction getFactoryFunction() { result = setup.getController() }

  override predicate boundTo(DOM::ElementDefinition elem) {
    exists(string url, HTML::HtmlFile template |
      setup.getRouteParam("templateUrl").asExpr().mayHaveStringValue(url) and
      template.getAbsolutePath().regexpMatch(".*\\Q" + url + "\\E") and
      elem.getFile() = template
    )
  }

  override predicate boundToAs(DOM::ElementDefinition elem, string name) {
    boundTo(elem) and
    setup.getRouteParam("controllerAs").asExpr().mayHaveStringValue(name)
  }
}

/**
 * Dataflow for the arguments of AngularJS dependency-injected functions.
 */
private class DependencyInjectedArgumentInitializer extends DataFlow::AnalyzedNode {
  DataFlow::AnalyzedNode service;

  DependencyInjectedArgumentInitializer() {
    exists(
      AngularJS::InjectableFunction f, Parameter param, AngularJS::CustomServiceDefinition def
    |
      this = DataFlow::parameterNode(param) and
      def.getServiceReference() = f.getAResolvedDependency(param) and
      service = def.getAService()
    )
  }

  override AbstractValue getAValue() {
    result = DataFlow::AnalyzedNode.super.getAValue() or
    result = service.getALocalValue()
  }
}

/**
 * A call to `angular.bind`, as a partial function invocation.
 */
private class BindCall extends DataFlow::PartialInvokeNode::Range, DataFlow::CallNode {
  BindCall() { this = angular().getAMemberCall("bind") }

  override predicate isPartialArgument(DataFlow::Node callback, DataFlow::Node argument, int index) {
    index >= 0 and
    callback = getArgument(1) and
    argument = getArgument(index + 2)
  }

  override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
    callback = getArgument(1) and
    boundArgs = getNumArgument() - 2 and
    result = this
  }

  override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    callback = getArgument(1) and
    result = getArgument(0)
  }
}
