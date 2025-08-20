/**
 * Provides classes for recognizing type inference inconsistencies.
 */

private import rust
private import Type
private import TypeMention
private import TypeInference
private import TypeInference::Consistency as Consistency
import TypeInference::Consistency

query predicate illFormedTypeMention(TypeMention tm) {
  Consistency::illFormedTypeMention(tm) and
  not tm instanceof PathTypeReprMention and // avoid overlap with `PathTypeMention`
  // Only include inconsistencies in the source, as we otherwise get
  // inconsistencies from library code in every project.
  tm.fromSource()
}

query predicate nonUniqueCertainType(AstNode n, TypePath path) {
  Consistency::nonUniqueCertainType(n, path, _)
}

int getTypeInferenceInconsistencyCounts(string type) {
  type = "Missing type parameter ID" and
  result = count(TypeParameter tp | missingTypeParameterId(tp) | tp)
  or
  type = "Non-functional type parameter ID" and
  result = count(TypeParameter tp | nonFunctionalTypeParameterId(tp) | tp)
  or
  type = "Non-injective type parameter ID" and
  result = count(TypeParameter tp | nonInjectiveTypeParameterId(tp, _) | tp)
  or
  type = "Ill-formed type mention" and
  result = count(TypeMention tm | illFormedTypeMention(tm) | tm)
  or
  type = "Non-unique certain type information" and
  result = count(AstNode n, TypePath path | nonUniqueCertainType(n, path) | n)
}
