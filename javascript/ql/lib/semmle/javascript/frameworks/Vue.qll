/**
 * Provides classes for working with Vue code.
 */

import javascript
import semmle.javascript.ViewComponentInput

module Vue {
  /** The global variable `Vue`, as an API graph entry point. */
  private class GlobalVueEntryPoint extends API::EntryPoint {
    GlobalVueEntryPoint() { this = "VueEntryPoint" }

    override DataFlow::SourceNode getASource() { result = DataFlow::globalVarRef("Vue") }
  }

  /**
   * A value exported from a `.vue` file.
   *
   * This `EntryPoint` is used by `SingleFileComponent::getOwnOptions()`.
   */
  private class VueExportEntryPoint extends API::EntryPoint {
    VueExportEntryPoint() { this = "VueExportEntryPoint" }

    override DataFlow::Node getASink() { result = getModuleFromVueFile(_).getDefaultOrBulkExport() }
  }

  /**
   * Gets a reference to the `Vue` object.
   */
  API::Node vueLibrary() {
    result = API::moduleImport("vue")
    or
    result = any(GlobalVueEntryPoint e).getANode()
  }

  /**
   * Gets a reference to the 'Vue' object.
   */
  DataFlow::SourceNode vue() { result = vueLibrary().asSource() }

  /** Gets an API node referring to a component or `Vue`. */
  private API::Node component() {
    result = vueLibrary()
    or
    result = component().getMember("extend").getReturn()
    or
    result = vueLibrary().getMember("component").getReturn()
    or
    result = any(VueFileImportEntryPoint e).getANode()
  }

  /**
   * A call to `Vue.extend` or `extend` on a component.
   */
  private class VueExtendCall extends API::CallNode {
    VueExtendCall() { this = component().getMember("extend").getACall() }
  }

  /** A component created by an explicit or implicit call to `Vue.extend`. */
  private newtype TComponent =
    MkComponentExtension(VueExtendCall extend) or
    MkComponentInstantiation(API::NewNode sub) { sub = component().getAnInstantiation() } or
    MkComponentRegistration(API::CallNode def) {
      def = vueLibrary().getMember("component").getACall()
    } or
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
  class ClassComponent extends DataFlow::ClassNode {
    private ClassDefinition cls;
    DataFlow::Node decorator;

    ClassComponent() {
      this = cls.flow() and
      cls.getADecorator().getExpression() = decorator.asExpr() and
      (
        componentDecorator().flowsTo(decorator)
        or
        componentDecorator().getACall() = decorator
      )
    }

    /**
     * Gets the options object passed to the `@Component` decorator, if any.
     *
     * These options correspond to the options one would pass to `new Vue({...})` or similar.
     */
    API::Node getDecoratorOptions() { result = decorator.(API::CallNode).getParameter(0) }

    /** Gets the AST node for the class definition. */
    ClassDefinition getClassDefinition() { result = cls }
  }

  private string memberKindVerb(DataFlow::MemberKind kind) {
    kind = DataFlow::MemberKind::getter() and result = "get"
    or
    kind = DataFlow::MemberKind::setter() and result = "set"
  }

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
     * [locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
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
     * Gets an API node referring to the component itself.
     */
    API::Node getComponentRef() { none() } // overridden in subclass

    /**
     * Gets an API node referring to the options passed to the Vue object,
     * such as the object literal `{...}` in `new Vue{{...})` or the default export of a single-file component.
     */
    API::Node getOwnOptions() { none() } // overridden in subclass

    /** Gets a component which is extended by this one. */
    Component getABaseComponent() {
      result.getComponentRef().getAValueReachableFromSource() =
        this.getOwnOptions().getMember(["extends", "mixins"]).asSink()
    }

    /**
     * Gets an API node referring to the options passed to the Vue object or one
     * of its base component.
     */
    API::Node getOptions() {
      result = this.getOwnOptions()
      or
      result = this.getOwnOptions().getMember(["extends", "mixins"]).getAMember()
      or
      result = this.getABaseComponent().getOptions()
      or
      result = this.getAsClassComponent().getDecoratorOptions()
    }

    /**
     * Gets the class implementing this Vue component, if any.
     *
     * Specifically, this is a class annotated with `@Component` which flows to the options
     * object of this Vue component.
     */
    ClassComponent getAsClassComponent() { result = this.getOwnOptions().getAValueReachingSink() }

    /**
     * Gets the node for option `name` for this component, not including
     * those from extended objects and mixins.
     */
    DataFlow::Node getOwnOption(string name) {
      result = this.getOwnOptions().getMember(name).asSink()
    }

    /**
     * Gets the node for option `name` for this component, including those from
     * extended objects and mixins.
     */
    DataFlow::Node getOption(string name) { result = this.getOptions().getMember(name).asSink() }

    /**
     * Gets a source node flowing into the option `name` of this component, including those from
     * extended objects and mixins.
     */
    pragma[nomagic]
    DataFlow::SourceNode getOptionSource(string name) {
      result = this.getOptions().getMember(name).getAValueReachingSink()
    }

    /**
     * Gets the template element used by this component, if any.
     */
    Template::Element getTemplateElement() { none() } // overridden in subclasses

    /**
     * Gets the node for the `data` option object of this component.
     */
    DataFlow::Node getData() {
      result = this.getOption("data")
      or
      result = this.getOptionSource("data").(DataFlow::FunctionNode).getReturnNode()
      or
      result = this.getAsClassComponent().getAReceiverNode()
      or
      result = this.getAsClassComponent().getInstanceMethod("data").getAReturn()
    }

    /**
     * Gets the node for the `template` option of this component.
     */
    pragma[nomagic]
    DataFlow::SourceNode getTemplate() { result = this.getOptionSource("template") }

    /**
     * Gets the node for the `render` option of this component.
     */
    pragma[nomagic]
    DataFlow::SourceNode getRender() {
      result = this.getOptionSource("render")
      or
      result = this.getAsClassComponent().getInstanceMethod("render")
    }

    /**
     * Gets the node for the `methods` option of this component.
     */
    pragma[nomagic]
    DataFlow::SourceNode getMethods() { result = this.getOptionSource("methods") }

    /**
     * Gets the node for the `computed` option of this component.
     */
    pragma[nomagic]
    DataFlow::SourceNode getComputed() { result = this.getOptionSource("computed") }

    /**
     * Gets the node for the `watch` option of this component.
     */
    pragma[nomagic]
    DataFlow::SourceNode getWatch() { result = this.getOptionSource("watch") }

    /**
     * Gets the function responding to changes to the given `propName`.
     */
    DataFlow::FunctionNode getWatchHandler(string propName) {
      exists(API::Node propWatch |
        propWatch = this.getOptions().getMember("watch").getMember(propName) and
        result = [propWatch, propWatch.getMember("handler")].getAValueReachingSink()
      )
    }

    /**
     * Gets a node for a member `name` of the `computed` option of this component that matches `kind`.
     */
    private DataFlow::SourceNode getAccessor(string name, DataFlow::MemberKind kind) {
      result = this.getComputed().getAPropertySource(name) and kind = DataFlow::MemberKind::getter()
      or
      result = this.getComputed().getAPropertySource(name).getAPropertySource(memberKindVerb(kind))
      or
      result = this.getAsClassComponent().getInstanceMember(name, kind) and
      kind.isAccessor()
    }

    /**
     * Gets the node for the life cycle hook of the `hookName` option of this component.
     */
    pragma[nomagic]
    DataFlow::SourceNode getALifecycleHook(string hookName) {
      hookName = lifecycleHookName() and
      (
        result = this.getOptionSource(hookName)
        or
        result = this.getAsClassComponent().getInstanceMethod(hookName)
      )
    }

    /**
     * Gets a node for a function that will be invoked with `this` bound to this component.
     */
    DataFlow::FunctionNode getABoundFunction() {
      result = this.getOptions().getAMember+().getAValueReachingSink()
      or
      result = this.getAsClassComponent().getAnInstanceMember()
    }

    /** Gets an API node referring to an instance of this component. */
    API::Node getInstance() { result.asSource() = this.getABoundFunction().getReceiver() }

    /** Gets a data flow node referring to an instance of this component. */
    DataFlow::SourceNode getAnInstanceRef() { result = this.getInstance().asSource() }

    pragma[noinline]
    private DataFlow::PropWrite getAPropertyValueWrite(string name) {
      result = this.getData().getALocalSource().getAPropertyWrite(name)
      or
      result = this.getAnInstanceRef().getAPropertyWrite(name)
    }

    /**
     * Gets the data flow node that flows into the property `name` of this component, or is
     * returned form a getter defining that property.
     */
    DataFlow::Node getAPropertyValue(string name) {
      result = this.getAPropertyValueWrite(name).getRhs()
      or
      exists(DataFlow::FunctionNode getter |
        getter.flowsTo(this.getAccessor(name, DataFlow::MemberKind::getter())) and
        result = getter.getAReturn()
      )
    }
  }

  /**
   * A Vue component created implicitly at an invocation of form `new Vue({...})` or `new CustomComponent({...})`.
   */
  private class ComponentInstantiation extends Component, MkComponentInstantiation {
    API::NewNode def;

    ComponentInstantiation() { this = MkComponentInstantiation(def) }

    override string toString() { result = def.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      def.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override API::Node getComponentRef() {
      // The Vue.extend call is made in the Vue framework; there is no explicit reference
      // to the component in user code.
      none()
    }

    override API::Node getOwnOptions() { result = def.getParameter(0) }

    override Template::Element getTemplateElement() { none() }

    override Component getABaseComponent() {
      result = Component.super.getABaseComponent()
      or
      result.getComponentRef().getAnInstantiation() = def
    }
  }

  /**
   * A component created via an explicit call to `Vue.extend({...})` or `CustomComponent.extend({...})`.
   */
  class ComponentExtension extends Component, MkComponentExtension {
    VueExtendCall extend;

    ComponentExtension() { this = MkComponentExtension(extend) }

    override string toString() { result = extend.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      extend.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override API::Node getComponentRef() { result = extend.getReturn() }

    override API::Node getOwnOptions() { result = extend.getParameter(0) }

    override Template::Element getTemplateElement() { none() }

    override Component getABaseComponent() {
      result = Component.super.getABaseComponent()
      or
      result.getComponentRef().getMember("extend").getACall() = extend
    }
  }

  /**
   * A Vue component from `Vue.component("my-component", { ... })`.
   */
  class ComponentRegistration extends Component, MkComponentRegistration {
    API::CallNode def;

    ComponentRegistration() { this = MkComponentRegistration(def) }

    override string toString() { result = def.toString() }

    override predicate hasLocationInfo(
      string filepath, int startline, int startcolumn, int endline, int endcolumn
    ) {
      def.hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    }

    override API::Node getComponentRef() {
      // The component can be obtained via 1-argument calls to `Vue.component()` with the
      // same name, but we don't model this at the moment.
      none()
    }

    override API::Node getOwnOptions() { result = def.getParameter(1) }

    override Template::Element getTemplateElement() { none() }
  }

  /**
   * An import referring to a `.vue` file, seen as an API entry point.
   *
   * Concretely, such an import receives the Vue component generated from the .vue file,
   * not the actual exports of the script tag in the file.
   *
   * This entry point is used in `SingleFileComponent::getComponentRef()`.
   */
  private class VueFileImportEntryPoint extends API::EntryPoint {
    VueFileImportEntryPoint() { this = "VueFileImportEntryPoint" }

    override DataFlow::SourceNode getASource() {
      exists(Import imprt |
        imprt.getImportedPath().resolve() instanceof VueFile and
        result = imprt.getImportedModuleNode()
      )
    }
  }

  private Module getModuleFromVueFile(VueFile file) {
    exists(HTML::ScriptElement elem |
      xmlElements(elem, _, _, _, file) and // Avoid materializing all of Locatable.getFile()
      result.getTopLevel() = elem.getScript()
    )
  }

  /**
   * A single file Vue component in a `.vue` file.
   */
  class SingleFileComponent extends Component, MkSingleFileComponent {
    VueFile file;

    SingleFileComponent() { this = MkSingleFileComponent(file) }

    /** Gets a call to `defineProps` in this component. */
    DataFlow::CallNode getDefinePropsCall() {
      result = DataFlow::globalVarRef("defineProps").getACall() and
      result.getFile() = file
    }

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

    /** Gets the module defined by the `script` tag in this .vue file, if any. */
    Module getModule() { result = getModuleFromVueFile(file) }

    override API::Node getComponentRef() {
      // There is no explicit `new Vue()` call in .vue files, so instead get all the imports
      // of the .vue file.
      exists(Import imprt |
        imprt.getImportedPath().resolve() = file and
        result.asSource() = imprt.getImportedModuleNode()
      )
    }

    override API::Node getOwnOptions() {
      // Use the entry point generated by `VueExportEntryPoint`
      result.asSink() = this.getModule().getDefaultOrBulkExport()
    }

    override string toString() { result = file.toString() }
  }

  /**
   * A `.vue` file.
   */
  class VueFile extends File {
    VueFile() { this.getExtension() = "vue" }
  }

  pragma[nomagic]
  private DataFlow::Node propStepPred(Component comp, string name) {
    result = comp.getAPropertyValue(name)
  }

  pragma[nomagic]
  private DataFlow::Node propStepSucc(Component comp, string name) {
    result = comp.getAnInstanceRef().getAPropertyRead(name)
  }

  /**
   * A taint propagating data flow edge through a Vue instance property.
   */
  private class PropStep extends TaintTracking::SharedTaintStep {
    override predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Component comp, string name |
        pred = propStepPred(comp, name) and
        succ = propStepSucc(comp, name)
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
  private class VHtmlAttributeStep extends TaintTracking::SharedTaintStep {
    override predicate viewComponentStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(Component component, string expr, VHtmlAttribute attr |
        attr.getAttr().getRoot() =
          component.getTemplateElement().(Template::HtmlElement).getElement() and
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
      string toString() { result = "<" + this.getName() + ">...</>" }

      /**
       * Holds if this element is at the specified location.
       * The location spans column `startcolumn` of line `startline` to
       * column `endcolumn` of line `endline` in file `filepath`.
       * For more information, see
       * [locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
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

  /** Gets an API node referring to a `RouteConfig` being passed to `vue-router`. */
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
        result = router.getInstance().getMember("currentRoute").asSource()
        or
        result =
          router
              .getInstance()
              .getMember(["beforeEach", "beforeResolve", "afterEach"])
              .getParameter(0)
              .getParameter([0, 1])
              .asSource()
        or
        result = router.getParameter(0).getMember("scrollBehavior").getParameter([0, 1]).asSource()
      )
      or
      result = routeConfig().getMember("beforeEnter").getParameter([0, 1]).asSource()
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

  /**
   * Holds if the given type annotation indicates a value that is not typically considered taintable.
   */
  private predicate isSafeType(TypeAnnotation type) {
    type.isBooleany() or
    type.isNumbery() or
    type.isRawFunction() or
    type instanceof FunctionTypeExpr
  }

  /**
   * Holds if the given field has a type that indicates that is can not contain a taintable value.
   */
  private predicate isSafeField(FieldDeclaration field) { isSafeType(field.getTypeAnnotation()) }

  private DataFlow::Node getPropSpec(Component component) {
    result = component.getOption("props")
    or
    result = component.(SingleFileComponent).getDefinePropsCall().getArgument(0)
  }

  /**
   * Holds if `component` has an input prop with the given name, that is of a taintable type.
   */
  private predicate hasTaintableProp(Component component, string name) {
    exists(DataFlow::SourceNode spec | spec = getPropSpec(component).getALocalSource() |
      spec.(DataFlow::ArrayCreationNode).getAnElement().getStringValue() = name
      or
      exists(DataFlow::PropWrite write |
        write = spec.getAPropertyWrite(name) and
        not DataFlow::globalVarRef(["Number", "Boolean"]).flowsTo(write.getRhs())
      )
    )
    or
    exists(FieldDeclaration field |
      field = component.getAsClassComponent().getClassDefinition().getField(name) and
      DataFlow::moduleMember("vue-property-decorator", "Prop")
          .getACall()
          .flowsToExpr(field.getADecorator().getExpression()) and
      not isSafeField(field)
    )
    or
    // defineProps() can be called with only type arguments and then the Vue compiler will
    // infer the prop types.
    exists(CallExpr call, FieldDeclaration field |
      call = component.(SingleFileComponent).getDefinePropsCall().asExpr() and
      field = call.getTypeArgument(0).(InterfaceTypeExpr).getMember(name) and
      not isSafeField(field)
    )
  }

  private class PropAsViewComponentInput extends ViewComponentInput {
    PropAsViewComponentInput() {
      exists(Component component, string name | hasTaintableProp(component, name) |
        this = component.getAnInstanceRef().getAPropertyRead(name)
        or
        // defineProps() returns the props
        this = component.(SingleFileComponent).getDefinePropsCall().getAPropertyRead(name)
      )
    }

    override string getSourceType() { result = "Vue prop" }
  }
}
