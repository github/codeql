/*
 * Common functions for implementing naming conventions
 *
 * Naming rules are the following:
 *
 *  [45] All words in an ident will be separated by '_'
 *  [46] Idents will not rely on significance of more than 64 characters
 *  [47] Idents will not begin with '_'
 *  [48] Idents will not differ in certain confusing ways (listed)
 *  [49] All acronyms in an ident will be uppercase
 *  [50] Classes, namespaces, enums, structs, typedefs:
 *        begin first word with uppercase, all other lowercase
 *  [51] Functions and variables:
 *        lowercase
 *  [52] Constants and enum values:
 *        lowercase
 *
 * The tricky rules are: 45, 49, 50, 51, 52. There are two reasons:
 *
 *  - Reference to 'words'. We ignore this (beyond the scope). For 45,
 *    detect camel-case and any other bad conventions. For 50 this just
 *    means the first letter should be uppercase.
 *  - Acronyms. [49] has a comment that it applies to *all* identifiers,
 *    even if some other rule specified that they should be lowercase or
 *    differently capitalized.
 *
 * The strategy is as follows:
 * - apart from 45, 'words' are just _-separated parts of the identifier
 * - apart from 49, always allow a 'word' to be entirely in uppercase (URL),
 *   but make sure that the whole identifier is not in uppercase.
 * - 49: check common acronyms and allow extensibility to check that they are
 *   uppercase.
 */

import cpp

/** The name of an identifier, for the purpose of JSF naming conventions */
class Name extends string {
  Name() {
    exists(Declaration d | this = d.getName()) or
    exists(Namespace n | this = n.getName())
  }

  /**
   * Gets a word in this identifier. Words are just portions separated by underscores.
   */
  Word getAWord() { exists(int index | result = this.splitAt("_", index)) }

  /**
   * Gets the `index`th word (starting at zero) in an identifier. Words are
   * just portions separated by underscores.
   */
  Word getWord(int index) { result = this.splitAt("_", index) }
}

/** A (nonempty) word in an identifier, for JSF naming conventions */
class Word extends string {
  Word() { exists(Name n | this = n.splitAt("_") and this != "") }

  /**
   * Gets the 0-based position of this word in the identifier.
   */
  int getIndex() { exists(Name n | this = n.getWord(result)) }

  /**
   * Holds if this word is capitalized (for example 'Word', not 'word'
   * or 'WORD').
   */
  predicate isCapitalized() {
    this.prefix(1).isUppercase() and
    this.suffix(1).isLowercase()
  }

  /**
   * Holds if this word looks like an acronym, and is written entirely
   * in uppercase. This is a permissive heuristic; anything that could
   * just possibly be an acronym is included.
   *
   * It is there for the purpose of excluding acronyms from other rules.
   */
  predicate couldBeUppercaseAcronym() {
    // 1-letter acronyms do not make sense
    this.length() > 1 and
    // few acronyms are more than 5 characters long...
    this.length() <= 5 and
    // Must be uppercase
    this.isUppercase()
  }

  /**
   * Holds if this word is definitely an acronym. This is the dual of
   * `couldBeUppercaseAcronym` - it underestimates rather than overestimates.
   */
  predicate isDefiniteAcronym() {
    // Don't look at case
    exists(string s | s = this.toLowerCase() |
      // A few standard acronyms
      s = "url" or
      s = "http" or
      s = "html"
      // //
      // // CUSTOMIZATION:
      // // ANY ACRONYMS TO ENFORCE IN A PROJECT CAN BE ADDED HERE
      // //
      // eg. 'or s = "myacronym"'
    )
  }
}
