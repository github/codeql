/**
 * This library provides utility predicates for representing the number of dependencies between types.
 */

import Type
import Generics
import Expr

/**
 * The number of dependencies from type `t` on type `dep`.
 *
 * Dependencies are restricted to generic and non-generic reference types.
 *
 * Dependencies on parameterized or raw types are decomposed into
 * a dependency on the corresponding generic type and separate
 * dependencies on (source declarations of) any type arguments.
 *
 * For example, a dependency on type `List<Set<String>>` is represented by
 * dependencies on the generic types `List` and `Set` as well as a dependency
 * on the type `String` but not on the parameterized types `List<Set<String>>`
 * or `Set<String>`.
 */
pragma[nomagic]
predicate numDepends(RefType t, RefType dep, int value) {
  // Type `t` is neither a parameterized nor a raw type and is distinct from `dep`.
  not isParameterized(t) and
  not isRaw(t) and
  not t = dep and
  // Type `t` depends on:
  value =
    strictcount(Element elem |
      // its supertypes,
      exists(RefType s | elem = s and t.hasSupertype(s) | usesType(s, dep))
      or
      // its enclosing types,
      exists(RefType s | elem = s and t.getEnclosingType() = s | usesType(s, dep))
      or
      // the type of any field declared in `t`,
      exists(Field f | elem = f and f.getDeclaringType() = t | usesType(f.getType(), dep))
      or
      // the return type of any method declared in `t`,
      exists(Method m | elem = m and m.getDeclaringType() = t | usesType(m.getReturnType(), dep))
      or
      // the type of any parameter of a callable in `t`,
      exists(Parameter p | elem = p and p.getCallable().getDeclaringType() = t |
        usesType(p.getType(), dep)
      )
      or
      // the type of any exception in the `throws` clause of a callable declared in `t`,
      exists(Exception e | elem = e and e.getCallable().getDeclaringType() = t |
        usesType(e.getType(), dep)
      )
      or
      // the declaring type of a callable accessed in `t`,
      exists(Call c |
        elem = c and
        c.getEnclosingCallable().getDeclaringType() = t
      |
        usesType(c.getCallee().getSourceDeclaration().getDeclaringType(), dep)
      )
      or
      // the declaring type of a field accessed in `t`,
      exists(FieldAccess fa |
        elem = fa and
        fa.getEnclosingCallable().getDeclaringType() = t
      |
        usesType(fa.getField().getSourceDeclaration().getDeclaringType(), dep)
      )
      or
      // the type of a local variable declared in `t`,
      exists(LocalVariableDeclExpr decl |
        elem = decl and
        decl.getEnclosingCallable().getDeclaringType() = t
      |
        usesType(decl.getType(), dep)
      )
      or
      // the type of a type literal accessed in `t`,
      exists(TypeLiteral l |
        elem = l and
        l.getEnclosingCallable().getDeclaringType() = t
      |
        usesType(l.getTypeName().getType(), dep)
      )
      or
      // the type of an annotation (or one of its element values) that annotates `t` or one of its members,
      exists(Annotation a |
        a.getAnnotatedElement() = t or
        a.getAnnotatedElement().(Member).getDeclaringType() = t
      |
        elem = a and usesType(a.getType(), dep)
        or
        elem = a.getAValue() and
        elem.getFile().getExtension() = "java" and
        usesType(elem.(Expr).getType(), dep)
      )
      or
      // the type accessed in an `instanceof` expression in `t`.
      exists(InstanceOfExpr ioe |
        elem = ioe and
        t = ioe.getEnclosingCallable().getDeclaringType()
      |
        usesType(ioe.getTypeName().getType(), dep)
      )
    )
}

predicate filePackageDependencyCount(File sourceFile, int total, string entity) {
  exists(Package targetPackage |
    total =
      strictsum(RefType sourceType, RefType targetType, int num |
        sourceType.getFile() = sourceFile and
        sourceType.fromSource() and
        sourceType.getPackage() != targetPackage and
        targetType.getPackage() = targetPackage and
        numDepends(sourceType, targetType, num)
      |
        num
      ) and
    entity = "/" + sourceFile.getRelativePath() + "<|>" + targetPackage + "<|>N/A"
  )
}

private string nameVersionRegex() { result = "([_.A-Za-z0-9-]*)-([0-9][A-Za-z0-9.+_-]*)" }

/**
 * Given a JAR filename, try to split it into a name and version.
 * This is a heuristic approach assuming that the a dash is used to
 * separate the library name from a largely numeric version such as
 * `commons-io-2.4`.
 */
bindingset[target]
predicate hasDashedVersion(string target, string name, string version) {
  exists(string regex | regex = nameVersionRegex() |
    name = target.regexpCapture(regex, 1) and
    version = target.regexpCapture(regex, 2)
  )
}

predicate fileJarDependencyCount(File sourceFile, int total, string entity) {
  exists(Container targetJar, string jarStem |
    jarStem = targetJar.getStem() and
    targetJar.(File).getExtension() = "jar" and
    jarStem != "rt"
  |
    total =
      strictsum(RefType r, RefType dep, int num |
        r.getFile() = sourceFile and
        r.fromSource() and
        dep.getFile().getParentContainer*() = targetJar and
        numDepends(r, dep, num)
      |
        num
      ) and
    exists(string name, string version |
      if hasDashedVersion(jarStem, _, _)
      then hasDashedVersion(jarStem, name, version)
      else (
        name = jarStem and version = "unknown"
      )
    |
      entity = "/" + sourceFile.getRelativePath() + "<|>" + name + "<|>" + version
    )
  )
}
