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
  result.getArgument(0).mayHaveStringValue(name)
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
  DataFlow::ArrayCreationNode getDependencyArray() {
    this.getADefinition().getArgument(1).getALocalSource() = result
  }

  /**
   * Gets another module that this module lists as a dependency.
   */
  AngularModule getADependency() {
    this.getDependencyArray().getAnElement().mayHaveStringValue(result.getName())
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
  /** The name of the called method. */
  string methodName;

  ModuleApiCall() { this = moduleRef(_).getAMethodCall(methodName) }

  /**
   * Gets the name of the invoked method.
   */
  string getMethodName() { result = methodName }
}

class ModuleApiCallDependencyInjection extends DependencyInjection instanceof ModuleApiCall {
  string methodName;

  ModuleApiCallDependencyInjection() { methodName = super.getMethodName() }

  /**
   * Gets the argument position for this method call that expects an injectable function.
   *
   * This method excludes the method names that are also present on the AngularJS '$provide' object.
   */
  private int injectableArgPos() {
    methodName = ["directive", "filter", "controller", "animation"] and
    result = 1
    or
    methodName = ["config", "run"] and
    result = 0
  }

  override DataFlow::Node getAnInjectableFunction() {
    result = super.getArgument(this.injectableArgPos())
  }
}

/**
 * Holds if `name` is the name of a built-in AngularJS directive
 * (cf. https://docs.angularjs.org/api/ng/directive/).
 */
private predicate builtinDirective(string name) {
  name =
    [
      "ngApp", "ngBind", "ngBindHtml", "ngBindTemplate", "ngBlur", "ngChange", "ngChecked",
      "ngClass", "ngClassEven", "ngClassOdd", "ngClick", "ngCloak", "ngController", "ngCopy",
      "ngCsp", "ngCut", "ngDblclick", "ngDisabled", "ngFocus", "ngForm", "ngHide", "ngHref", "ngIf",
      "ngInclude", "ngInit", "ngJq", "ngKeydown", "ngKeypress", "ngKeyup", "ngList", "ngMaxlength",
      "ngMinlength", "ngModel", "ngModelOptions", "ngMousedown", "ngMouseenter", "ngMouseleave",
      "ngMousemove", "ngMouseover", "ngMouseup", "ngNonBindable", "ngOpen", "ngOptions", "ngPaste",
      "ngPattern", "ngPluralize", "ngReadonly", "ngRepeat", "ngRequired", "ngSelected", "ngShow",
      "ngSrc", "ngSrcset", "ngStyle", "ngSubmit", "ngSwitch", "ngTransclude", "ngValue"
    ]
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
  DOM::ElementDefinition getAMatchingElement() { result = this.getATarget().getElement() }

  /** Gets a textual representation of this directive. */
  string toString() { result = this.getName() }

  /**
   * Gets a scope object for this directive.
   */
  AngularScope getAScope() { result.mayApplyTo(this.getAMatchingElement()) }
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
  DataFlow::SourceNode getMember(string name) { result.flowsTo(this.getMemberInit(name)) }

  /** Gets the method `name` of this directive. */
  DataFlow::FunctionNode getMethod(string name) { result = this.getMember(name) }

  /** Gets a link function of this directive. */
  abstract DataFlow::FunctionNode getALinkFunction();

  /** Holds if this directive's properties are bound to the controller. */
  abstract predicate bindsToController();

  /** Holds if this directive introduces an isolate scope. */
  abstract predicate hasIsolateScope();

  /** Gets a node that contributes to the return value of the factory function. */
  abstract DataFlow::SourceNode getAnInstantiation();

  /** Gets the controller function of this directive, if any. */
  InjectableFunction getController() { result = this.getMember("controller") }

  /** Gets the template URL of this directive, if any. */
  string getTemplateUrl() { this.getMember("templateUrl").mayHaveStringValue(result) }

  /**
   * Gets a template file for this directive, if any.
   */
  HTML::HtmlFile getATemplateFile() {
    result.getAbsolutePath().regexpMatch(".*/\\Q" + this.getTemplateUrl() + "\\E")
  }

  /**
   * Gets a scope object for this directive.
   */
  override AngularScope getAScope() {
    if this.hasIsolateScope()
    then result = MkIsolateScope(this)
    else result = DirectiveInstance.super.getAScope()
  }

  private string getRestrictionString() { this.getMember("restrict").mayHaveStringValue(result) }

  private predicate hasTargetType(DirectiveTargetType type) {
    not exists(this.getRestrictionString()) or
    this.getRestrictionString().indexOf(type.toString()) != -1
  }

  override DirectiveTarget getATarget() {
    result = DirectiveInstance.super.getATarget() and
    this.hasTargetType(result.getType())
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
    exists(DataFlow::FunctionNode factory, InjectableFunction f |
      f = definition.getAFactoryFunction() and
      factory = f.asFunction() and
      result.flowsTo(factory.getAReturn())
    )
  }

  override DataFlow::ValueNode getMemberInit(string name) {
    this.getAnInstantiation().hasPropertyWrite(name, result)
  }

  /** Gets the compile function of this directive, if any. */
  DataFlow::FunctionNode getCompileFunction() { result = this.getMethod("compile") }

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
    result = this.getMember("link")
    or
    // { link: { pre: function preLink() { ... }, post: function postLink() { ... } } }
    (kind = "pre" or kind = "post") and
    result = this.getMember("link").getAPropertySource(kind)
    or
    // { compile: function() { ... return link; } }
    exists(DataFlow::SourceNode compileReturnSrc |
      compileReturnSrc.flowsTo(this.getCompileFunction().getAReturn())
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
  DataFlow::FunctionNode getPreLinkFunction() { result = this.getLinkFunction("pre") }

  /** Gets the post-link function of this directive. */
  DataFlow::FunctionNode getPostLinkFunction() { result = this.getLinkFunction("post") }

  override DataFlow::FunctionNode getALinkFunction() { result = this.getLinkFunction(_) }

  override predicate bindsToController() {
    this.getMemberInit("bindToController").mayHaveBooleanValue(true)
  }

  override predicate hasIsolateScope() {
    this.getMember("scope") instanceof DataFlow::ObjectLiteralNode
  }
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

  override DataFlow::FunctionNode getALinkFunction() { none() }

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
private class DomElementAsElement extends DirectiveTarget instanceof DOM::ElementDefinition {
  override string getName() { result = DOM::ElementDefinition.super.getName() }

  override DOM::ElementDefinition getElement() { result = this }

  override DirectiveTargetType getType() { result = E() }
}

/**
 * A DOM attribute, viewed as a directive target.
 */
private class DomAttributeAsElement extends DirectiveTarget instanceof DOM::AttributeDefinition {
  override string getName() { result = DOM::AttributeDefinition.super.getName() }

  override DOM::ElementDefinition getElement() {
    result = DOM::AttributeDefinition.super.getElement()
  }

  override DirectiveTargetType getType() { result = A() }

  DOM::AttributeDefinition asAttribute() { result = this }
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
    result = this.toLowerCase().regexpFind("(?<=^|[-:_])[a-zA-Z0-9]+(?=$|[-:_])", i, _)
  }

  /**
   * Holds if the first component of this name is `x` or `data`,
   * and hence should be stripped when normalizing.
   */
  predicate stripFirstComponent() {
    this.getRawComponent(0) = "x" or this.getRawComponent(0) = "data"
  }

  /**
   * Gets the `i`th component of this name after processing:
   * the first component is stripped if it is `x` or `data`,
   * and all components except the first are capitalized.
   */
  string getProcessedComponent(int i) {
    exists(int j, string raw |
      i >= 0 and
      if this.stripFirstComponent() then j = i + 1 else j = i
    |
      raw = this.getRawComponent(j) and
      if i = 0 then result = raw else result = capitalize(raw)
    )
  }

  /**
   * Gets the camelCase version of this name.
   */
  string normalize() {
    result = concat(string c, int i | c = this.getProcessedComponent(i) | c, "" order by i)
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
private class LocationFlowSource extends RemoteFlowSource instanceof DataFlow::MethodCallNode {
  LocationFlowSource() {
    exists(ServiceReference service, string m, int n |
      service.getName() = "$location" and
      this = service.getAMethodCall(m) and
      n = super.getNumArgument()
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
private class RouteParamSource extends ClientSideRemoteFlowSource {
  RouteParamSource() {
    exists(ServiceReference service |
      service.getName() = "$routeParams" and
      this = service.getAPropertyAccess(_)
    )
  }

  override string getSourceType() { result = "$routeParams" }

  override ClientSideRemoteFlowKind getKind() { result.isPath() }
}

/**
 * AngularJS expose a jQuery-like interface through `angular.html(..)`.
 * The interface may be backed by an actual jQuery implementation.
 */
private class JQLiteObject extends JQuery::ObjectSource::Range {
  JQLiteObject() {
    this = angular().getAMemberCall("element")
    or
    exists(DataFlow::ParameterNode param | this = param |
      // element parameters to user-functions invoked by AngularJS
      param = any(LinkFunction link).getElementParameter()
      or
      exists(GeneralDirective d |
        param = d.getCompileFunction().getParameter(0)
        or
        exists(DataFlow::FunctionNode f, int i |
          f.flowsTo(d.getCompileFunction().getAReturn()) and i = 1
          or
          f = d.getMember("template") and i = 0
          or
          f = d.getMember("templateUrl") and i = 0
        |
          param = f.getParameter(i)
        )
      )
    )
    or
    exists(ServiceReference element | element.getName() = ["$rootElement", "$document"] |
      this = element.getAReference()
    )
  }
}

/**
 * A call to an AngularJS function.
 *
 * Used for exposing behavior that is similar to the behavior of other libraries.
 */
abstract class AngularJSCallNode extends DataFlow::CallNode {
  /**
   * Holds if `e` is an argument that this call interprets as HTML.
   */
  abstract predicate interpretsArgumentAsHtml(DataFlow::Node e);

  /**
   * Holds if `e` is an argument that this call stores globally, e.g. in a cookie.
   */
  abstract predicate storesArgumentGlobally(DataFlow::Node e);

  /**
   * Holds if `e` is an argument that this call interprets as code.
   */
  abstract predicate interpretsArgumentAsCode(DataFlow::Node e);
}

/**
 * A call to a method on the AngularJS object itself.
 */
private class AngularMethodCall extends AngularJSCallNode {
  AngularMethodCall() { this = angular().getAMemberCall(_) }

  override predicate interpretsArgumentAsHtml(DataFlow::Node e) {
    super.getCalleeName() = "element" and
    e = super.getArgument(0)
  }

  override predicate storesArgumentGlobally(DataFlow::Node e) { none() }

  override predicate interpretsArgumentAsCode(DataFlow::Node e) { none() }
}

/**
 * A call to a builtin service or one of its methods.
 */
private class BuiltinServiceCall extends AngularJSCallNode {
  BuiltinServiceCall() {
    exists(BuiltinServiceReference service |
      service.getAMethodCall(_) = this or
      service.getACall() = this
    )
  }

  override predicate interpretsArgumentAsHtml(DataFlow::Node e) {
    exists(ServiceReference service, string methodName |
      service.getName() = "$sce" and
      this = service.getAMethodCall(methodName)
    |
      // specialized call
      (methodName = "trustAsHtml" or methodName = "trustAsCss") and
      e = this.getArgument(0)
      or
      // generic call with enum argument
      methodName = "trustAs" and
      exists(DataFlow::PropRead prn |
        prn = this.getArgument(0) and
        (prn = service.getAPropertyAccess("HTML") or prn = service.getAPropertyAccess("CSS")) and
        e = this.getArgument(1)
      )
    )
  }

  override predicate storesArgumentGlobally(DataFlow::Node e) {
    exists(ServiceReference service, string serviceName, string methodName |
      service.getName() = serviceName and
      this = service.getAMethodCall(methodName)
    |
      // AngularJS caches (only available during runtime, so similar to sessionStorage)
      (serviceName = "$cacheFactory" or serviceName = "$templateCache") and
      methodName = "put" and
      e = this.getArgument(1)
      or
      serviceName = "$cookies" and
      (methodName = "put" or methodName = "putObject") and
      e = this.getArgument(1)
    )
  }

  override predicate interpretsArgumentAsCode(DataFlow::Node e) {
    exists(ScopeServiceReference scope, string methodName |
      methodName =
        [
          "$apply", "$applyAsync", "$eval", "$evalAsync", "$watch", "$watchCollection",
          "$watchGroup"
        ]
    |
      this = scope.getAMethodCall(methodName) and
      e = this.getArgument(0)
    )
    or
    exists(ServiceReference service | service.getName() = ["$compile", "$parse", "$interpolate"] |
      this = service.getACall() and
      e = this.getArgument(0)
    )
    or
    exists(ServiceReference service |
      // `$filter('orderBy')(collection, expression)`
      service.getName() = "$filter" and
      this = service.getACall() and
      this.getArgument(0).mayHaveStringValue("orderBy") and
      e = this.getACall().getArgument(1)
    )
  }
}

/**
 * A link-function used in a custom AngularJS directive.
 */
class LinkFunction extends DataFlow::FunctionNode {
  LinkFunction() { this = any(GeneralDirective d).getALinkFunction() }

  /**
   * Gets the scope parameter of this function.
   */
  DataFlow::ParameterNode getScopeParameter() { result = this.getParameter(0) }

  /**
   * Gets the element parameter of this function (contains a jqLite-wrapped DOM element).
   */
  DataFlow::ParameterNode getElementParameter() { result = this.getParameter(1) }

  /**
   * Gets the attributes parameter of this function.
   */
  DataFlow::ParameterNode getAttributesParameter() { result = this.getParameter(2) }

  /**
   * Gets the controller parameter of this function.
   */
  DataFlow::ParameterNode getControllerParameter() { result = this.getParameter(3) }

  /**
   * Gets the transclude-function parameter of this function.
   */
  DataFlow::ParameterNode getTranscludeFnParameter() { result = this.getParameter(4) }
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
  DataFlow::Node getAnAccess() {
    exists(CustomDirective d | this = d.getAScope() |
      exists(DataFlow::ParameterNode p |
        p = d.getController().getDependencyParameter("$scope") or
        p = d.getALinkFunction().getParameter(0)
      |
        p.flowsTo(result)
      )
      or
      exists(DataFlow::ThisNode dis |
        dis.flowsTo(result) and
        dis.getBinder() = d.getController().asFunction() and
        d.bindsToController()
      )
      or
      d.hasIsolateScope() and result = d.getMember("scope")
    )
    or
    exists(DirectiveController c, DOM::ElementDefinition elem, DataFlow::ParameterNode p |
      c.boundTo(elem) and
      this.mayApplyTo(elem) and
      p = c.getFactoryFunction().getDependencyParameter("$scope") and
      p.flowsTo(result)
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
  exists(string m | m = ["when", "otherwise"] | result = routeProviderRef().getAMethodCall(m))
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
    result.flowsTo(this.getOptionArgument(optionsArgumentIndex, name))
  }

  /**
   * Gets the "controller" value of this call, possibly resolving a service name.
   */
  InjectableFunction getController() {
    exists(DataFlow::SourceNode controllerProperty |
      // Note that `.getController` cannot be used here, since that involves a cast to InjectableFunction, and that cast only succeeds because of this method
      controllerProperty = this.getRouteParam("controller")
    |
      result = controllerProperty
      or
      exists(ControllerDefinition def | controllerProperty.mayHaveStringValue(def.getName()) |
        result = def.getAService()
      )
    )
  }

  override DataFlow::Node getAnInjectableFunction() { result = this.getRouteParam("controller") }
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
private class DirectiveController extends Controller instanceof ControllerDefinition {
  private predicate boundAnonymously(DOM::ElementDefinition elem) {
    exists(DirectiveInstance instance, DomAttributeAsElement attr |
      instance.getName() = "ngController" and
      instance.getATarget() = attr and
      elem = attr.getElement() and
      attr.asAttribute().getStringValue() = super.getName()
    )
  }

  override predicate boundTo(DOM::ElementDefinition elem) {
    this.boundAnonymously(elem) or this.boundToAs(elem, _)
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
        attributeValue.regexpCapture(pattern, 1) = ControllerDefinition.super.getName() and
        attributeValue.regexpCapture(pattern, 2) = alias
      )
    )
  }

  override InjectableFunction getFactoryFunction() {
    result = ControllerDefinition.super.getAFactoryFunction()
  }
}

/**
 * A controller instantiated through routes, e.g. `$routeProvider.otherwise({controller: ...})`.
 */
private class RouteInstantiatedController extends Controller instanceof RouteSetup {
  override InjectableFunction getFactoryFunction() { result = super.getController() }

  override predicate boundTo(DOM::ElementDefinition elem) {
    exists(string url, HTML::HtmlFile template |
      super.getRouteParam("templateUrl").mayHaveStringValue(url) and
      template.getAbsolutePath().regexpMatch(".*\\Q" + url + "\\E") and
      elem.getFile() = template
    )
  }

  override predicate boundToAs(DOM::ElementDefinition elem, string name) {
    this.boundTo(elem) and
    super.getRouteParam("controllerAs").mayHaveStringValue(name)
  }
}

/**
 * Dataflow for the arguments of AngularJS dependency-injected functions.
 */
private class DependencyInjectedArgumentInitializer extends DataFlow::AnalyzedNode instanceof DataFlow::ParameterNode
{
  DataFlow::AnalyzedNode service;

  DependencyInjectedArgumentInitializer() {
    exists(AngularJS::InjectableFunction f, AngularJS::CustomServiceDefinition def |
      def.getServiceReference() = f.getAResolvedDependency(this) and
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
    callback = this.getArgument(1) and
    argument = this.getArgument(index + 2)
  }

  override DataFlow::SourceNode getBoundFunction(DataFlow::Node callback, int boundArgs) {
    callback = this.getArgument(1) and
    boundArgs = this.getNumArgument() - 2 and
    result = this
  }

  override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    callback = this.getArgument(1) and
    result = this.getArgument(0)
  }
}
