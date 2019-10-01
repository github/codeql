/**
 * @name Suspicious method name declaration
 * @description A method having the name "function", "new", or "constructor"
 *              is usually caused by a programmer being confused about the TypeScript syntax. 
 * @kind problem
 * @problem.severity warning
 * @id js/suspicious-method-name-declaration
 * @precision high
 * @tags correctness
 *       typescript
 *       methods
 */

import javascript

/**
 * Holds if the method name on the given container is likely to be a mistake.
 */
predicate isSuspisousMethodName(string name, ClassOrInterface container) {
  name = "function"
  or
  // "constructor" is only suspicious outside a class.  
  name = "constructor" and not container instanceof ClassDefinition
  or
  // "new" is only suspicious inside a class.
  name = "new" and container instanceof ClassDefinition
}

from MethodDeclaration member, ClassOrInterface container, string name, string msg
where
  container.getLocation().getFile().getFileType().isTypeScript() and
  container.getMember(name) = member and
  isSuspisousMethodName(name, container) and
  
  // Assume that a "new" method is intentional if the class has an explicit constructor.
  not (
    name = "new" and
    container instanceof ClassDefinition and
	not container.getMember("constructor").(ConstructorDeclaration).isSynthetic()
  ) and
  
  // Explicitly declared static methods are fine.
  not (
    container instanceof ClassDefinition and
    member.isStatic()
  ) and
  
  // Only looking for declared methods. Methods with a body are OK. 
  not exists(member.getBody().getBody()) and
  
  // The developer was not confused about "function" when there are other methods in the interface.
  not (
    name = "function" and 
    exists(MethodDeclaration other | other = container.getAMethod() |
      name != "function" and
      not other.(ConstructorDeclaration).isSynthetic()
    )
  ) and
  
  (
    name = "constructor" and msg = "The member name 'constructor' does not declare a constructor in interface declarations, but it does in class declarations." 
    or
    name = "new" and msg = "The member name 'new' does not declare a constructor, but 'constructor' does in class declarations."
    or
    name = "function" and msg = "The member name 'function' does not declare a function, it declares a method named 'function'."
  )
select member, msg
