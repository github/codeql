private import java
private import AutomodelEndpointTypes as AutomodelEndpointTypes

/**
 * A helper class to represent a string value that can be returned by a query using $@ notation.
 *
 * It extends `string`, but adds a mock `hasLocationInfo` method that returns the string itself as the file name.
 *
 * Use this, when you want to return a string value from a query using $@ notation - the string value
 * will be included in the sarif file.
 *
 *
 * Background information on `hasLocationInfo`:
 * https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/#providing-location-information
 */
class DollarAtString extends string {
  bindingset[this]
  DollarAtString() { any() }

  bindingset[this]
  predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    path = this and sl = 1 and sc = 1 and el = 1 and ec = 1
  }
}

/**
 * Holds for all combinations of MaD kinds (`kind`) and their human readable
 * descriptions.
 */
predicate isKnownKind(string kind, AutomodelEndpointTypes::EndpointType type) {
  kind = type.getKind()
}

/**
 * By convention, the subtypes property of the MaD declaration should only be
 * true when there _can_ exist any subtypes with a different implementation.
 *
 * It would technically be ok to always use the value 'true', but this would
 * break convention.
 */
pragma[nomagic]
boolean considerSubtypes(Callable callable) {
  if
    callable.isStatic() or
    callable.getDeclaringType().isStatic() or
    callable.isFinal() or
    callable.getDeclaringType().isFinal()
  then result = false
  else result = true
}

/**
 * Holds if the given package, type, name and signature is a candidate for automodeling.
 *
 * This predicate is extensible, so that different endpoints can be selected at runtime.
 */
extensible predicate automodelCandidateFilter(
  string package, string type, string name, string signature
);

/**
 * Holds if the given package, type, name and signature is a candidate for automodeling.
 *
 * This relies on an extensible predicate, and if that is not supplied then
 * all endpoints are considered candidates.
 */
bindingset[package, type, name, signature]
predicate includeAutomodelCandidate(string package, string type, string name, string signature) {
  not automodelCandidateFilter(_, _, _, _) or
  automodelCandidateFilter(package, type, name, signature)
}

/**
 * Holds if the given program element corresponds to a piece of source code,
 * that is, it is not compiler-generated.
 *
 * Note: This is a stricter check than `Element::fromSource`, which simply
 * checks whether the element is in a source file as opposed to a JAR file.
 * There can be compiler-generated elements in source files (especially for
 * Kotlin), which we also want to exclude.
 */
predicate isFromSource(Element e) {
  // from a source file (not a JAR)
  e.fromSource() and
  // not explicitly marked as compiler-generated
  not e.isCompilerGenerated() and
  // does not have a dummy location
  not e.hasLocationInfo(_, 0, 0, 0, 0)
}

/**
 * Holds if taint cannot flow through the given type (because it is a numeric
 * type or some other type with a fixed set of values).
 */
predicate isUnexploitableType(Type tp) {
  tp instanceof PrimitiveType or
  tp instanceof BoxedType or
  tp instanceof NumberType or
  tp instanceof VoidType
}

/**
 * Holds if the given method can be overridden, that is, it is not final,
 * static, or private.
 */
predicate isOverridable(Method m) {
  not m.getDeclaringType().isFinal() and
  not m.isFinal() and
  not m.isStatic() and
  not m.isPrivate()
}
