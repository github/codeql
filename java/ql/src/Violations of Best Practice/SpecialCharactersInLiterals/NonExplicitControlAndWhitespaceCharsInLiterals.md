## Overview

This query detects non-explicit control and whitespace characters in Java literals.
Such characters are often introduced accidentally and can be invisible or hard to recognize, leading to bugs when the actual contents of the string contain control characters.

## Recommendation

To avoid issues, use the encoded versions of control characters (e.g. ASCII `\n`, `\t`, or Unicode `U+000D`, `U+0009`).
This makes the literals (e.g. string literals) more readable, and also helps to make the surrounding code less error-prone and more maintainable.

## Example

The following examples illustrate good and bad code:

Bad:

```java
char tabulationChar = '	'; // Non compliant
String tabulationCharInsideString = "A	B";  // Non compliant
String fooZeroWidthSpacebar = "foo​bar"; // Non compliant
```

Good:

```java
char escapedTabulationChar = '\t';
String escapedTabulationCharInsideString = "A\tB";  // Compliant
String fooUnicodeSpacebar = "foo\u0020bar";  // Compliant
String foo2Spacebar = "foo  bar";  // Compliant
String foo3Spacebar = "foo   bar";  // Compliant
```

## Implementation notes

This query detects Java literals that contain reserved control characters and/or non-printable whitespace characters, such as:

- Decimal and hexidecimal representations of ASCII control characters (code points 0-8, 11, 14-31, and 127).
- Invisible characters (e.g. zero-width space, zero-width joiner).
- Unicode C0 control codes, plus the delete character (U+007F), such as:

  | Escaped Unicode | ASCII Decimal | Description               |
  | --------------- | ------------- | ------------------------- |
  | `\u0000`        | 0             | null character            |
  | `\u0001`        | 1             | start of heading          |
  | `\u0002`        | 2             | start of text             |
  | `\u0003`        | 3             | end of text               |
  | `\u0004`        | 4             | end of transmission       |
  | `\u0005`        | 5             | enquiry                   |
  | `\u0006`        | 6             | acknowledge               |
  | `\u0007`        | 7             | bell                      |
  | `\u0008`        | 8             | backspace                 |
  | `\u000B`        | 11            | vertical tab              |
  | `\u000E`        | 14            | shift out                 |
  | `\u000F`        | 15            | shift in                  |
  | `\u0010`        | 16            | data link escape          |
  | `\u0011`        | 17            | device control 1          |
  | `\u0012`        | 18            | device control 2          |
  | `\u0013`        | 19            | device control 3          |
  | `\u0014`        | 20            | device control 4          |
  | `\u0015`        | 21            | negative acknowledge      |
  | `\u0016`        | 22            | synchronous idle          |
  | `\u0017`        | 23            | end of transmission block |
  | `\u0018`        | 24            | cancel                    |
  | `\u0019`        | 25            | end of medium             |
  | `\u001A`        | 26            | substitute                |
  | `\u001B`        | 27            | escape                    |
  | `\u001C`        | 28            | file separator            |
  | `\u001D`        | 29            | group separator           |
  | `\u001E`        | 30            | record separator          |
  | `\u001F`        | 31            | unit separator            |
  | `\u007F`        | 127           | delete                    |

- Zero-width Unicode characters (e.g. zero-width space, zero-width joiner), such as:

  | Escaped Unicode | Description               |
  | --------------- | ------------------------- |
  | `\u200B`        | zero-width space          |
  | `\u200C`        | zero-width non-joiner     |
  | `\u200D`        | zero-width joiner         |
  | `\u2028`        | line separator            |
  | `\u2029`        | paragraph separator       |
  | `\u2060`        | word joiner               |
  | `\uFEFF`        | zero-width no-break space |

The following list outlines the _**explicit exclusions from query scope**_:

- any number of simple space characters (`U+0020`, ASCII 32).
- an escape character sequence (e.g. `\t`), or the Unicode equivalent (e.g. `\u0009`), for printable whitespace characters:

  | Character Sequence | Escaped Unicode | ASCII Decimal | Description     |
  | ------------------ | --------------- | ------------- | --------------- |
  | `\t`               | \u0009          | 9             | horizontal tab  |
  | `\n`               | \u000A          | 10            | line feed       |
  | `\f`               | \u000C          | 12            | form feed       |
  | `\r`               | \u000D          | 13            | carriage return |
  |                    | \u0020          | 32            | space           |

- character literals (i.e. single quotes) containing control characters.
- literals defined within "likely" test methods, such as:
  - JUnit test methods
  - methods annotated with `@Test`
  - methods of a class annotated with `@Test`
  - methods with names containing "test"

## References

- Unicode: [Unicode Control Characters](https://www.unicode.org/charts/PDF/U0000.pdf).
- Wikipedia: [Unicode C0 control codes](https://en.wikipedia.org/wiki/C0_and_C1_control_codes).
- Wikipedia: [Unicode characters with property "WSpace=yes" or "White_Space=yes"](https://en.wikipedia.org/wiki/Unicode_character_property#Whitespace).
- Java API Specification: [Java String Literals](https://docs.oracle.com/javase/tutorial/java/data/characters.html).
- Java API Specification: [Java Class Charset](https://docs.oracle.com/javase/8/docs/api///?java/nio/charset/Charset.html).
