/**
 * @name Unused classes and interfaces
 * @description A non-public class or interface that is not used anywhere in the program wastes
 *              programmer resources.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/unused-reference-type
 * @tags maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import java
import semmle.code.java.Reflection

/**
 * Gets a transitive superType avoiding magic optimisation
 */
pragma[nomagic]
cached
private RefType getASuperTypePlus(RefType t) { hasDescendant(result, t) and result != t }

/**
 * A class or interface that is not used anywhere.
 */
predicate dead(RefType dead) {
  dead.fromSource() and
  // Nothing depends on this type.
  not exists(RefType s | s.getMetrics().getADependency() = dead) and
  // Exclude Struts or JSP classes (marked with Javadoc tags).
  not exists(JavadocTag tag, string x |
    tag = dead.getDoc().getJavadoc().getATag(x) and
    (x.matches("@struts%") or x.matches("@jsp%"))
  ) and
  // Exclude public types.
  not dead.isPublic() and
  // Exclude results that have a `main` method.
  not dead.getAMethod().hasName("main") and
  // Exclude results that are referenced in XML files.
  not exists(XmlAttribute xla | xla.getValue() = dead.getQualifiedName()) and
  // Exclude type variables.
  not dead instanceof BoundedType and
  // Exclude JUnit tests.
  not dead.getAnAncestor().hasName("TestCase") and
  // Exclude enum types.
  not dead instanceof EnumType and
  // Exclude anonymous classes
  not dead instanceof AnonymousClass and
  // Exclude classes that look like they may be reflectively constructed.
  not dead.getAnAnnotation() instanceof ReflectiveAccessAnnotation and
  not dead.getAMethod().getAnAnnotation() instanceof ReflectiveAccessAnnotation and
  // Insist all source ancestors are dead as well.
  forall(RefType t | t.fromSource() and t = getASuperTypePlus(dead) | dead(t)) and
  // Exclude compiler generated classes (e.g. declaring type of adapter functions in Kotlin)
  not dead.isCompilerGenerated()
}

from RefType t, string kind
where
  dead(t) and
  (
    t instanceof Class and kind = "class"
    or
    t instanceof Interface and kind = "interface"
  )
select t,
  "Unused " + kind + ": " + t.getName() + " is not referenced within this codebase. " +
    "If not used as an external API it should be removed."
