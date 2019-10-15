.. _lexical-syntax:

Lexical syntax
##############

For an overview of the lexical syntax, see `Lexical syntax 
<https://help.semmle.com/QL/ql-spec/language.html#lexical-syntax>`_
in the QL language specification. In particular, you can find the list of QL keywords, the
different kinds of identifiers, and a description of comments.

.. index:: comment, QLDoc
.. _comments:

Comments
********

All standard one-line and multiline comments, as described in the `QL language specification 
<https://help.semmle.com/QL/ql-spec/language.html#comments>`_, are ignored by the QL 
compiler and are only visible in the source code.
You can also write another kind of comment, namely **QLDoc comments**. These comments describe
QL entities and are displayed as pop-up information in QL editors. For information about QLDoc
comments, see the `QLDoc specification <https://help.semmle.com/QL/QLDocSpecification.html>`_.

The following example uses these three different kinds of comments::

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
