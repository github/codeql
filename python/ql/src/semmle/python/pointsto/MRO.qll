/** Classes and predicates for computing the Method Resolution Order (MRO) of classes.
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
import semmle.python.pointsto.PointsTo

cached private newtype TClassList = Empty()
    or
    Cons(ClassObject head, TClassList tail) {
        required_cons(head, tail)
    }

/* Keep ClassList finite and as small as possible */
private predicate required_cons(ClassObject head, ClassList tail) {
    tail = merge_of_linearization_of_bases(head)
    or
    exists(ClassObject cls, int n |
        head = cls.getBaseType(n) and tail = bases(cls, n+1)
    )
    or
    head = theObjectType() and tail = Empty()
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
        tail = list.deduplicate(n+1)
    )
    or
    exists(ClassListList list, int n |
        head = list.getHead().getItem(n) and
        tail = flatten_list(list, n+1)
    )
    or
    tail = list_old_style_base_mros(head).flatten()
}

/** A list of classes, used to represent the MRO of a class */
class ClassList extends TClassList {

    string toString() {
        result = "[" + this.contents() + "]"
    }

    string contents() {
        this = Empty() and result = ""
        or
        exists(ClassObject head |
            head = this.getHead() |
            this.getTail() = Empty() and result = head.getName()
            or
            this.getTail() != Empty() and result = head.getName() + ", " + this.getTail().contents()
        )
    }

    int length() {
        this = Empty() and result = 0
        or
        result = this.getTail().length() + 1
    }

    ClassObject getHead() {
        this = Cons(result, _)
    }

    ClassList getTail() {
        this = Cons(_, result)
    }

    ClassObject getItem(int n) {
        n = 0 and  result = this.getHead()
        or
        result = this.getTail().getItem(n-1)
    }

    pragma [inline]
    ClassList removeHead(ClassObject cls) {
        this.getHead() = cls and result = this.getTail()
        or
        this.getHead() != cls and result = this
        or
        this = Empty() and result = Empty()
    }

    predicate legalMergeHead(ClassObject cls) {
        this.getTail().doesNotContain(cls)
        or
        this = Empty()
    }

    /** Use negative formulation for efficiency */
    predicate contains(ClassObject cls) {
        cls = this.getHead()
        or
        this.getTail().contains(cls)
    }

    /** Use negative formulation to avoid negative recursion */
    predicate doesNotContain(ClassObject cls) {
        this.relevantForContains(cls) and 
        cls != this.getHead() and 
        this.getTail().doesNotContain(cls)
        or
        this = Empty()
    }

    private predicate relevantForContains(ClassObject cls) {
        exists(ClassListList list |
            list.getItem(_).getHead() = cls and
            list.getItem(_) = this
        )
        or
        exists(ClassList l |
            l.relevantForContains(cls) and
            this = l.getTail()
        )
    }

    ClassObject findDeclaringClass(string name) {
        exists(ClassObject head |
            head = this.getHead() and
            not head = theUnknownType() |
            if head.declaresAttribute(name) then
                result = head
            else
                result = this.getTail().findDeclaringClass(name)
        )
    }

    Object lookup(string name) {
        exists(ClassObject head |
            head = this.getHead() and
            not head = theUnknownType() |
            if head.declaresAttribute(name) then
                result = head.declaredAttribute(name)
            else
                result = this.getTail().lookup(name)
        )
    }

    predicate declares(string name) {
        this.getHead().declaresAttribute(name)
        or
        this.getTail().declares(name)
    }

    ClassList startingAt(ClassObject cls) {
        exists(ClassObject head |
           head = this.getHead() |
            if head = cls then
                result = this
            else
                result = this.getTail().startingAt(cls)
        )
    }

    ClassList deduplicate() {
        result = this.deduplicate(0)
    }

    /* Helpers for `deduplicate()` */

    int firstIndex(ClassObject cls) {
        result = this.firstIndex(cls, 0)
    }

    /* Helper for firstIndex(cls), getting the first index of `cls` where result >= n */
    private int firstIndex(ClassObject cls, int n) {
        this.getItem(n) = cls and result = n
        or
        this.getItem(n) != cls and result = this.firstIndex(cls, n+1)
    }

    /** Holds if the class at `n` is a duplicate of an earlier position. */
    private predicate duplicate(int n) {
        exists(ClassObject cls |
            cls = this.getItem(n) and this.firstIndex(cls) < n
        )
    }

    /** Gets a class list which is the de-duplicated form of the list containing elements of
     * this list from `n` onwards.
     */
    ClassList deduplicate(int n) {
        n = this.length() and result = Empty()
        or
        this.duplicate(n) and result = this.deduplicate(n+1)
        or
        exists(ClassObject cls |
            n = this.firstIndex(cls) and
            result = Cons(cls, this.deduplicate(n+1))
        )
    }

    predicate isEmpty() {
        this = Empty()
    }

    ClassList reverse() {
        reverse_step(this, Empty(), result)
    }
}

private newtype TClassListList =
    EmptyList() or
    ConsList(TClassList head, TClassListList tail) {
        required_list(head, tail)
    }

/* Keep ClassListList finite and as small as possible */
private predicate required_list(ClassList head, ClassListList tail) {
    any(ClassListList x).removedClassParts(_, head, tail, _)
    or
    head = bases(_) and tail = EmptyList()
    or
    exists(ClassObject cls, int n |
        head = new_style_mro(cls.getBaseType(n)) and
        tail = list_of_linearization_of_bases_plus_bases(cls, n+1)
    )
    or
    exists(ClassObject cls, int n |
        head = old_style_mro(cls.getBaseType(n)) and
        tail = list_old_style_base_mros(cls, n+1)
    )
}

private class ClassListList extends TClassListList {

    string toString() {
        result = "[" + this.contents() + "]"
    }

    string contents() {
        this = EmptyList() and result = ""
        or
        exists(ClassList head |
            head = this.getHead() |
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

    ClassList getHead() {
        this = ConsList(result, _)
    }

    ClassListList getTail() {
        this = ConsList(_, result)
    }

    ClassList getItem(int n) {
        n = 0 and result = this.getHead()
        or
        result = this.getTail().getItem(n-1)
    }

    private ClassObject getAHead() {
        result = this.getHead().getHead()
        or
        result = this.getTail().getAHead()
    }

    pragma [nomagic]
    ClassList merge() {
        exists(ClassList reversed |
            merge_step(reversed, EmptyList(), this) and
            result = reversed.reverse()
        )
        or
        this = EmptyList() and result = Empty()
    }

    /* Join ordering helper */
    pragma [noinline]
    predicate removedClassParts(ClassObject cls, ClassList removed_head, ClassListList removed_tail, int n) {
        cls = this.bestMergeCandidate() and n = this.length()-1 and
        removed_head = this.getItem(n).removeHead(cls) and removed_tail = EmptyList()
        or
        exists(ClassList prev_head, ClassListList prev_tail |
            this.removedClassParts(cls, prev_head, prev_tail, n+1) and
            removed_head = this.getItem(n).removeHead(cls) and
            removed_tail = ConsList(prev_head, prev_tail)
        )
    }

    ClassListList remove(ClassObject cls) {
        exists(ClassList removed_head, ClassListList removed_tail |
            this.removedClassParts(cls, removed_head, removed_tail, 0) and
            result = ConsList(removed_head, removed_tail)
        )
        or
        this = EmptyList() and result = EmptyList()
    }

    predicate legalMergeCandidate(ClassObject cls, int n) {
        cls = this.getAHead() and n = this.length()
        or
        this.getItem(n).legalMergeHead(cls) and
        this.legalMergeCandidate(cls, n+1)
    }

    predicate legalMergeCandidate(ClassObject cls) {
        this.legalMergeCandidate(cls, 0)
    }

    predicate illegalMergeCandidate(ClassObject cls) {
        cls = this.getAHead() and
        this.getItem(_).getTail().contains(cls)
    }

    ClassObject bestMergeCandidate(int n) {
        exists(ClassObject head |
            head = this.getItem(n).getHead()
            |
            legalMergeCandidate(head) and result = head
            or
            illegalMergeCandidate(head) and result = this.bestMergeCandidate(n+1)
        )
    }

    ClassObject bestMergeCandidate() {
        result = this.bestMergeCandidate(0)
    }

    /** Gets a ClassList representing the this list of list flattened into a single list.
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
    exists(ClassList head, ClassListList tail |
        list = ConsList(head, tail)
        |
        n = head.length() and result = tail.flatten()
        or
        result = Cons(head.getItem(n), flatten_list(list, n+1))
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

private ClassList bases(ClassObject cls) {
    result = bases(cls, 0)
}

private ClassList bases(ClassObject cls, int n) {
    result = Cons(cls.getBaseType(n), bases(cls, n+1))
    or
    result = Empty() and n = PointsTo::Types::class_base_count(cls)
}

private ClassListList list_of_linearization_of_bases_plus_bases(ClassObject cls) {
    result = list_of_linearization_of_bases_plus_bases(cls, 0)
}

private ClassListList list_of_linearization_of_bases_plus_bases(ClassObject cls, int n) {
    result = ConsList(bases(cls), EmptyList()) and n = PointsTo::Types::class_base_count(cls)
    or
    exists(ClassListList partial |
        partial = list_of_linearization_of_bases_plus_bases(cls, n+1) and
        result = ConsList(new_style_mro(cls.getBaseType(n)), partial)
    )
}

private ClassList merge_of_linearization_of_bases(ClassObject cls) {
    result = list_of_linearization_of_bases_plus_bases(cls).merge()
}

cached ClassList new_style_mro(ClassObject cls) {
    cls = theObjectType() and result = Cons(cls, Empty())
    or
    result = Cons(cls, merge_of_linearization_of_bases(cls))
}

cached ClassList old_style_mro(ClassObject cls) {
    PointsTo::Types::is_new_style_bool(cls) = false and
    result = Cons(cls, list_old_style_base_mros(cls).flatten()).(ClassList).deduplicate()
}

private ClassListList list_old_style_base_mros(ClassObject cls) {
    result = list_old_style_base_mros(cls, 0)
}

pragma [nomagic]
private ClassListList list_old_style_base_mros(ClassObject cls, int n) {
    n = PointsTo::Types::class_base_count(cls) and result = EmptyList()
    or
    result = ConsList(old_style_mro(cls.getBaseType(n)), list_old_style_base_mros(cls, n+1))
}

/** Holds if the pair `reversed_mro`, `remaining_list` represents a step in the C3 merge operation
 * of computing the C3 linearization of `original`.
 */
private predicate merge_step(ClassList reversed_mro, ClassListList remaining_list, ClassListList original) {
    remaining_list = list_of_linearization_of_bases_plus_bases(_) and reversed_mro = Empty() and remaining_list = original
    or
    /* Removes the best merge candidate from `remaining_list` and prepends it to `reversed_mro` */
    exists(ClassObject head, ClassList prev_reverse_mro, ClassListList prev_list |
        merge_step(prev_reverse_mro, prev_list, original) and
        head = prev_list.bestMergeCandidate() and
        reversed_mro = Cons(head, prev_reverse_mro) and
        remaining_list = prev_list.remove(head)
    )
    or
    merge_step(reversed_mro, ConsList(Empty(), remaining_list), original)
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
    exists(ClassObject head, ClassList tail |
        reversed = Cons(head, tail) and
        reverse_step(lst, Cons(head, remainder), tail)
    )
}

