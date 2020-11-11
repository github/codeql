.. _lexical-syntax:

Lexical syntax
##############

The QL syntax includes different kinds of keywords, identifiers, and comments.

For an overview of the lexical syntax, see "`Lexical syntax 
<ql-language-specification#lexical-syntax>`_" in the QL language specification.

.. index:: comment, QLDoc
.. _comments:

Comments
********

All standard one-line and multiline comments, as described in the "`QL language specification 
<ql-language-specification#comments>`_," are ignored by the QL 
compiler and are only visible in the source code.
You can also write another kind of comment, namely **QLDoc comments**. These comments describe
QL entities and are displayed as pop-up information in QL editors. For information about QLDoc
comments, see the ":doc:`QLDoc comment specification <qldoc-comment-specification>`."

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
