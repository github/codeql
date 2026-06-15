/**
 * Provides classes for working with the AngularJS `$injector` methods.
 *
 * INTERNAL: Do not import this module directly, import `AngularJS` instead.
 *
 * NOTE: The API of this library is not stable yet and may change in
 *       the future.
 */

import javascript
private import AngularJS

/**
 * Holds if `nd` is an `angular.injector()` value
 */
private DataFlow::CallNode angularInjector() { result = angular().getAMemberCall("injector") }

/**
 * A call to `$angular.injector().invoke(...)`
 */
class InjectorInvokeCall extends DataFlow::CallNode, DependencyInjection {
  InjectorInvokeCall() { this = angularInjector().getAMemberCall("invoke") }

  override DataFlow::Node getAnInjectableFunction() { result = this.getArgument(0) }
}

/**
 * An expression that dependency-inject some of its input with AngularJS dependency injection services.
 */
abstract class DependencyInjection extends DataFlow::ValueNode {
  /**
   * Gets a node that will be dependency-injected.
   */
  abstract DataFlow::Node getAnInjectableFunction();
}

/**
 * An injectable function, that is, a function that could have its dependency
 * parameters automatically provided by the AngularJS `$inject` service.
 */
abstract class InjectableFunction extends DataFlow::ValueNode {
  /** Gets the parameter corresponding to dependency `name`. */
  abstract DataFlow::ParameterNode getDependencyParameter(string name);

  /**
   * Gets the `i`th dependency declaration, which is also named `name`.
   */
  abstract DataFlow::Node getDependencyDeclaration(int i, string name);

  /**
   * Gets a node for the `name` dependency declaration.
   */
  DataFlow::Node getADependencyDeclaration(string name) {
    result = this.getDependencyDeclaration(_, name)
  }

  /**
   * Gets the dataflow node for the `i`th dependency declaration.
   */
  DataFlow::Node getDependencyDeclaration(int i) { result = this.getDependencyDeclaration(i, _) }

  /** Gets the function underlying this injectable function. */
  abstract DataFlow::FunctionNode asFunction();

  /** Gets a node where this function is explicitly dependency injected. */
  abstract DataFlow::Node getAnExplicitDependencyInjection();

  /**
   * Gets a service corresponding to the dependency-injected `parameter`.
   */
  ServiceReference getAResolvedDependency(DataFlow::ParameterNode parameter) {
    exists(string name, InjectableFunctionServiceRequest request |
      this = request.getAnInjectedFunction() and
      parameter = this.getDependencyParameter(name) and
      result = request.getAServiceDefinition(name)
    )
  }

  /**
   * Gets a Custom service corresponding to the dependency-injected `parameter`.
   * (this is a convenience variant of `getAResolvedDependency`)
   */
  DataFlow::Node getCustomServiceDependency(DataFlow::ParameterNode parameter) {
    exists(CustomServiceDefinition custom |
      custom.getServiceReference() = this.getAResolvedDependency(parameter) and
      result = custom.getAService()
    )
  }
}

/**
 * An injectable function that does not explicitly list its dependencies,
 * instead relying on implicit matching by parameter names.
 */
private class FunctionWithImplicitDependencyAnnotation extends InjectableFunction instanceof DataFlow::FunctionNode
{
  FunctionWithImplicitDependencyAnnotation() {
    this.(DataFlow::FunctionNode).flowsTo(any(DependencyInjection d).getAnInjectableFunction()) and
    not exists(getAPropertyDependencyInjection(this))
  }

  override DataFlow::ParameterNode getDependencyParameter(string name) {
    result = super.getParameterByName(name)
  }

  override DataFlow::ParameterNode getDependencyDeclaration(int i, string name) {
    result.getName() = name and
    result = super.getParameter(i)
  }

  override DataFlow::FunctionNode asFunction() { result = this }

  override DataFlow::Node getAnExplicitDependencyInjection() { none() }
}

private DataFlow::PropWrite getAPropertyDependencyInjection(DataFlow::FunctionNode function) {
  result = function.getAPropertyWrite("$inject")
}

/**
 * An injectable function with an `$inject` property that lists its
 * dependencies.
 */
private class FunctionWithInjectProperty extends InjectableFunction instanceof DataFlow::FunctionNode
{
  DataFlow::ArrayCreationNode dependencies;

  FunctionWithInjectProperty() {
    (
      this.(DataFlow::FunctionNode).flowsTo(any(DependencyInjection d).getAnInjectableFunction()) or
      exists(FunctionWithExplicitDependencyAnnotation f | f.asFunction() = this)
    ) and
    exists(DataFlow::PropWrite pwn |
      pwn = getAPropertyDependencyInjection(this) and
      pwn.getRhs().getALocalSource() = dependencies
    )
  }

  override DataFlow::ParameterNode getDependencyParameter(string name) {
    exists(int i | exists(this.getDependencyDeclaration(i, name)) | result = super.getParameter(i))
  }

  override DataFlow::Node getDependencyDeclaration(int i, string name) {
    result = dependencies.getElement(i) and
    result.mayHaveStringValue(name)
  }

  override DataFlow::FunctionNode asFunction() { result = this }

  override DataFlow::Node getAnExplicitDependencyInjection() {
    result = getAPropertyDependencyInjection(this)
  }
}

/**
 * An injectable function embedded in an array of dependencies.
 */
private class FunctionWithExplicitDependencyAnnotation extends InjectableFunction instanceof DataFlow::ArrayCreationNode
{
  DataFlow::FunctionNode function;

  FunctionWithExplicitDependencyAnnotation() {
    this.(DataFlow::SourceNode).flowsTo(any(DependencyInjection d).getAnInjectableFunction()) and
    function.flowsTo(super.getElement(super.getSize() - 1))
  }

  override DataFlow::ParameterNode getDependencyParameter(string name) {
    exists(int i | super.getElement(i).mayHaveStringValue(name) | result = function.getParameter(i))
  }

  override DataFlow::Node getDependencyDeclaration(int i, string name) {
    result = super.getElement(i) and
    result.mayHaveStringValue(name)
  }

  override DataFlow::FunctionNode asFunction() { result = function }

  override DataFlow::Node getAnExplicitDependencyInjection() {
    result = this or
    result = function.(InjectableFunction).getAnExplicitDependencyInjection()
  }
}
