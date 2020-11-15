.. _qldoc-comment-specification:

QLDoc comment specification
===========================

This document is a formal specification for QLDoc comments.

About QLDoc comments
--------------------

You can provide documentation for a QL entity by adding a QLDoc comment in the source file. The QLDoc comment is displayed as pop-up information in QL editors, for example when you hover over a predicate name.

Notation
--------

A 'QLDoc comment' is a valid QL comment that begins with ``/**`` and ends with ``*/``.

The 'content' of a QLDoc comment is the textual body of the comment, omitting the initial ``/**``, the trailing ``*/``, and the leading whitespace followed by ``*`` on each internal line.

A QLDoc comment 'precedes' the next QL syntax element after it in the file.

Association
-----------

A QLDoc comment may be 'associated with' any of the following QL syntax elements:

-  Class declarations
-  Non-member predicate declarations
-  Member predicate declarations
-  Modules

For class and predicate declarations, the associated QLDoc comment (if any) is the closest preceding QLDoc comment.

For modules, the associated QLDoc comment (if any) is the QLDoc comment which is the first element in the file, and moreover is not associated with any other QL element.

Inheritance
-----------

If a member predicate has no directly associated QLDoc and overrides a set of member predicates which all have the same QLDoc, then the member predicate inherits that QLDoc.

Content
-------

The content of a QLDoc comment is interpreted as standard Markdown, with the following extensions:

-  Fenced code blocks using backticks.
-  Automatic interpretation of links and email addresses.
-  Use of appropriate characters for ellipses, dashes, apostrophes, and quotes.

The content of a QLDoc comment may contain metadata tags as follows:

The tag begins with any number of whitespace characters, followed by an ``@`` sign. At this point there may be any number of non-whitespace characters, which form the key of the tag. Then, a single whitespace character which separates the key from the value. The value of the tag is formed by the remainder of the line, and any subsequent lines until another ``@`` tag is seen, or the end of the content is reached.
