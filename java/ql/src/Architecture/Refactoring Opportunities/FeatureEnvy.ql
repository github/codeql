/**
 * @name Feature envy
 * @description A method that uses more methods or variables from another (unrelated) class than
 *              from its own class violates the principle of putting data and behavior in the same
 *              place.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/feature-envy
 * @tags maintainability
 *       modularity
 */

import java

Member getAUsedMember(Method m) {
  result.(Field).getAnAccess().getEnclosingCallable() = m or
  result.(Callable).getAReference().getEnclosingCallable() = m
}

int dependencyCount(Method source, RefType target) {
  result = strictcount(Member m | m = getAUsedMember(source) and m = target.getAMember())
}

predicate methodDependsOn(Method m, RefType target) { exists(dependencyCount(m, target)) }

predicate dependsOn(RefType source, RefType target) {
  methodDependsOn(source.getACallable(), target)
}

int selfDependencyCount(Method source) {
  result = sum(dependencyCount(source, source.getDeclaringType().getEnclosingType*()))
}

predicate dependsHighlyOn(Method source, RefType target, int selfCount, int depCount) {
  depCount = dependencyCount(source, target) and
  selfCount = selfDependencyCount(source) and
  depCount > 2 * selfCount and
  depCount > 4
}

predicate query(Method m, RefType targetType, int selfCount, int depCount) {
  exists(RefType sourceType | sourceType = m.getDeclaringType() |
    dependsHighlyOn(m, targetType, selfCount, depCount) and
    // Interfaces are depended upon by their very nature
    not targetType instanceof Interface and
    // Anonymous classes are often used as callbacks, which heavily depend on other classes
    not sourceType instanceof AnonymousClass and
    // Do not move initializer methods
    not m instanceof InitializerMethod and
    // Do not move up/down the class hierarchy
    not (
      sourceType.getAnAncestor().getSourceDeclaration() = targetType or
      targetType.getAnAncestor().getSourceDeclaration() = sourceType
    ) and
    // Do not move between nested types
    not (sourceType.getEnclosingType*() = targetType or targetType.getEnclosingType*() = sourceType) and
    // Tests are allowed to be invasive and depend on the tested classes highly
    not sourceType instanceof TestClass and
    // Check that the target type already depends on every type used by the method
    forall(RefType dependency | methodDependsOn(m, dependency) | dependsOn(targetType, dependency))
  )
}

from Method m, RefType other, int selfCount, int depCount
where
  query(m, other, selfCount, depCount) and
  // Don't include types that are used from many different places - we only highlight
  // relatively local fixes that could reasonably be implemented.
  count(Method yetAnotherMethod | query(yetAnotherMethod, other, _, _)) < 10
select m,
  "Method " + m.getName() + " is too closely tied to $@: " + depCount +
    " dependencies to it, but only " + selfCount + " dependencies to its own type.", other,
  other.getName()
