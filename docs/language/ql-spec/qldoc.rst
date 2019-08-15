QLDoc specification
===================

This document is a specification for QLDoc comments in QL source files.

Notation
--------

A 'QLDoc comment' is a valid QL comment that begins with ``/**`` and ends with ``*/``.

The 'content' of a QLDoc comment is the textual body of the comment, omitting the initial ``/**``, the trailing ``*/``, and the leading whitespace followed by ``*`` on each internal line.

A QLDoc comment 'precedes' the next QL syntax element after it in the file.

Association
-----------

A QLDoc comment may be 'associated with' any of the following QL syntax elements:

-  Class declarations
-  Predicate declarations
-  Method declarations
-  Modules

For class, method, and predicate declarations, the associated QLDoc comment (if any) is the closest preceding QLDoc comment.

For modules, the associated QLDoc comment (if any) is the QLDoc comment which is the first element in the file, and moreover is not associated with any other QL element.

Inheritance
-----------

If a method has no directly associated QLDoc and overrides a set of methods which all have the same QLDoc, then the method inherits that QLDoc.

Content
-------

The content of a QLDoc comment is interpreted as standard Markdown, with the following extensions:

-  Fenced code blocks using \`s.
-  Automatic interpretation of links and email addresses.
-  Use of appropriate characters for ellipses, dashes, apostrophes, and quotes.

The content of a QLDoc comment may contain metadata tags as follows:

The tag begins with any number of whitespace characters, followed by an '@' sign. At this point there may be any number of non-whitespace characters, which form the key of the tag. Then, a single whitespace character which separates the key from the value. The value of the tag is formed by the remainder of the line, and any subsequent lines until another '@' tag is seen, or the end of the content is reached.
