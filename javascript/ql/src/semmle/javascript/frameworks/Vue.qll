/**
 * Provides classes for working with Vue code.
 */

import javascript

module Vue {
  /**
   * Gets a reference to the 'Vue' object.
   */
  DataFlow::SourceNode vue() {
    result = DataFlow::globalVarRef("Vue")
    or
    result = DataFlow::moduleImport("vue")
  }

  /**
   * A call to `vue.extend`.
   */
  private class VueExtend extends DataFlow::CallNode {
    VueExtend() { this = vue().getAMemberCall("extend") }
  }

  private newtype TComponent =
    MkVueInstance(DataFlow::NewNode def) { def = vue().getAnInstantiation() } or
    MkExtendedVue(VueExtend extend) or
    MkExtendedInstance(VueExtend extend, DataFlow::NewNode sub) {
      sub = extend.getAnInstantiation()
    } or
    MkComponentRegistration(DataFlow::CallNode def) { def = vue().getAMemberCall("component") } or
    MkSingleFileComponent(VueFile file)

  /** Gets the name of a lifecycle hook method. */
  private string lifecycleHookName() {
    result =
      [
        "beforeCreate", "created", "beforeMount", "mounted", "beforeUpdate", "updated", "activated",
        "deactivated", "beforeDestroy", "destroyed", "errorCaptured", "beforeRouteEnter",
        "beforeRouteUpdate", "beforeRouteLeave"
      ]
  }

  /** Gets a value that can be used as a `@Component` decorator. */
  private DataFlow::SourceNode componentDecorator() {
    result = DataFlow::moduleImport("vue-class-component")
    or
    result = DataFlow::moduleMember("vue-property-decorator", "Component")
  }

  /**
   * A class with a `@Component` decorator, making it usable as an "options" object in Vue.
   */
  private class ClassComponent extends DataFlow::ClassNode {
    DataFlow::Node decorator;

    ClassComponent() {
      exists(ClassDefinition cls |
        this = cls.flow() and
        cls.getADecorator().getExpression() = decorator.asExpr() and
        (
          componentDecorator().flowsTo(decorator)
          or
          componentDecorator().getACall() = decorator
        )
      )
    }

    /**
     * Gets an option passed to the `@Component` decorator.
     *
     * These options correspond to the options one would pass to `new Vue({...})` or similar.
     */
    DataFlow::Node getDecoratorOption(string name) {
      result = decorator.(DataFlow::CallNode).getOptionArgument(0, name)
    }
  }

  private string memberKindVerb(DataFlow::MemberKind kind) {
    kind = DataFlow::MemberKind::getter() and result = "get"
    or
    kind = DataFlow::MemberKind::setter() and result = "set"
  }

  /**
   * DEPRECATED. This class has been renamed to `Vue::Component`.
   */
  deprecated class Instance = Component;

  /**
   * A Vue component, such as a `new Vue({ ... })` call or a `.vue` file.
   *
   * Generally speaking, a component is always created by calling `Vue.extend()` or
   * calling `extend` on another component.
   * Often the `Vue.extend()` call is performed by the Vue
   * framework, however, so the call is not always visible in the user code.
   * For instance, `new Vue(obj)` is shorthand for `new (Vue.extend(obj))`.
   *
   * This class covers both the explicit `Vue.extend()` calls an those implicit in the framework.
   *
   * The following types of components are recognized:
   *   - `new Vue({...})`
   *   - `Vue.extend({...})`
   *   - `new ExtendedVue({...})`
   *   - `Vue.component("my-component", {...})`
   *   - single file components in .vue files
   */
  class Component extends TComponent {
    /** Gets a textual representation of this element. */
    string toString() { none() } // overridden in subclasses

    /**
     * Holds if this element is at the specified location.
     * The location spans column `startcolumn` of line `startline` to
     * column `endcolumn` of line `endline` in file `filepath`.
     * For more information, see
     * [locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
     */
    predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }

    /**
     * Gets the options passed to the Vue object, such as the object literal `{...}` in `new Vue{{...})`
     * or the default export of a single-file component.
     */
    DataFlow::Node getOwnOptionsObject() { none() } // overridden in subclasses

    /**
     * Gets the class component implementing this Vue instance, if any.
     *
     * Specifically, this is a class annotated with `@Component` which flows to the options
     * object of this Vue instance.
     */
    ClassComponent getAsClassComponent() { result.flowsTo(getOwnOptionsObject()) }

    /**
     * Gets the node for option `name` for this instance, this does not include
     * those from extended objects and mixins.
     */
    DataFlow::Node getOwnOption(string name) {
      result = getOwnOptionsObject().getALocalSource().getAPropertyWrite(name).getRhs()
    }

    /**
     * Gets the node for option `name` for this instance, including those from
     * extended objects and mixins.
     */
    DataFlow::Node getOption(string name) {
      result = getOwnOption(name)
      or
      exists(DataFlow::SourceNode extendsVal | extendsVal.flowsTo(getOwnOption("extends")) |
        result = extendsVal.(DataFlow::ObjectLiteralNode).getAPropertyWrite(name).getRhs()
        or
        exists(ExtendedVue extend |
          MkExtendedVue(extendsVal) = extend and
          result = extend.getOption(name)
        )
      )
      or
      exists(DataFlow::ArrayCreationNode mixins, DataFlow::ObjectLiteralNode mixin |
        mixins.flowsTo(getOwnOption("mixins")) and
        mixin.flowsTo(mixins.getAnElement()) and
        result = mixin.getAPropertyWrite(name).getRhs()
      )
      or
      result = getAsClassComponent().getDecoratorOption(name)
    }

    /**
     * Gets a source node flowing into the option `name` of this instance, including those from
     * extended objects and mixins.
     */
    pragma[nomagic]
    DataFlow::SourceNode getOptionSource(string name) { result = getOption(name).getALocalSource() }

    /**
     * Gets the template element used by this instance, if any.
     */
    Template::Element getTemplateElement() { none() } // overridden in subclasses

    /**
     * Gets the node for the `data` option object of this instance.
     */
    DataFlow::Node getData() {
      exists(DataFlow::Node data | data = getOption("data") |
        result = data
        or
        // a constructor variant is available for all instance definitions
        exists(DataFlow::FunctionNode f |
          f.flowsTo(data) and
          result = f.getAReturn()
        )
      )
      or
      result = getAsClassComponent().getAReceiverNode()
      or
      result = getAsClassComponent().getInstanceMethod("data").getAReturn()
    }

    /**
     * Gets the node for the `template` option of this instance.
     */
    pragma[nomagic]
    DataFlow::SourceNode getTemplate() { result = getOptionSource("template") }

    /**
     * Gets the node for the `render` option of this instance.
     */
    pragma[nomagic]
    DataFlow::SourceNode getRender() {
      result = getOptionSource("render")
      or
      result = getAsClassComponent().getInstanceMethod("render")
    }

    /**
     * Gets the node for the `methods` option of this instance.
     */
    pragma[nomagic]
    DataFlow::SourceNode getMethods() { result = getOptionSource("methods") }

    /**
     * Gets the node for the `computed` option of this instance.
     */
    pragma[nomagic]
    DataFlow::SourceNode getComputed() { result = getOptionSource("computed") }

    /**
     * Gets the node for the `watch` option of this instance.
     */
    pragma[nomagic]
    DataFlow::SourceNode getWatch() { result = getOptionSource("watch") }

    /**
     * Gets the function responding to changes to the given `propName`.
     */
    DataFlow::FunctionNode getWatchHandler(string propName) {
      exists(DataFlow::SourceNode watcher | watcher = getWatch().getAPropertySource(propName) |
        result = watcher
        or
        result = watcher.getAPropertySource("handler")
      )
    }

    /**
     * Gets a node for a member of the `methods` option of this instance.
     */
    pragma[nomagic]
    private DataFlow::SourceNode getAMethod() {
      result = getMethods().getAPropertySource()
      or
      result = getAsClassComponent().getAnInstanceMethod() and
      not result = getAsClassComponent().getInstanceMethod([lifecycleHookName(), "render", "data"])
    }

    /**
     * Gets a node for a member of the `computed` option of this instance that matches `kind`.
     */
    pragma[nomagic]
    private DataFlow::SourceNode getAnAccessor(DataFlow::MemberKind kind) {
      result = getComputed().getAPropertySource() and kind = DataFlow::MemberKind::getter()
      or
      result = getComputed().getAPropertySource().getAPropertySource(memberKindVerb(kind))
      or
      result = getAsClassComponent().getAnInstanceMember(kind) and
      kind.isAccessor()
    }

    /**
     * Gets a node for a member `name` of the `computed` option of this instance that matches `kind`.
     */
    private DataFlow::SourceNode getAccessor(string name, DataFlow::MemberKind kind) {
      result = getComputed().getAPropertySource(name) and kind = DataFlow::MemberKind::getter()
      or
      result = getComputed().getAPropertySource(name).getAPropertySource(memberKindVerb(kind))
      or
      result = getAsClassComponent().getInstanceMember(name, kind) and
      kind.isAccessor()
    }

    /**
     * Gets the node for the life cycle hook of the `hookName` option of this instance.
     */
    pragma[nomagic]
    DataFlow::SourceNode getALifecycleHook(string hookName) {
      hookName = lifecycleHookName() and
      (
        result = getOptionSource(hookName)
        or
        result = getAsClassComponent().getInstanceMethod(hookName)
      )
    }

    /**
     * Gets a node for a function that will be invoked with `this` bound to this instance.
     */
    DataFlow::FunctionNode getABoundFunction() {
      result = getAMethod()
      or
      result = getAnAccessor(_)
      or
      result = getALifecycleHook(_)
      or
      result = getOptionSource(_)
      or
      result = getOptionSource(_).getAPropertySource()
    }

    pragma[noinline]
    private DataFlow::PropWrite getAPropertyValueWrite(string name) {
      result = getData().getALocalSource().getAPropertyWrite(name)
      or
      result =
        getABoundFunction()
            .getALocalSource()
            .(DataFlow::FunctionNode)
            .getReceiver()
            .getAPropertyWrite(name)
    }

    /**
     * Gets the data flow node that flows into the property `name` of this instance, or is
     * returned form a getter defining that property.
     */
    DataFlow::Node getAPropertyValue(string name) {
      result = getAPropertyValueWrite(name).getRhs()
      or
      exists(DataFlow::FunctionNode getter |
        getter.flowsTo(getAccessor(name, DataFlow::MemberKind::getter())) and
        result = getter.getAReturn()
      )
    }
  }

  /**
   * A Vue instance from `new Vue({...})`.
   */
  class VueInstance extends Component, MkVueInstance {
    DataFlow::NewNode def;

    VueInstance() { this = MkVueInstance(def) }

    override string toString() { result = def.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      def.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override DataFlow::Node getOwnOptionsObject() { result = def.getArgument(0) }

    override Template::Element getTemplateElement() { none() }
  }

  /**
   * An extended Vue from `Vue.extend({...})`.
   */
  class ExtendedVue extends Component, MkExtendedVue {
    VueExtend extend;

    ExtendedVue() { this = MkExtendedVue(extend) }

    override string toString() { result = extend.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      extend.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override DataFlow::Node getOwnOptionsObject() { result = extend.getArgument(0) }

    override Template::Element getTemplateElement() { none() }
  }

  /**
   * An instance of an extended Vue, for example `instance` of `var Ext = Vue.extend({...}); var instance = new Ext({...})`.
   */
  class ExtendedInstance extends Component, MkExtendedInstance {
    VueExtend extend;
    DataFlow::NewNode sub;

    ExtendedInstance() { this = MkExtendedInstance(extend, sub) }

    override string toString() { result = sub.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      sub.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override DataFlow::Node getOwnOptionsObject() { result = sub.getArgument(0) }

    override DataFlow::Node getOption(string name) {
      result = Component.super.getOption(name)
      or
      result = MkExtendedVue(extend).(ExtendedVue).getOption(name)
    }

    override Template::Element getTemplateElement() { none() }
  }

  /**
   * A Vue component from `Vue.component("my-component", { ... })`.
   */
  class ComponentRegistration extends Component, MkComponentRegistration {
    DataFlow::CallNode def;

    ComponentRegistration() { this = MkComponentRegistration(def) }

    override string toString() { result = def.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      def.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override DataFlow::Node getOwnOptionsObject() { result = def.getArgument(1) }

    override Template::Element getTemplateElement() { none() }
  }

  /**
   * A single file Vue component in a `.vue` file.
   */
  class SingleFileComponent extends Component, MkSingleFileComponent {
    VueFile file;

    SingleFileComponent() { this = MkSingleFileComponent(file) }

    override Template::Element getTemplateElement() {
      exists(HTML::Element e | result.(Template::HtmlElement).getElement() = e |
        e.getFile() = file and
        e.getName() = "template" and
        e.isTopLevel()
      )
    }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      filepath = file.getAbsolutePath() and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    }

    private Module getModule() {
      exists(HTML::ScriptElement elem |
        xmlElements(elem, _, _, _, file) and // Avoid materializing all of Locatable.getFile()
        result.getTopLevel() = elem.getScript()
      )
    }

    override DataFlow::Node getOwnOptionsObject() {
      exists(ExportDefaultDeclaration decl |
        decl.getTopLevel() = getModule() and
        result = DataFlow::valueNode(decl.getOperand())
      )
    }

    override DataFlow::Node getOwnOption(string name) {
      // The options of a single file component are defined by the exported object of the script element.
      // Our current module model does not support reads on this object very well, so we use custom steps for the common cases for now.
      exists(Module m, DefiniteAbstractValue abstractOptions |
        any(AnalyzedPropertyWrite write).writes(abstractOptions, name, result) and
        m = getModule()
      |
        // ES2015 exports
        exists(ExportDeclaration export, DataFlow::AnalyzedNode exported |
          export.getEnclosingModule() = m and
          abstractOptions = exported.getAValue()
        |
          exported = export.(BulkReExportDeclaration).getSourceNode("default") or
          exported.asExpr() = export.(ExportDefaultDeclaration).getOperand()
        )
        or
        // Node.js exports
        abstractOptions = m.(NodeModule).getAModuleExportsValue()
      )
    }

    override string toString() { result = file.toString() }
  }

  /**
   * A `.vue` file.
   */
  class VueFile extends File {
    VueFile() { getExtension() = "vue" }
  }

  /**
   * A taint propagating data flow edge through a Vue instance property.
   */
  class InstanceHeapStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Component i, string name, DataFlow::FunctionNode bound |
        bound.flowsTo(i.getABoundFunction()) and
        not bound.getFunction() instanceof ArrowFunctionExpr and
        succ = bound.getReceiver().getAPropertyRead(name) and
        pred = i.getAPropertyValue(name)
      )
    }
  }

  /**
   * A Vue `v-html` attribute.
   */
  class VHtmlAttribute extends DataFlow::Node {
    HTML::Attribute attr;

    VHtmlAttribute() {
      this.(DataFlow::HtmlAttributeNode).getAttribute() = attr and attr.getName() = "v-html"
    }

    /**
     * Gets the HTML attribute of this sink.
     */
    HTML::Attribute getAttr() { result = attr }
  }

  /**
   * A taint propagating data flow edge through a string interpolation of a
   * Vue instance property to a `v-html` attribute.
   *
   * As an example, `<div v-html="prop"/>` reads the `prop` property
   * of `inst = new Vue({ ..., data: { prop: source } })`, if the
   * `div` element is part of the template for `inst`.
   */
  class VHtmlSourceWrite extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Vue::Component component, string expr, VHtmlAttribute attr |
        attr.getAttr().getRoot() =
          component.getTemplateElement().(Vue::Template::HtmlElement).getElement() and
        expr = attr.getAttr().getValue() and
        // only support for simple identifier expressions
        expr.regexpMatch("(?i)[a-z0-9_]+") and
        pred = component.getAPropertyValue(expr) and
        succ = attr
      )
    }
  }

  /*
   * Provides classes for working with Vue templates.
   */

  module Template {
    // Currently only supports HTML elements, but it may be possible to parse simple string templates later
    private newtype TElement = MkHtmlElement(HTML::Element e) { e.getFile() instanceof VueFile }

    /**
     * An element of a template.
     */
    abstract class Element extends TElement {
      /** Gets a textual representation of this element. */
      string toString() { result = "<" + getName() + ">...</>" }

      /**
       * Holds if this element is at the specified location.
       * The location spans column `startcolumn` of line `startline` to
       * column `endcolumn` of line `endline` in file `filepath`.
       * For more information, see
       * [locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
       */
      predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        filepath = "" and
        startline = 0 and
        startcolumn = 0 and
        endline = 0 and
        endcolumn = 0
      }

      /**
       * Gets the name of this element.
       *
       * For example, the name of `<br>` is `br`.
       */
      abstract string getName();
    }

    /**
     * An HTML element as a template element.
     */
    class HtmlElement extends Element, MkHtmlElement {
      HTML::Element elem;

      HtmlElement() { this = MkHtmlElement(elem) }

      override predicate hasLocationInfo(
        string filepath, int startline, int startcolumn, int endline, int endcolumn
      ) {
        elem.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
      }

      override string getName() { result = elem.getName() }

      /**
       * Gets the HTML element of this element.
       */
      HTML::Element getElement() { result = elem }
    }
  }

  /** An API node referring to a `RouteConfig` being passed to `vue-router`. */
  private API::Node routeConfig() {
    result = API::moduleImport("vue-router").getParameter(0).getMember("routes").getAMember()
    or
    result = routeConfig().getMember("children").getAMember()
  }

  /** Gets a data flow node that refers to a `Route` object from `vue-router`. */
  private DataFlow::SourceNode routeObject(DataFlow::TypeTracker t) {
    t.start() and
    (
      exists(API::Node router | router = API::moduleImport("vue-router") |
        result = router.getInstance().getMember("currentRoute").getAnImmediateUse()
        or
        result =
          router
              .getInstance()
              .getMember(["beforeEach", "beforeResolve", "afterEach"])
              .getParameter(0)
              .getParameter([0, 1])
              .getAnImmediateUse()
        or
        result =
          router
              .getParameter(0)
              .getMember("scrollBehavior")
              .getParameter([0, 1])
              .getAnImmediateUse()
      )
      or
      result = routeConfig().getMember("beforeEnter").getParameter([0, 1]).getAnImmediateUse()
      or
      exists(Component c |
        result = c.getABoundFunction().getAFunctionValue().getReceiver().getAPropertyRead("$route")
        or
        result =
          c.getALifecycleHook(["beforeRouteEnter", "beforeRouteUpdate", "beforeRouteLeave"])
              .getAFunctionValue()
              .getParameter([0, 1])
        or
        result = c.getWatchHandler("$route").getParameter([0, 1])
      )
    )
    or
    exists(DataFlow::TypeTracker t2 | result = routeObject(t2).track(t2, t))
  }

  /** Gets a data flow node that refers to a `Route` object from `vue-router`. */
  DataFlow::SourceNode routeObject() { result = routeObject(DataFlow::TypeTracker::end()) }

  private class VueRouterFlowSource extends ClientSideRemoteFlowSource {
    ClientSideRemoteFlowKind kind;

    VueRouterFlowSource() {
      exists(string name |
        this = routeObject().getAPropertyRead(name)
        or
        exists(string prop |
          this = any(Component c).getWatchHandler(prop).getParameter([0, 1]) and
          name = prop.regexpCapture("\\$route\\.(params|query|hash|path|fullPath)\\b.*", 1)
        )
      |
        name = ["params", "path", "fullPath"] and kind.isPath()
        or
        name = "query" and kind.isQuery()
        or
        name = "hash" and kind.isFragment()
      )
    }

    override string getSourceType() { result = "Vue route parameter" }

    override ClientSideRemoteFlowKind getKind() { result = kind }
  }
}
