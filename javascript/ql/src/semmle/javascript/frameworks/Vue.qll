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

  private newtype TInstance =
    MkVueInstance(DataFlow::NewNode def) { def = vue().getAnInstantiation() } or
    MkExtendedVue(VueExtend extend) or
    MkExtendedInstance(VueExtend extend, DataFlow::NewNode sub) {
      sub = extend.getAnInstantiation()
    } or
    MkComponent(DataFlow::CallNode def) { def = vue().getAMemberCall("component") } or
    MkSingleFileComponent(VueFile file)

  /** Gets the name of a lifecycle hook method. */
  private string lifecycleHookName() {
    result =
      [
        "beforeCreate", "created", "beforeMount", "mounted", "beforeUpdate", "updated", "activated",
        "deactivated", "beforeDestroy", "destroyed", "errorCaptured"
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
   * A Vue instance definition.
   *
   * This includes both explicit instantiations of Vue objects, and
   * implicit instantiations in the form of components or Vue
   * extensions that have not yet been instantiated to a Vue instance.
   *
   * The following instances are recognized:
   *   - `new Vue({...})`
   *   - `Vue.extend({...})`
   *   - `new ExtendedVue({...})`
   *   - `Vue.component("my-component", {...})`
   *   - single file components in .vue files
   */
  abstract class Instance extends TInstance {
    /** Gets a textual representation of this element. */
    abstract string toString();

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
    abstract DataFlow::Node getOwnOptionsObject();

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
     * Gets the template element used by this instance, if any.
     */
    abstract Template::Element getTemplateElement();

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
    DataFlow::Node getTemplate() { result = getOption("template") }

    /**
     * Gets the node for the `render` option of this instance.
     */
    DataFlow::Node getRender() {
      result = getOption("render")
      or
      result = getAsClassComponent().getInstanceMethod("render")
    }

    /**
     * Gets the node for the `methods` option of this instance.
     */
    DataFlow::Node getMethods() { result = getOption("methods") }

    /**
     * Gets the node for the `computed` option of this instance.
     */
    DataFlow::Node getComputed() { result = getOption("computed") }

    /**
     * Gets a node for a member of the `methods` option of this instance.
     */
    pragma[noinline]
    private DataFlow::Node getAMethod() {
      exists(DataFlow::ObjectLiteralNode methods |
        methods.flowsTo(getMethods()) and
        result = methods.getAPropertyWrite().getRhs()
      )
      or
      result = getAsClassComponent().getAnInstanceMethod() and
      not result = getAsClassComponent().getInstanceMethod([lifecycleHookName(), "render", "data"])
    }

    /**
     * Gets a node for a member of the `computed` option of this instance that matches `kind`.
     */
    pragma[noinline]
    private DataFlow::Node getAnAccessor(DataFlow::MemberKind kind) {
      exists(DataFlow::ObjectLiteralNode computedObj, DataFlow::Node accessorObjOrGetter |
        computedObj.flowsTo(getComputed()) and
        computedObj.getAPropertyWrite().getRhs() = accessorObjOrGetter
      |
        result = accessorObjOrGetter and kind = DataFlow::MemberKind::getter()
        or
        exists(DataFlow::ObjectLiteralNode accessorObj |
          accessorObj.flowsTo(accessorObjOrGetter) and
          result = accessorObj.getAPropertyWrite(memberKindVerb(kind)).getRhs()
        )
      )
      or
      result = getAsClassComponent().getAnInstanceMember(kind) and
      kind.isAccessor()
    }

    /**
     * Gets a node for a member `name` of the `computed` option of this instance that matches `kind`.
     */
    private DataFlow::Node getAccessor(string name, DataFlow::MemberKind kind) {
      exists(DataFlow::ObjectLiteralNode computedObj, DataFlow::SourceNode accessorObjOrGetter |
        computedObj.flowsTo(getComputed()) and
        accessorObjOrGetter.flowsTo(computedObj.getAPropertyWrite(name).getRhs())
      |
        result = accessorObjOrGetter and kind = DataFlow::MemberKind::getter()
        or
        exists(DataFlow::ObjectLiteralNode accessorObj |
          accessorObj.flowsTo(accessorObjOrGetter) and
          result = accessorObj.getAPropertyWrite(memberKindVerb(kind)).getRhs()
        )
      )
      or
      result = getAsClassComponent().getInstanceMember(name, kind) and
      kind.isAccessor()
    }

    /**
     * Gets the node for the life cycle hook of the `hookName` option of this instance.
     */
    pragma[noinline]
    private DataFlow::Node getALifecycleHook(string hookName) {
      hookName = lifecycleHookName() and
      (
        result = getOption(hookName)
        or
        result = getAsClassComponent().getInstanceMethod(hookName)
      )
    }

    /**
     * Gets a node for a function that will be invoked with `this` bound to this instance.
     */
    DataFlow::Node getABoundFunction() {
      result = getAMethod()
      or
      result = getAnAccessor(_)
      or
      result = getALifecycleHook(_)
    }

    /**
     * Gets a node for the value for property `name` of this instance.
     */
    DataFlow::Node getAPropertyValue(string name) {
      exists(DataFlow::SourceNode obj | obj.getAPropertyWrite(name).getRhs() = result |
        obj.flowsTo(getData())
        or
        exists(DataFlow::FunctionNode bound |
          bound.flowsTo(getABoundFunction()) and
          not bound.getFunction() instanceof ArrowFunctionExpr and
          obj = bound.getReceiver()
        )
      )
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
  class VueInstance extends Instance, MkVueInstance {
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
  class ExtendedVue extends Instance, MkExtendedVue {
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
  class ExtendedInstance extends Instance, MkExtendedInstance {
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
      result = Instance.super.getOption(name)
      or
      result = MkExtendedVue(extend).(ExtendedVue).getOption(name)
    }

    override Template::Element getTemplateElement() { none() }
  }

  /**
   * A Vue component from `Vue.component("my-component", { ... })`.
   */
  class Component extends Instance, MkComponent {
    DataFlow::CallNode def;

    Component() { this = MkComponent(def) }

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
  class SingleFileComponent extends Instance, MkSingleFileComponent {
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
  class InstanceHeapStep extends TaintTracking::AdditionalTaintStep {
    DataFlow::Node src;

    InstanceHeapStep() {
      exists(Instance i, string name, DataFlow::FunctionNode bound |
        bound.flowsTo(i.getABoundFunction()) and
        not bound.getFunction() instanceof ArrowFunctionExpr and
        bound.getReceiver().getAPropertyRead(name) = this and
        src = i.getAPropertyValue(name)
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
}
