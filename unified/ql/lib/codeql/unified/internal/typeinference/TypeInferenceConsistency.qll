/**
 * Provides logic for recognizing type inference inconsistencies.
 */

private import Type
private import TypeMention
private import TypeInference
private import TypeInference::Consistency as Consistency
import TypeInference::Consistency

query predicate illFormedTypeMention(TypeMention tm) {
  Consistency::illFormedTypeMention(tm) and
  tm.fromSource()
}

query predicate nonUniqueCertainType(AstNode n, TypePath path) {
  Consistency::nonUniqueCertainType(n, path) and
  n.fromSource()
}
