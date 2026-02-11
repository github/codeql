/**
 * Provides logic for representing unbound lists.
 *
 * The lists are represented internally as strings, and generally it should
 * be preferred to instead use a `newtype` representation, but in certain
 * cases where this is not feasible (typically because of performance) unbound
 * lists can be used.
 */
overlay[local?]
module;

private import Location

/** Provides the input to `Make`. */
signature module InputSig<LocationSig Location> {
  /** An element. */
  class Element {
    /** Gets a textual representation of this element. */
    string toString();

    /** Gets the location of this element. */
    Location getLocation();
  }

  /** Gets a unique ID used to identify element `e` amongst all elements. */
  int getId(Element e);

  /**
   * Gets a textual representation for element `e`, which will be used in the
   * `toString` representation for unbound lists.
   */
  default string getElementString(Element e) { result = e.toString() }

  /** Gets an optional length limit for unbound lists. */
  default int getLengthLimit() { none() }
}

final private class String = string;

/** Provides the `UnboundList` implementation. */
module Make<LocationSig Location, InputSig<Location> Input> {
  private import Input
  private import codeql.util.DenseRank

  // Use dense ranking to assign compact IDs to elements
  private module DenseRankInput implements DenseRankInputSig {
    class Ranked = Element;

    predicate getRank = getId/1;
  }

  /** Gets the rank of element `e`, which is used internally in the string encoding. */
  int getRank(Element e) { e = DenseRank<DenseRankInput>::denseRank(result) }

  private string encode(Element e) { result = getRank(e).toString() }

  bindingset[s]
  private Element decode(string s) { encode(result) = s }

  /**
   * An unbound list encoded as a string.
   */
  class UnboundList extends String {
    bindingset[this]
    UnboundList() { exists(this) }

    /** Gets the `i`th element in this list. */
    bindingset[this]
    Element getElement(int i) { result = decode(this.splitAt(".", i)) }

    /** Gets a textual representation of this list. */
    bindingset[this]
    string toString() {
      result =
        concat(int i, Element e | e = this.getElement(i) | getElementString(e), "." order by i)
    }

    /** Holds if this list is empty. */
    predicate isEmpty() { this = "" }

    bindingset[this]
    private int stringLength() { result = super.length() }

    /** Gets the length of this list. */
    bindingset[this]
    pragma[inline_late]
    int length() {
      // Same as
      // `result = count(this.indexOf("."))`
      // but performs better because it doesn't use an aggregate
      result = this.regexpReplaceAll("[0-9]+", "").length()
    }

    /** Gets the list obtained by appending `suffix` onto this list. */
    bindingset[this, suffix]
    UnboundList append(UnboundList suffix) {
      result = this + suffix and
      (
        not exists(getLengthLimit())
        or
        result.length() <= getLengthLimit()
      )
    }

    /**
     * Gets the list obtained by appending `suffix` onto this list.
     *
     * Unlike `append`, this predicate has `result` in the binding set,
     * so there is no need to check the length of `result`.
     */
    bindingset[this, result]
    UnboundList appendInverse(UnboundList suffix) { suffix = result.stripPrefix(this) }

    /** Gets the list obtained by removing `prefix` from this list. */
    bindingset[this, prefix]
    UnboundList stripPrefix(UnboundList prefix) { this = prefix + result }

    /** Holds if this list starts with `e`, followed by `suffix`. */
    bindingset[this]
    predicate isCons(Element e, UnboundList suffix) {
      exists(string elem |
        // it is more efficient to not create a capture group for the suffix, since
        // `regexpCapture` will then always join in both groups, only to afterwards filter
        // based on the requested group (the group number is not part of the binding set
        // of `regexpCapture`)
        elem = this.regexpCapture("^([0-9]+)\\..*$", 1) and
        e = decode(elem) and
        suffix = this.suffix(elem.length() + 1)
      )
    }

    /** Holds if this list starts with `prefix`, followed by `e`. */
    bindingset[this]
    predicate isSnoc(UnboundList prefix, Element e) {
      // same remark as above about not using multiple capture groups
      prefix = this.regexpCapture("^(|.+\\.)[0-9]+\\.$", 1) and
      e = decode(this.substring(prefix.stringLength(), this.stringLength() - 1))
    }

    /** Gets the head of this list, if any. */
    bindingset[this]
    Element getHead() { result = this.getElement(0) }

    /**
     * Gets the `i`th prefix of this list, if any.
     *
     * Only holds when this list is non-empty, and only returns proper prefixes.
     */
    bindingset[this]
    UnboundList getProperPrefix(int i) {
      exists(string regexp, int occurrenceOffset | regexp = "[0-9]+\\." |
        exists(this.regexpFind(regexp, i, occurrenceOffset)) and
        result = this.prefix(occurrenceOffset)
      )
    }

    /**
     * Gets a prefix of this list, if any.
     *
     * Only holds when this list is non-empty, and only returns proper prefixes.
     */
    bindingset[this]
    UnboundList getAProperPrefix() { result = this.getProperPrefix(_) }

    /**
     * Gets a prefix of this list, including the list itself.
     */
    bindingset[this]
    UnboundList getAPrefix() { result = [this, this.getAProperPrefix()] }
  }

  /** Provides predicates for constructing `UnboundList`s. */
  module UnboundList {
    /** Gets the empty list. */
    UnboundList nil() { result.isEmpty() }

    /** Gets the singleton list `e`. */
    UnboundList singleton(Element e) { result = encode(e) + "." }

    /**
     * Gets the list obtained by appending the singleton list `e`
     * onto `suffix`.
     */
    bindingset[suffix]
    UnboundList cons(Element e, UnboundList suffix) { result = singleton(e).append(suffix) }
  }
}
