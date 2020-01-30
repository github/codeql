import csharp
private import DataFlow
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.web.UI

class DisposableType extends RefType {
  DisposableType() { this.getABaseType+() instanceof SystemIDisposableInterface }
}

class DisposableField extends Field {
  DisposableField() { this.getType() instanceof DisposableType }
}

class WebControl extends RefType {
  WebControl() { this.getBaseClass*() instanceof SystemWebUIControlClass }
}

class WebPage extends RefType {
  WebPage() { this.getBaseClass*() instanceof SystemWebUIPageClass }
}

/**
 * Holds if `f` is an auto-disposed web control.
 *
 * Web controls that are either child controls or controls on a page
 * are auto disposed: `System.Web.UI.Control` defines `UnloadRecursive()`
 * which invokes `Dispose()` recursively on all nested controls;
 * `System.Web.UI.Page` defines `ProcessRequestCleanup()` which invokes
 * `UnloadRecursive()`.
 */
predicate isAutoDisposedWebControl(Field f) {
  f.getType() instanceof WebControl and
  f.getDeclaringType() =
    any(RefType t |
      t instanceof WebControl or
      t instanceof WebPage
    )
}

/**
 * An object creation that creates an `IDisposable` instance into the local scope.
 */
class LocalScopeDisposableCreation extends Call {
  LocalScopeDisposableCreation() {
    exists(Type t |
      t = this.getType() and
      // Type extends IDisposable
      t instanceof DisposableType and
      // Within function, not field or instance initializer
      exists(this.getEnclosingCallable())
    |
      // Either an ordinary object creation
      this instanceof ObjectCreation
      or
      // Or a creation using a factory method
      exists(Method create | this.getTarget() = create |
        create.hasName("Create") and
        create.isStatic() and
        create.getDeclaringType().getSourceDeclaration() = t.getSourceDeclaration()
      )
    )
  }
}
