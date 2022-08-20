/**
 * Classes and predicates for computing the Method Resolution Order (MRO) of classes.
 * Supports both old-style (diamond) inheritance and new-style (C3 linearization) inheritance.
 */

/*
 * Implementation of the C3 linearization algorithm.
 * See https://en.wikipedia.org/wiki/C3_linearization
 *
 * The key operation is merge, which takes a list of lists and produces a list.
 * We implement it as the method `ClassListList.merge()`
 *
 * To support that we need to determine the best candidate to extract from a list of lists,
 * implemented as `ClassListList.bestMergeCandidate()`
 *
 * The following code is designed to implement those operations
 * without negation and as efficiently as possible.
 */

import python
private import semmle.python.objects.TObject
private import semmle.python.objects.ObjectInternal
private import semmle.python.pointsto.PointsTo
private import semmle.python.pointsto.PointsToContext
private import semmle.python.types.Builtins

cached
newtype TClassList =
  Empty() or
  Cons(ClassObjectInternal head, TClassList tail) { required_cons(head, tail) }

/* Keep ClassList finite and as small as possible */
private predicate required_cons(ClassObjectInternal head, ClassList tail) {
  tail = Mro::newStyleMro(sole_base(head))
  or
  tail = merge_of_linearization_of_bases(head)
  or
  exists(ClassObjectInternal cls, int n |
    head = Types::getBase(cls, n) and tail = bases(cls, n + 1)
  )
  or
  head = ObjectInternal::builtin("object") and tail = Empty()
  or
  reverse_step(_, Cons(head, _), tail)
  or
  exists(ClassListList list |
    merge_step(tail, list, _) and
    head = list.bestMergeCandidate()
  )
  or
  exists(ClassList list, int n |
    n = list.firstIndex(head) and
    tail = list.deduplicate(n + 1)
  )
  or
  exists(ClassListList list, int n |
    head = list.getHead().getItem(n) and
    tail = flatten_list(list, n + 1)
  )
  or
  tail = list_old_style_base_mros(head).flatten()
}

private ClassObjectInternal sole_base(ClassObjectInternal cls) {
  Types::base_count(cls) = 1 and
  result = Types::getBase(cls, 0)
}

/** A list of classes, used to represent the MRO of a class */
class ClassList extends TClassList {
  /** Gets a textual representation of this element. */
  string toString() { result = "[" + this.contents() + "]" }

  string contents() {
    this = Empty() and result = ""
    or
    exists(ClassObjectInternal head | head = this.getHead() |
      this.getTail() = Empty() and result = this.className(head)
      or
      this.getTail() != Empty() and result = this.className(head) + ", " + this.getTail().contents()
    )
  }

  private string className(ClassObjectInternal cls) {
    result = cls.getName()
    or
    cls = ObjectInternal::unknownClass() and result = "??"
  }

  int length() {
    this = Empty() and result = 0
    or
    result = this.getTail().length() + 1
  }

  ClassObjectInternal getHead() { this = Cons(result, _) }

  ClassList getTail() { this = Cons(_, result) }

  ClassObjectInternal getItem(int n) {
    n = 0 and result = this.getHead()
    or
    result = this.getTail().getItem(n - 1)
  }

  ClassObjectInternal getAnItem() { result = this.getItem(_) }

  pragma[inline]
  ClassList removeHead(ClassObjectInternal cls) {
    this.getHead() = cls and result = this.getTail()
    or
    this.getHead() != cls and result = this
    or
    this = Empty() and result = Empty()
  }

  predicate contains(ClassObjectInternal cls) {
    cls = this.getHead()
    or
    this.getTail().contains(cls)
  }

  pragma[nomagic]
  ClassObjectInternal findDeclaringClass(string name) {
    exists(ClassObjectInternal head, ClassList tail, ClassDecl decl |
      this = Cons(head, tail) and decl = head.getClassDeclaration()
    |
      if decl.declaresAttribute(name) then result = head else result = tail.findDeclaringClass(name)
    )
  }

  pragma[noinline]
  private ClassObjectInternal findDeclaringClassAttribute(string name) {
    result = this.findDeclaringClass(name) and
    (
      exists(any(Builtin b).getMember(name))
      or
      declaredAttributeVar(_, name, _)
    )
  }

  predicate lookup(string name, ObjectInternal value, CfgOrigin origin) {
    exists(ClassObjectInternal decl | decl = this.findDeclaringClassAttribute(name) |
      Types::declaredAttribute(decl, name, value, origin)
    )
  }

  predicate declares(string name) {
    this.getHead().getClassDeclaration().declaresAttribute(name)
    or
    this.getTail().declares(name)
  }

  ClassList startingAt(ClassObjectInternal cls) {
    exists(ClassObjectInternal head | head = this.getHead() |
      if head = cls then result = this else result = this.getTail().startingAt(cls)
    )
  }

  ClassList deduplicate() { result = this.deduplicate(0) }

  /* Helpers for `deduplicate()` */
  int firstIndex(ClassObjectInternal cls) { result = this.firstIndex(cls, 0) }

  /* Helper for firstIndex(cls), getting the first index of `cls` where result >= n */
  private int firstIndex(ClassObjectInternal cls, int n) {
    this.getItem(n) = cls and result = n
    or
    this.getItem(n) != cls and result = this.firstIndex(cls, n + 1)
  }

  /** Holds if the class at `n` is a duplicate of an earlier position. */
  private predicate duplicate(int n) {
    exists(ClassObjectInternal cls | cls = this.getItem(n) and this.firstIndex(cls) < n)
  }

  /**
   * Gets a class list which is the de-duplicated form of the list containing elements of
   * this list from `n` onwards.
   */
  ClassList deduplicate(int n) {
    n = this.length() and result = Empty()
    or
    this.duplicate(n) and result = this.deduplicate(n + 1)
    or
    exists(ClassObjectInternal cls, ClassList tail |
      this.deduplicateCons(n, cls, tail) and
      result = Cons(cls, tail)
    )
  }

  pragma[nomagic]
  private predicate deduplicateCons(int n, ClassObjectInternal cls, ClassList tail) {
    n = this.firstIndex(cls) and
    tail = this.deduplicate(n + 1)
  }

  predicate isEmpty() { this = Empty() }

  ClassList reverse() { reverse_step(this, Empty(), result) }

  /**
   * Holds if this MRO contains a class whose instances we treat specially, rather than as a generic instance.
   * For example, `type` or `int`.
   */
  boolean containsSpecial() {
    this = Empty() and result = false
    or
    exists(ClassDecl decl | decl = this.getHead().getClassDeclaration() |
      if decl.isSpecial() then result = true else result = this.getTail().containsSpecial()
    )
  }
}

private newtype TClassListList =
  EmptyList() or
  ConsList(TClassList head, TClassListList tail) { required_list(head, tail) }

/* Keep ClassListList finite and as small as possible */
private predicate required_list(ClassList head, ClassListList tail) {
  any(ClassListList x).removedClassParts(_, head, tail, _)
  or
  head = bases(_) and tail = EmptyList()
  or
  exists(ClassObjectInternal cls, int n |
    head = Mro::newStyleMro(Types::getBase(cls, n)) and
    tail = list_of_linearization_of_bases_plus_bases(cls, n + 1)
  )
  or
  exists(ClassObjectInternal cls, int n |
    head = Mro::oldStyleMro(Types::getBase(cls, n)) and
    tail = list_old_style_base_mros(cls, n + 1)
  )
}

private class ClassListList extends TClassListList {
  /** Gets a textual representation of this element. */
  string toString() { result = "[" + this.contents() + "]" }

  string contents() {
    this = EmptyList() and result = ""
    or
    exists(ClassList head | head = this.getHead() |
      this.getTail() = EmptyList() and result = head.toString()
      or
      this.getTail() != EmptyList() and result = head.toString() + ", " + this.getTail().contents()
    )
  }

  int length() {
    this = EmptyList() and result = 0
    or
    result = this.getTail().length() + 1
  }

  ClassList getHead() { this = ConsList(result, _) }

  ClassListList getTail() { this = ConsList(_, result) }

  ClassList getItem(int n) {
    n = 0 and result = this.getHead()
    or
    result = this.getTail().getItem(n - 1)
  }

  /**
   * Same as
   *
   * ```ql
   * result = this.getItem(n) and n = this.length() - 1
   * ```
   *
   * but avoids non-linear recursion.
   */
  ClassList getLastItem(int n) {
    n = 0 and this = ConsList(result, EmptyList())
    or
    exists(ClassListList tail |
      this = ConsList(_, tail) and
      result = tail.getLastItem(n - 1)
    )
  }

  private ClassObjectInternal getAHead() {
    result = this.getHead().getHead()
    or
    result = this.getTail().getAHead()
  }

  pragma[nomagic]
  ClassList merge() {
    exists(ClassList reversed |
      merge_step(reversed, EmptyList(), this) and
      result = reversed.reverse()
    )
    or
    this = EmptyList() and result = Empty()
  }

  /* Join ordering helper */
  pragma[noinline]
  predicate removedClassParts(
    ClassObjectInternal cls, ClassList removed_head, ClassListList removed_tail, int n
  ) {
    cls = this.bestMergeCandidate() and
    removed_head = this.getLastItem(n).removeHead(cls) and
    removed_tail = EmptyList()
    or
    removed_head = this.removedClassPartsCons1(cls, removed_tail, n).removeHead(cls)
  }

  pragma[nomagic]
  predicate removedClassPartsCons0(ClassObjectInternal cls, ClassListList removed_tail, int n) {
    exists(ClassList prev_head, ClassListList prev_tail |
      this.removedClassParts(cls, prev_head, prev_tail, n + 1) and
      removed_tail = ConsList(prev_head, prev_tail)
    )
  }

  pragma[nomagic]
  ClassList removedClassPartsCons1(ClassObjectInternal cls, ClassListList removed_tail, int n) {
    this.removedClassPartsCons0(cls, removed_tail, n) and
    result = this.getItem(n)
  }

  ClassListList remove(ClassObjectInternal cls) {
    exists(ClassList removed_head, ClassListList removed_tail |
      this.removedClassParts(cls, removed_head, removed_tail, 0) and
      result = ConsList(removed_head, removed_tail)
    )
    or
    this = EmptyList() and result = EmptyList() and exists(cls)
  }

  pragma[nomagic]
  private predicate legalMergeCandidateNonEmpty(
    ClassObjectInternal cls, ClassListList remainingList, ClassList remaining
  ) {
    this.legalMergeCandidate(cls, ConsList(Cons(_, remaining), remainingList))
    or
    exists(ClassObjectInternal head |
      this.legalMergeCandidateNonEmpty(cls, remainingList, Cons(head, remaining)) and
      cls != head
    )
  }

  private predicate legalMergeCandidate(ClassObjectInternal cls, ClassListList remainingList) {
    cls = this.getAHead() and remainingList = this
    or
    this.legalMergeCandidate(cls, ConsList(Empty(), remainingList))
    or
    this.legalMergeCandidateNonEmpty(cls, remainingList, Empty())
  }

  pragma[noinline]
  predicate legalMergeCandidate(ClassObjectInternal cls) {
    this.legalMergeCandidate(cls, EmptyList())
  }

  pragma[noinline]
  predicate illegalMergeCandidate(ClassObjectInternal cls) {
    this.legalMergeCandidateNonEmpty(cls, _, Cons(cls, _))
  }

  ClassObjectInternal bestMergeCandidate(int n) {
    exists(ClassObjectInternal head | head = this.getItem(n).getHead() |
      this.legalMergeCandidate(head) and result = head
      or
      this.illegalMergeCandidate(head) and result = this.bestMergeCandidate(n + 1)
    )
  }

  pragma[noinline]
  ClassObjectInternal bestMergeCandidate() { result = this.bestMergeCandidate(0) }

  /**
   * Gets a ClassList representing the this list of list flattened into a single list.
   * Used for old-style MRO computation.
   */
  ClassList flatten() {
    this = EmptyList() and result = Empty()
    or
    result = flatten_list(this, 0)
  }
}

private ClassList flatten_list(ClassListList list, int n) {
  need_flattening(list) and
  exists(ClassList head, ClassListList tail | pragma[only_bind_out](list) = ConsList(head, tail) |
    n = head.length() and result = tail.flatten()
    or
    result = Cons(head.getItem(n), flatten_list(pragma[only_bind_out](list), n + 1))
  )
}

/* Restrict flattening to those lists that need to be flattened */
private predicate need_flattening(ClassListList list) {
  list = list_old_style_base_mros(_)
  or
  exists(ClassListList toflatten |
    need_flattening(toflatten) and
    list = toflatten.getTail()
  )
}

private ClassList bases(ClassObjectInternal cls) { result = bases(cls, 0) }

private ClassList bases(ClassObjectInternal cls, int n) {
  result = Cons(Types::getBase(cls, n), bases(cls, n + 1))
  or
  result = Empty() and n = Types::base_count(cls)
}

private ClassListList list_of_linearization_of_bases_plus_bases(ClassObjectInternal cls) {
  result = list_of_linearization_of_bases_plus_bases(cls, 0)
}

private ClassListList list_of_linearization_of_bases_plus_bases(ClassObjectInternal cls, int n) {
  result = ConsList(bases(cls), EmptyList()) and n = Types::base_count(cls) and n > 1
  or
  exists(ClassListList partial |
    partial =
      list_of_linearization_of_bases_plus_bases(pragma[only_bind_into](cls),
        pragma[only_bind_into](n + 1)) and
    result = ConsList(Mro::newStyleMro(Types::getBase(cls, n)), partial)
  )
}

private ClassList merge_of_linearization_of_bases(ClassObjectInternal cls) {
  result = list_of_linearization_of_bases_plus_bases(cls).merge()
}

private ClassListList list_old_style_base_mros(ClassObjectInternal cls) {
  result = list_old_style_base_mros(cls, 0)
}

pragma[nomagic]
private ClassListList list_old_style_base_mros(ClassObjectInternal cls, int n) {
  n = Types::base_count(cls) and result = EmptyList()
  or
  result = ConsList(Mro::oldStyleMro(Types::getBase(cls, n)), list_old_style_base_mros(cls, n + 1))
}

/**
 * Holds if the pair `reversed_mro`, `remaining_list` represents a step in the C3 merge operation
 * of computing the C3 linearization of `original`.
 */
private predicate merge_step(
  ClassList reversed_mro, ClassListList remaining_list, ClassListList original
) {
  remaining_list = list_of_linearization_of_bases_plus_bases(_) and
  reversed_mro = Empty() and
  remaining_list = original
  or
  /* Removes the best merge candidate from `remaining_list` and prepends it to `reversed_mro` */
  exists(ClassObjectInternal head, ClassList prev_reverse_mro |
    merge_stepCons(head, prev_reverse_mro, remaining_list, original) and
    reversed_mro = Cons(head, prev_reverse_mro)
  )
  or
  merge_step(reversed_mro, ConsList(Empty(), remaining_list), original)
}

pragma[nomagic]
private predicate merge_stepCons(
  ClassObjectInternal head, ClassList prev_reverse_mro, ClassListList remaining_list,
  ClassListList original
) {
  /* Removes the best merge candidate from `remaining_list` and prepends it to `reversed_mro` */
  exists(ClassListList prev_list |
    merge_step(prev_reverse_mro, prev_list, original) and
    head = prev_list.bestMergeCandidate() and
    remaining_list = prev_list.remove(head)
  )
}

/* Helpers for `ClassList.reverse()` */
private predicate needs_reversing(ClassList lst) {
  merge_step(lst, EmptyList(), _)
  or
  lst = Empty()
}

private predicate reverse_step(ClassList lst, ClassList remainder, ClassList reversed) {
  needs_reversing(lst) and remainder = lst and reversed = Empty()
  or
  exists(ClassObjectInternal head, ClassList tail |
    reversed = Cons(head, tail) and
    reverse_stepCons(lst, remainder, head, tail)
  )
}

pragma[nomagic]
private predicate reverse_stepCons(
  ClassList lst, ClassList remainder, ClassObjectInternal head, ClassList tail
) {
  reverse_step(lst, Cons(head, remainder), tail)
}

module Mro {
  cached
  ClassList newStyleMro(ClassObjectInternal cls) {
    cls = ObjectInternal::builtin("object") and result = Cons(cls, Empty())
    or
    result = Cons(cls, merge_of_linearization_of_bases(cls))
    or
    result = Cons(cls, newStyleMro(sole_base(cls)))
  }

  cached
  ClassList oldStyleMro(ClassObjectInternal cls) {
    Types::isOldStyle(cls) and
    result = Cons(cls, list_old_style_base_mros(cls).flatten()).(ClassList).deduplicate()
  }
}
