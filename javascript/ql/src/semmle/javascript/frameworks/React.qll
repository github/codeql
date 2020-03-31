/**
 * Provides classes for working with React and Preact code.
 */

import javascript

/**
 * Gets a reference to the 'React' object.
 */
DataFlow::SourceNode react() {
  result = DataFlow::globalVarRef("React")
  or
  result = DataFlow::moduleImport("react")
}

/**
 * An object that implements the React component interface.
 *
 * Instantiations include:
 * - instances of `Component` from `react`, `preact` and `preact-compat`
 * - instances from `React.createClass`
 * - stateless functional components
 */
abstract class ReactComponent extends ASTNode {
  /**
   * Gets an instance method of this component with the given name.
   */
  abstract Function getInstanceMethod(string name);

  /**
   * Gets a static method of this component with the given name.
   */
  abstract Function getStaticMethod(string name);

  /**
   * Gets the abstract value that represents this component.
   */
  abstract AbstractValue getAbstractComponent();

  /**
   * Gets the function that instantiates this component when invoked.
   */
  abstract DataFlow::SourceNode getComponentCreatorSource();

  /**
   * Gets a reference to the function that instantiates this component when invoked.
   */
  abstract DataFlow::SourceNode getAComponentCreatorReference();

  /**
   * Gets a reference to this component.
   */
  DataFlow::Node ref() { result.analyze().getAValue() = getAbstractComponent() }

  /**
   * Gets the `this` node in an instance method of this component.
   */
  DataFlow::SourceNode getAThisNode() {
    result.(DataFlow::ThisNode).getBinder().getFunction() = getInstanceMethod(_)
  }

  /**
   * Gets an access to the `props` object of this component.
   */
  abstract DataFlow::SourceNode getADirectPropsAccess();

  /**
   * Gets an access to the `state` object of this component.
   */
  DataFlow::SourceNode getADirectStateAccess() {
    result.(DataFlow::PropRef).accesses(ref(), "state")
  }

  /**
   * Gets a data flow node that reads a prop of this component.
   */
  DataFlow::PropRead getAPropRead() { getADirectPropsAccess().flowsTo(result.getBase()) }

  /**
   * Gets a data flow node that reads prop `name` of this component.
   */
  DataFlow::PropRead getAPropRead(string name) {
    result = getAPropRead() and
    result.getPropertyName() = name
  }

  /**
   * Gets an expression that accesses a (transitive) property
   * of the state object of this component.
   */
  DataFlow::SourceNode getAStateAccess() {
    result = getADirectStateAccess()
    or
    exists(DataFlow::PropRef prn | result = prn | getAStateAccess().flowsTo(prn.getBase()))
  }

  /**
   * Holds if this component specifies default values for (some of) its
   * props.
   */
  predicate hasDefaultProps() { exists(getADefaultPropsSource()) }

  /**
   * Gets the object that specifies default values for (some of) this
   * components' props.
   */
  abstract DataFlow::SourceNode getADefaultPropsSource();

  /**
   * Gets the render method of this component.
   */
  Function getRenderMethod() { result = getInstanceMethod("render") }

  /**
   * Gets a call to method `name` on this component.
   */
  DataFlow::MethodCallNode getAMethodCall(string name) { result.calls(ref(), name) }

  /**
   * Gets a value that will become (part of) the state
   * object of this component, for example an assignment to `this.state`.
   */
  DataFlow::SourceNode getACandidateStateSource() {
    exists(DataFlow::PropWrite pwn, DataFlow::Node rhs |
      // a direct definition: `this.state = o`
      result.flowsTo(rhs) and
      pwn.writes(ref(), "state", rhs)
    )
    or
    exists(DataFlow::MethodCallNode mce, DataFlow::SourceNode arg0 |
      mce = getAMethodCall("setState") or
      mce = getAMethodCall("forceUpdate")
    |
      arg0.flowsTo(mce.getArgument(0)) and
      if arg0 instanceof DataFlow::FunctionNode
      then
        // setState with callback: `this.setState(() => {foo: 42})`
        result.flowsTo(arg0.(DataFlow::FunctionNode).getAReturn())
      else
        // setState with object: `this.setState({foo: 42})`
        result = arg0
    )
    or
    exists(string staticMember |
      staticMember = "getDerivedStateFromProps" or
      staticMember = "getDerivedStateFromError"
    |
      result.flowsToExpr(getStaticMethod(staticMember).getAReturnedExpr())
    )
    or
    // shouldComponentUpdate: (nextProps, nextState)
    result = DataFlow::parameterNode(getInstanceMethod("shouldComponentUpdate").getParameter(1))
  }

  /**
   * Gets a value that used to be the state object of this
   * component, for example the `prevState` parameter of the
   * `comoponentDidUpdate` method of this component.
   */
  DataFlow::SourceNode getAPreviousStateSource() {
    exists(DataFlow::FunctionNode callback, int stateParameterIndex |
      // "prevState" object as callback argument
      callback.getParameter(stateParameterIndex).flowsTo(result)
    |
      // setState: (prevState, props)
      callback = getAMethodCall("setState").getCallback(0) and
      stateParameterIndex = 0
      or
      stateParameterIndex = 1 and
      (
        // componentDidUpdate: (prevProps, prevState)
        callback = getInstanceMethod("componentDidUpdate").flow()
        or
        // getDerivedStateFromProps: (props, state)
        callback = getStaticMethod("getDerivedStateFromProps").flow()
        or
        // getSnapshotBeforeUpdate: (prevProps, prevState)
        callback = getInstanceMethod("getSnapshotBeforeUpdate").flow()
      )
    )
  }

  /**
   * Gets a value that will become (part of) the props
   * object of this component, for example the argument to the
   * constructor of this component.
   */
  DataFlow::SourceNode getACandidatePropsSource() {
    result.flowsTo(getAComponentCreatorReference().getAnInvocation().getArgument(0))
    or
    result = getADefaultPropsSource()
    or
    // shouldComponentUpdate: (nextProps, nextState)
    result = DataFlow::parameterNode(getInstanceMethod("shouldComponentUpdate").getParameter(0))
  }

  /**
   * Gets an expression that will become the value of the props property
   * `name` of this component, for example the attribute value of a JSX
   * element that instantiates this component.
   */
  DataFlow::Node getACandidatePropsValue(string name) {
    getACandidatePropsSource().hasPropertyWrite(name, result)
    or
    exists(ReactJSXElement e, JSXAttribute attr |
      this = e.getComponent() and
      attr = e.getAttributeByName(name) and
      result.asExpr() = attr.getValue()
    )
  }

  /**
   * Gets a value that used to be the props object of this
   * component, for example the `prevProps` parameter of the
   * `comoponentDidUpdate` method of this component.
   */
  DataFlow::SourceNode getAPreviousPropsSource() {
    exists(DataFlow::FunctionNode callback, int propsParameterIndex |
      // "prevProps" object as callback argument
      callback.getParameter(propsParameterIndex).flowsTo(result)
    |
      // setState: (prevState, props)
      callback = getAMethodCall("setState").getCallback(0) and
      propsParameterIndex = 1
      or
      propsParameterIndex = 0 and
      (
        // componentDidUpdate: (prevProps, prevState)
        callback = getInstanceMethod("componentDidUpdate").flow()
        or
        // getDerivedStateFromProps: (props, state)
        callback = getStaticMethod("getDerivedStateFromProps").flow()
        or
        // getSnapshotBeforeUpdate: (prevProps, prevState)
        callback = getInstanceMethod("getSnapshotBeforeUpdate").flow()
      )
    )
  }
}

/**
 * Holds if `f` always returns a JSX element or fragment, or a React element.
 */
private predicate alwaysReturnsJSXOrReactElements(Function f) {
  forex(Expr e | e.flow().(DataFlow::SourceNode).flowsToExpr(f.getAReturnedExpr()) |
    e instanceof JSXNode or
    e instanceof ReactElementDefinition
  )
}

/**
 * A React component implemented as a plain function.
 */
class FunctionalComponent extends ReactComponent, Function {
  FunctionalComponent() {
    // heuristic: a function with a single parameter named `props`
    // that always returns a JSX element or fragment, or a React
    // element is probably a component
    getNumParameter() = 1 and
    exists(Parameter p | p = getParameter(0) |
      p.getName().regexpMatch("(?i).*props.*") or
      p instanceof ObjectPattern
    ) and
    alwaysReturnsJSXOrReactElements(this)
  }

  override Function getInstanceMethod(string name) { name = "render" and result = this }

  override Function getStaticMethod(string name) { none() }

  override DataFlow::SourceNode getADirectPropsAccess() {
    result = DataFlow::parameterNode(getParameter(0))
  }

  override AbstractValue getAbstractComponent() { result = AbstractInstance::of(this) }

  private DataFlow::SourceNode getAComponentCreatorReference(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::valueNode(this)
    or
    exists(DataFlow::TypeTracker t2 | result = getAComponentCreatorReference(t2).track(t2, t))
  }

  override DataFlow::SourceNode getAComponentCreatorReference() {
    result = getAComponentCreatorReference(DataFlow::TypeTracker::end())
  }

  override DataFlow::SourceNode getComponentCreatorSource() { result = DataFlow::valueNode(this) }

  override DataFlow::SourceNode getADefaultPropsSource() {
    exists(DataFlow::Node props |
      result.flowsTo(props) and
      DataFlow::valueNode(this).(DataFlow::SourceNode).hasPropertyWrite("defaultProps", props)
    )
  }
}

/**
 * A React/Preact component implemented as a class.
 */
abstract private class SharedReactPreactClassComponent extends ReactComponent, ClassDefinition {
  override Function getInstanceMethod(string name) {
    result = ClassDefinition.super.getInstanceMethod(name)
  }

  override Function getStaticMethod(string name) {
    exists(MethodDeclaration decl |
      decl = getMethod(name) and
      decl.isStatic() and
      result = decl.getBody()
    )
  }

  override DataFlow::SourceNode getADirectPropsAccess() {
    result.(DataFlow::PropRef).accesses(ref(), "props") or
    result = DataFlow::parameterNode(getConstructor().getBody().getParameter(0))
  }

  override AbstractValue getAbstractComponent() { result = AbstractInstance::of(this) }

  override DataFlow::SourceNode getAComponentCreatorReference() {
    result = DataFlow::valueNode(this).(DataFlow::ClassNode).getAClassReference()
  }

  override DataFlow::SourceNode getComponentCreatorSource() { result = DataFlow::valueNode(this) }

  override DataFlow::SourceNode getACandidateStateSource() {
    result = ReactComponent.super.getACandidateStateSource() or
    result.flowsToExpr(getField("state").getInit())
  }

  override DataFlow::SourceNode getADefaultPropsSource() {
    exists(DataFlow::Node props |
      result.flowsTo(props) and
      DataFlow::valueNode(this).(DataFlow::SourceNode).hasPropertyWrite("defaultProps", props)
    )
  }
}

/**
 * A React component implemented as a class
 */
abstract class ES2015Component extends SharedReactPreactClassComponent { }

/**
 * A React component implemented as a class extending `React.Component`
 * or `React.PureComponent`.
 */
private class DefiniteES2015Component extends ES2015Component {
  DefiniteES2015Component() {
    exists(DataFlow::SourceNode sup | sup.flowsToExpr(getSuperClass()) |
      exists(PropAccess access, string globalReactName |
        (globalReactName = "react" or globalReactName = "React") and
        access = sup.asExpr()
      |
        access.getQualifiedName() = globalReactName + ".Component" or
        access.getQualifiedName() = globalReactName + ".PureComponent"
      )
      or
      sup = DataFlow::moduleMember("react", "Component")
      or
      sup = DataFlow::moduleMember("react", "PureComponent")
      or
      sup.getAstNode() instanceof ES2015Component
    )
  }
}

/**
 * A Preact component.
 */
abstract class PreactComponent extends SharedReactPreactClassComponent {
  override DataFlow::SourceNode getADirectPropsAccess() {
    result = super.getADirectPropsAccess() or
    result = DataFlow::parameterNode(getInstanceMethod("render").getParameter(0))
  }

  override DataFlow::SourceNode getADirectStateAccess() {
    result = super.getADirectStateAccess() or
    result = DataFlow::parameterNode(getInstanceMethod("render").getParameter(1))
  }
}

/**
 * A Preact component implemented as a class extending `Preact.Component`.
 */
private class DefinitePreactComponent extends PreactComponent {
  DefinitePreactComponent() {
    exists(DataFlow::SourceNode sup | sup.flowsToExpr(getSuperClass()) |
      exists(PropAccess access, string globalPreactName |
        (globalPreactName = "preact" or globalPreactName = "Preact") and
        access = sup.asExpr()
      |
        access.getQualifiedName() = globalPreactName + ".Component" or
        sup = DataFlow::moduleMember("preact", "Component") or
        sup.getAstNode() instanceof PreactComponent
      )
    )
  }
}

/**
 * A React or Preact component implemented as a class which:
 *
 * - extends class called `Component`
 * - has a `render` method that returns JSX or React elements.
 */
private class HeuristicReactPreactComponent extends ClassDefinition, PreactComponent,
  ES2015Component {
  HeuristicReactPreactComponent() {
    any(DataFlow::GlobalVarRefNode c | c.getName() = "Component").flowsToExpr(getSuperClass()) and
    alwaysReturnsJSXOrReactElements(ClassDefinition.super.getInstanceMethod("render"))
  }
}

/**
 * A legacy React component implemented using `React.createClass` or `create-react-class`.
 */
class ES5Component extends ReactComponent, ObjectExpr {
  DataFlow::CallNode create;

  ES5Component() {
    (
      // React.createClass({...})
      create = react().getAMethodCall("createClass")
      or
      // require('create-react-class')({...})
      create = DataFlow::moduleImport("create-react-class").getACall()
    ) and
    create.getArgument(0).getALocalSource().asExpr() = this
  }

  override Function getInstanceMethod(string name) { result = getPropertyByName(name).getInit() }

  override Function getStaticMethod(string name) { none() }

  override DataFlow::SourceNode getADirectPropsAccess() {
    result.(DataFlow::PropRef).accesses(ref(), "props")
  }

  override AbstractValue getAbstractComponent() { result = TAbstractObjectLiteral(this) }

  private DataFlow::SourceNode getAComponentCreatorReference(DataFlow::TypeTracker t) {
    t.start() and
    result = create
    or
    exists(DataFlow::TypeTracker t2 | result = getAComponentCreatorReference(t2).track(t2, t))
  }

  override DataFlow::SourceNode getAComponentCreatorReference() {
    result = getAComponentCreatorReference(DataFlow::TypeTracker::end())
  }

  override DataFlow::SourceNode getComponentCreatorSource() { result = create }

  override DataFlow::SourceNode getACandidateStateSource() {
    result = ReactComponent.super.getACandidateStateSource() or
    result.flowsToExpr(getInstanceMethod("getInitialState").getAReturnedExpr())
  }

  override DataFlow::SourceNode getADefaultPropsSource() {
    exists(Function f |
      f = getInstanceMethod("getDefaultProps") and
      result.flowsToExpr(f.getAReturnedExpr())
    )
  }
}

/**
 * A DOM element created by a React function.
 */
abstract class ReactElementDefinition extends DOM::ElementDefinition {
  override DOM::ElementDefinition getParent() { none() }

  /**
   * Gets the `props` argument of this definition.
   */
  abstract DataFlow::Node getProps();
}

/**
 * A DOM element created by the `React.createElement` function.
 */
private class CreateElementDefinition extends ReactElementDefinition {
  DataFlow::MethodCallNode call;

  CreateElementDefinition() {
    call.asExpr() = this and
    call = react().getAMethodCall("createElement")
  }

  override string getName() { call.getArgument(0).mayHaveStringValue(result) }

  override DataFlow::Node getProps() { result = call.getArgument(1) }
}

/**
 * A DOM element created by the (legacy) `React.createFactory` function.
 */
private class FactoryDefinition extends ReactElementDefinition {
  DataFlow::MethodCallNode factory;
  DataFlow::CallNode call;

  FactoryDefinition() {
    call.asExpr() = this and
    call = factory.getACall() and
    factory = react().getAMethodCall("createFactory")
  }

  override string getName() { factory.getArgument(0).mayHaveStringValue(result) }

  override DataFlow::Node getProps() { result = call.getArgument(0) }
}

/**
 * Partial invocation for calls to `React.Children.map` or a similar library function
 * that binds `this` of a callback.
 */
private class ReactCallbackPartialInvoke extends DataFlow::PartialInvokeNode::Range,
  DataFlow::CallNode {
  ReactCallbackPartialInvoke() {
    exists(string name |
      // React.Children.map or React.Children.forEach
      name = "map" or
      name = "forEach"
    |
      this = react().getAPropertyRead("Children").getAMemberCall(name) and
      3 = getNumArgument()
    )
  }

  override DataFlow::Node getBoundReceiver(DataFlow::Node callback) {
    callback = getArgument(1) and
    result = getArgument(2)
  }
}

/**
 * A `JSXElement` that instantiates a `ReactComponent`.
 */
private class ReactJSXElement extends JSXElement {
  ReactComponent component;

  ReactJSXElement() { component.getAComponentCreatorReference().flowsToExpr(getNameExpr()) }

  /**
   * Gets the component this element instantiates.
   */
  ReactComponent getComponent() { result = component }
}
