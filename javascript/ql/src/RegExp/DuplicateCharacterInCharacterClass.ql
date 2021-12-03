/**
 * @name Duplicate character in character class
 * @description If a character class in a regular expression contains the same character twice, this may
 *              indicate a bug.
 * @kind problem
 * @problem.severity warning
 * @id js/regex/duplicate-in-character-class
 * @tags reliability
 *       correctness
 *       regular-expressions
 * @precision very-high
 */

import javascript

/**
 * Holds if `cc` is the `i`th constant inside character class `recc` that matches the character `val`.
 * Indexing is 1-based.
 */
predicate constantInCharacterClass(RegExpCharacterClass recc, int i, RegExpConstant cc, string val) {
  cc =
    rank[i](RegExpConstant cc2, int j |
      cc2 = recc.getChild(j) and cc2.isCharacter() and cc2.getValue() = val
    |
      cc2 order by j
    )
}

from RegExpCharacterClass recc, RegExpConstant first, RegExpConstant repeat, int rnk, string val
where
  constantInCharacterClass(recc, 1, first, val) and
  constantInCharacterClass(recc, rnk, repeat, val) and
  rnk > 1 and
  recc.isPartOfRegExpLiteral()
select first, "Character '" + first + "' is repeated $@ in the same character class.", repeat,
  "here"
