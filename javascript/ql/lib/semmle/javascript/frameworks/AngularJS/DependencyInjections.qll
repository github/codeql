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
private import ServiceDefinitions

/**
 * Holds if `nd` is an `angular.injector()` value
 */
private DataFlow::CallNode angularInjector() { result = angular().getAMemberCall("injector") }

/**
 * A call to `$angular.injector().invoke(...)`
 */
class InjectorInvokeCall extends DataFlow::CallNode, DependencyInjection {
  InjectorInvokeCall() { this = angularInjector().getAMemberCall("invoke") }

  override DataFlow::Node getAnInjectableFunction() { result = getArgument(0) }
}

/**
 * Base class for expressions that dependency-inject some of their input with AngularJS dependency injection services.
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
  abstract Parameter getDependencyParameter(string name);

  /**
   * Gets the `i`th dependency declaration, which is also named `name`.
   */
  abstract ASTNode getDependencyDeclaration(int i, string name);

  /**
   * Gets an ASTNode for the `name` dependency declaration.
   */
  ASTNode getADependencyDeclaration(string name) { result = getDependencyDeclaration(_, name) }

  /**
   * Gets the ASTNode for the `i`th dependency declaration.
   */
  ASTNode getDependencyDeclaration(int i) { result = getDependencyDeclaration(i, _) }

  /** Gets the function underlying this injectable function. */
  abstract Function asFunction();

  /** Gets a location where this function is explicitly dependency injected. */
  abstract ASTNode getAnExplicitDependencyInjection();

  /**
   * Gets a service corresponding to the dependency-injected `parameter`.
   */
  ServiceReference getAResolvedDependency(Parameter parameter) {
    exists(string name, InjectableFunctionServiceRequest request |
      this = request.getAnInjectedFunction() and
      parameter = getDependencyParameter(name) and
      result = request.getAServiceDefinition(name)
    )
  }

  /**
   * Gets a Custom service corresponding to the dependency-injected `parameter`.
   * (this is a convenience variant of `getAResolvedDependency`)
   */
  DataFlow::Node getCustomServiceDependency(Parameter parameter) {
    exists(CustomServiceDefinition custom |
      custom.getServiceReference() = getAResolvedDependency(parameter) and
      result = custom.getAService()
    )
  }
}

/**
 * An injectable function that does not explicitly list its dependencies,
 * instead relying on implicit matching by parameter names.
 */
private class FunctionWithImplicitDependencyAnnotation extends InjectableFunction {
  override Function astNode;

  FunctionWithImplicitDependencyAnnotation() {
    this.(DataFlow::FunctionNode).flowsTo(any(DependencyInjection d).getAnInjectableFunction()) and
    not exists(getAPropertyDependencyInjection(astNode))
  }

  override Parameter getDependencyParameter(string name) {
    result = astNode.getParameterByName(name)
  }

  override Parameter getDependencyDeclaration(int i, string name) {
    result.getName() = name and
    result = astNode.getParameter(i)
  }

  override Function asFunction() { result = astNode }

  override ASTNode getAnExplicitDependencyInjection() { none() }
}

private DataFlow::PropWrite getAPropertyDependencyInjection(Function function) {
  exists(DataFlow::FunctionNode ltf |
    ltf.getAstNode() = function and
    result = ltf.getAPropertyWrite("$inject")
  )
}

/**
 * An injectable function with an `$inject` property that lists its
 * dependencies.
 */
private class FunctionWithInjectProperty extends InjectableFunction {
  override Function astNode;
  DataFlow::ArrayCreationNode dependencies;

  FunctionWithInjectProperty() {
    (
      this.(DataFlow::FunctionNode).flowsTo(any(DependencyInjection d).getAnInjectableFunction()) or
      exists(FunctionWithExplicitDependencyAnnotation f | f.asFunction() = astNode)
    ) and
    exists(DataFlow::PropWrite pwn |
      pwn = getAPropertyDependencyInjection(astNode) and
      pwn.getRhs().getALocalSource() = dependencies
    )
  }

  override Parameter getDependencyParameter(string name) {
    exists(int i | exists(getDependencyDeclaration(i, name)) | result = astNode.getParameter(i))
  }

  override ASTNode getDependencyDeclaration(int i, string name) {
    exists(DataFlow::ValueNode decl |
      decl = dependencies.getElement(i) and
      decl.mayHaveStringValue(name) and
      result = decl.getAstNode()
    )
  }

  override Function asFunction() { result = astNode }

  override ASTNode getAnExplicitDependencyInjection() {
    result = getAPropertyDependencyInjection(astNode).getAstNode()
  }
}

/**
 * An injectable function embedded in an array of dependencies.
 */
private class FunctionWithExplicitDependencyAnnotation extends InjectableFunction {
  DataFlow::FunctionNode function;
  override ArrayExpr astNode;

  FunctionWithExplicitDependencyAnnotation() {
    this.(DataFlow::SourceNode).flowsTo(any(DependencyInjection d).getAnInjectableFunction()) and
    function.flowsToExpr(astNode.getElement(astNode.getSize() - 1))
  }

  override Parameter getDependencyParameter(string name) {
    exists(int i | astNode.getElement(i).mayHaveStringValue(name) |
      result = asFunction().getParameter(i)
    )
  }

  override ASTNode getDependencyDeclaration(int i, string name) {
    result = astNode.getElement(i) and
    result.(Expr).mayHaveStringValue(name)
  }

  override Function asFunction() { result = function.getAstNode() }

  override ASTNode getAnExplicitDependencyInjection() {
    result = astNode or
    result = function.(InjectableFunction).getAnExplicitDependencyInjection()
  }
}
