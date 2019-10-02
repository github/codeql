/**
 * @name Suspicious method name declaration
 * @description Declaring a class or interface method with a special name may cause a normal 
 *              named method to be declared when a special type was expected.
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
  
  // Cases to ignore.
  not (
    // Assume that a "new" method is intentional if the class has an explicit constructor.
    name = "new" and
    container instanceof ClassDefinition and
    exists(ConstructorDeclaration constructor |
      container.getMember("constructor") = constructor and
      not constructor.isSynthetic() 
    ) 
    or
    // Explicitly declared static methods are fine.
    container instanceof ClassDefinition and
    member.isStatic()
    or
    // Only looking for declared methods. Methods with a body are OK. 
    exists(member.getBody().getBody())
    or
    // The developer was not confused about "function" when there are other methods in the interface.
    name = "function" and 
    exists(MethodDeclaration other | other = container.getAMethod() |
      other.getName() != "function" and
      not other.(ConstructorDeclaration).isSynthetic()
    )
  )
  
  and
  
  (
    name = "constructor" and msg = "The member name 'constructor' does not declare a constructor in interface declarations, but it does in class declarations." 
    or
    name = "new" and msg = "The member name 'new' does not declare a constructor, but 'constructor' does in class declarations."
    or
    name = "function" and msg = "The member name 'function' does not declare a function, it declares a method named 'function'."
  )
select member, msg
