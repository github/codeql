:tocdepth: 1

.. _lexical-syntax:

Lexical syntax
##############

The QL syntax includes different kinds of keywords, identifiers, and comments.

For an overview of the lexical syntax, see "`Lexical syntax 
<https://codeql.github.com/docs/ql-language-reference/ql-language-specification/#lexical-syntax>`_" in the QL language specification.

.. index:: comment, QLDoc
.. _comments:

Comments
********

All standard one-line and multiline comments are ignored by the QL 
compiler and are only visible in the source code.
You can also write another kind of comment, namely **QLDoc comments**. These comments describe
QL entities and are displayed as pop-up information in QL editors.

The following example uses these three different kinds of comments:

.. code-block:: ql

    /**
     * A QLDoc comment that describes the class `Digit`.
     */
    class Digit extends int {  // A short one-line comment
      Digit() {
        this in [0 .. 9]
      }
    }

    /* 
      A standard multiline comment, perhaps to provide 
      additional details, or to write a TODO comment.
    */
