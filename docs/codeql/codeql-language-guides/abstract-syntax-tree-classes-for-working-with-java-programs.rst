.. _abstract-syntax-tree-classes-for-working-with-java-programs:

Abstract syntax tree classes for working with Java programs
===========================================================

CodeQL has a large selection of classes for representing the abstract syntax tree of Java programs.

.. include:: ../reusables/abstract-syntax-tree.rst

Statement classes
-----------------

This table lists all subclasses of `Stmt`_.

+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
|                                  Statement syntax                                  |          CodeQL class           |          Superclasses           |                  Remarks                   |
+====================================================================================+=================================+=================================+============================================+
| ``;``                                                                              | EmptyStmt_                      |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| `Expr`_ ``;``                                                                      | ExprStmt_                       |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``{`` `Stmt`_  ``... }``                                                           | BlockStmt_                      |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``if (`` `Expr`_ ``)`` `Stmt`_  ``else`` `Stmt`_                                   | IfStmt_                         | `ConditionalStmt`_              |                                            |
+------------------------------------------------------------------------------------+                                 |                                 |                                            |
| ``if (`` `Expr`_ ``)`` `Stmt`_                                                     |                                 |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``while (`` `Expr`_ ``)`` `Stmt`_                                                  | WhileStmt_                      | `ConditionalStmt`_, `LoopStmt`_ |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``do`` `Stmt`_  ``while (`` `Expr`_ ``)``                                          | DoStmt_                         | `ConditionalStmt`_, `LoopStmt`_ |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``for (`` `Expr`_ ``;`` `Expr`_ ``;`` `Expr`_ ``)`` `Stmt`_                        | ForStmt_                        | `ConditionalStmt`_, `LoopStmt`_ |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``for (`` `VarAccess`_ ``:`` `Expr`_ ``)`` `Stmt`_                                 | EnhancedForStmt_                | `LoopStmt`_                     |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``switch (`` `Expr`_ ``) {`` `SwitchCase`_ ``... }``                               | SwitchStmt_                     |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``try {`` `Stmt`_  ``... } finally {`` `Stmt`_  ``... }``                          | TryStmt_                        |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``return`` `Expr`_ ``;``                                                           | ReturnStmt_                     |                                 |                                            |
+------------------------------------------------------------------------------------+                                 |                                 |                                            |
| ``return ;``                                                                       |                                 |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``throw`` `Expr`_ ``;``                                                            | ThrowStmt_                      |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``break ;``                                                                        | BreakStmt_                      | `JumpStmt`_                     |                                            |
+------------------------------------------------------------------------------------+                                 |                                 |                                            |
| ``break label ;``                                                                  |                                 |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``continue ;``                                                                     | ContinueStmt_                   | `JumpStmt`_                     |                                            |
+------------------------------------------------------------------------------------+                                 |                                 |                                            |
| ``continue label ;``                                                               |                                 |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``label :`` `Stmt`_                                                                | LabeledStmt_                    |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``synchronized (`` `Expr`_ ``)`` `Stmt`_                                           | SynchronizedStmt_               |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``assert`` `Expr`_ ``:`` `Expr`_ ``;``                                             | AssertStmt_                     |                                 |                                            |
+------------------------------------------------------------------------------------+                                 |                                 |                                            |
| ``assert`` `Expr`_ ``;``                                                           |                                 |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| `TypeAccess`_ ``name ;``                                                           | LocalVariableDeclStmt_          |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``class name {`` `Member`_ ``... } ;``                                             | LocalClassDeclStmt_             |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``this (`` `Expr`_ ``, ... ) ;``                                                   | ThisConstructorInvocationStmt_  |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``super (`` `Expr`_ ``, ... ) ;``                                                  | SuperConstructorInvocationStmt_ |                                 |                                            |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``catch (`` `TypeAccess`_ ``name ) {`` `Stmt`_  ``... }``                          | CatchClause_                    |                                 | can only occur as child of a `TryStmt`_    |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``case`` `Literal`_ ``:`` `Stmt`_  ``...``                                         | ConstCase_                      |                                 | can only occur as child of a `SwitchStmt`_ |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+
| ``default :`` `Stmt`_  ``...``                                                     | DefaultCase_                    |                                 | can only occur as child of a `SwitchStmt`_ |
+------------------------------------------------------------------------------------+---------------------------------+---------------------------------+--------------------------------------------+

Expression classes
------------------

There are many expression classes, so we present them by category. All classes in this section are subclasses of Expr_.

Literals
~~~~~~~~

All classes in this subsection are subclasses of Literal_.

+---------------------------+-------------------------+
| Expression syntax example |      CodeQL class       |
+===========================+=========================+
| ``true``                  | `BooleanLiteral`_       |
+---------------------------+-------------------------+
| ``23``                    | `IntegerLiteral`_       |
+---------------------------+-------------------------+
| ``23l``                   | `LongLiteral`_          |
+---------------------------+-------------------------+
| ``4.2f``                  | `FloatingPointLiteral`_ |
+---------------------------+-------------------------+
| ``4.2``                   | `DoubleLiteral`_        |
+---------------------------+-------------------------+
| ``'a'``                   | `CharacterLiteral`_     |
+---------------------------+-------------------------+
| ``"Hello"``               | `StringLiteral`_        |
+---------------------------+-------------------------+
| ``null``                  | `NullLiteral`_          |
+---------------------------+-------------------------+

Unary expressions
~~~~~~~~~~~~~~~~~

All classes in this subsection are subclasses of UnaryExpr_.

+-------------------+----------------+--------------------+--------------------------------------------------+
| Expression syntax |  CodeQL class  |    Superclasses    |                     Remarks                      |
+===================+================+====================+==================================================+
| `Expr`_\ ``++``   | `PostIncExpr`_ | `UnaryAssignExpr`_ |                                                  |
+-------------------+----------------+--------------------+--------------------------------------------------+
| `Expr`_\ ``--``   | `PostDecExpr`_ | `UnaryAssignExpr`_ |                                                  |
+-------------------+----------------+--------------------+--------------------------------------------------+
| ``++``\ `Expr`_   | `PreIncExpr`_  | `UnaryAssignExpr`_ |                                                  |
+-------------------+----------------+--------------------+--------------------------------------------------+
| ``--``\ `Expr`_   | `PreDecExpr`_  | `UnaryAssignExpr`_ |                                                  |
+-------------------+----------------+--------------------+--------------------------------------------------+
| ``~``\ `Expr`_    | `BitNotExpr`_  | `BitwiseExpr`_     | see below for other subclasses of `BitwiseExpr`_ |
+-------------------+----------------+--------------------+--------------------------------------------------+
| ``-``\ `Expr`_    | `MinusExpr`_   |                    |                                                  |
+-------------------+----------------+--------------------+--------------------------------------------------+
| ``+``\ `Expr`_    | `PlusExpr`_    |                    |                                                  |
+-------------------+----------------+--------------------+--------------------------------------------------+
| ``!``\ `Expr`_    | `LogNotExpr`_  | `LogicExpr`_       | see below for other subclasses of `LogicExpr`_   |
+-------------------+----------------+--------------------+--------------------------------------------------+

Binary expressions
~~~~~~~~~~~~~~~~~~

All classes in this subsection are subclasses of BinaryExpr_.

+-------------------------+-------------------+-------------------+
|    Expression syntax    |   CodeQL class    |   Superclasses    |
+=========================+===================+===================+
| `Expr`_ ``*`` `Expr`_   | `MulExpr`_        |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``/`` `Expr`_   | `DivExpr`_        |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``%`` `Expr`_   | `RemExpr`_        |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``+`` `Expr`_   | `AddExpr`_        |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``-`` `Expr`_   | `SubExpr`_        |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``<<`` `Expr`_  | `LShiftExpr`_     |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``>>`` `Expr`_  | `RShiftExpr`_     |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``>>>`` `Expr`_ | `URShiftExpr`_    |                   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``&&`` `Expr`_  | `AndLogicalExpr`_ | `LogicExpr`_      |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``||``  `Expr`_ | `OrLogicalExpr`_  | `LogicExpr`_      |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``<`` `Expr`_   | `LTExpr`_         | `ComparisonExpr`_ |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``>`` `Expr`_   | `GTExpr`_         | `ComparisonExpr`_ |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``<=`` `Expr`_  | `LEExpr`_         | `ComparisonExpr`_ |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``>=`` `Expr`_  | `GEExpr`_         | `ComparisonExpr`_ |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``==`` `Expr`_  | `EQExpr`_         | `EqualityTest`_   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``!=`` `Expr`_  | `NEExpr`_         | `EqualityTest`_   |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``&`` `Expr`_   | `AndBitwiseExpr`_ | `BitwiseExpr`_    |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``|`` `Expr`_   | `OrBitwiseExpr`_  | `BitwiseExpr`_    |
+-------------------------+-------------------+-------------------+
| `Expr`_ ``^`` `Expr`_   | `XorBitwiseExpr`_ | `BitwiseExpr`_    |
+-------------------------+-------------------+-------------------+

Assignment expressions
~~~~~~~~~~~~~~~~~~~~~~

All classes in this table are subclasses of Assignment_.

+--------------------------+----------------------+-----------------+
|    Expression syntax     |     CodeQL class     |  Superclasses   |
+==========================+======================+=================+
| `Expr`_ ``=`` `Expr`_    | `AssignExpr`_        |                 |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``+=`` `Expr`_   | `AssignAddExpr`_     | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``-=`` `Expr`_   | `AssignSubExpr`_     | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``*=`` `Expr`_   | `AssignMulExpr`_     | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``/=`` `Expr`_   | `AssignDivExpr`_     | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``%=`` `Expr`_   | `AssignRemExpr`_     | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``&=`` `Expr`_   | `AssignAndExpr`_     | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``|=`` `Expr`_   | `AssignOrExpr`_      | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``^=`` `Expr`_   | `AssignXorExpr`_     | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``<<=`` `Expr`_  | `AssignLShiftExpr`_  | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``>>=`` `Expr`_  | `AssignRShiftExpr`_  | `AssignOp`_     |
+--------------------------+----------------------+-----------------+
| `Expr`_ ``>>>=`` `Expr`_ | `AssignURShiftExpr`_ | `AssignOp`_     |
+--------------------------+----------------------+-----------------+

Accesses
~~~~~~~~

+--------------------------------+---------------------+
|   Expression syntax examples   |    CodeQL class     |
+================================+=====================+
| ``this``                       | ThisAccess_         |
+--------------------------------+                     |
| ``Outer.this``                 |                     |
+--------------------------------+---------------------+
| ``super``                      | SuperAccess_        |
+--------------------------------+                     |
| ``Outer.super``                |                     |
+--------------------------------+---------------------+
| ``x``                          | VarAccess_          |
+--------------------------------+                     |
| ``e.f``                        |                     |
+--------------------------------+---------------------+
| ``a[i]``                       | ArrayAccess_        |
+--------------------------------+---------------------+
| ``f(...)``                     | MethodAccess_       |
+--------------------------------+                     |
| ``e.m(...)``                   |                     |
+--------------------------------+---------------------+
| ``String``                     | TypeAccess_         |
+--------------------------------+                     |
| ``java.lang.String``           |                     |
+--------------------------------+---------------------+
| ``? extends Number``           | WildcardTypeAccess_ |
+--------------------------------+                     |
| ``? super Double``             |                     |
+--------------------------------+---------------------+

A VarAccess_ that refers to a field is a FieldAccess_.

Miscellaneous
~~~~~~~~~~~~~

+-------------------------------------+--------------------+----------------------------------------------------------------------------+
|     Expression syntax examples      |    CodeQL class    | Remarks                                                                    |
+=====================================+====================+============================================================================+
| ``(int) f``                         | CastExpr_          |                                                                            |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+
| ``o instanceof String``             | InstanceOfExpr_    |                                                                            |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+
| `Expr`_ ``?`` `Expr`_ ``:`` `Expr`_ | ConditionalExpr_   |                                                                            |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+
| ``String. class``                   | TypeLiteral_       |                                                                            |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+
| ``new A()``                         | ClassInstanceExpr_ |                                                                            |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+
| ``new String[3][2]``                | ArrayCreationExpr_ |                                                                            |
+-------------------------------------+                    |                                                                            |                                          
| ``new int[] { 23, 42 }``            |                    |                                                                            |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+
| ``{ 23, 42 }``                      | ArrayInit_         | can only appear as an initializer or as a child of an `ArrayCreationExpr`_ |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+
| ``@Annot(key=val)``                 | Annotation_        |                                                                            |
+-------------------------------------+--------------------+----------------------------------------------------------------------------+

Further reading
---------------

.. include:: ../reusables/java-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst

.. Links used in tables. For information about using these links, see
   https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#hyperlinks.

.. _Expr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$Expr.html
.. _Stmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$Stmt.html
.. _VarAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$VarAccess.html
.. _SwitchCase: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$SwitchCase.html
.. _TypeAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$TypeAccess.html
.. _Member: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Member.qll/type.Member$Member.html
.. _Literal: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$Literal.html
.. _ConditionalStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ConditionalStmt.html
.. _LoopStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$LoopStmt.html
.. _JumpStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$JumpStmt.html
.. _TryStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$TryStmt.html
.. _SwitchStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$SwitchStmt.html
.. _BooleanLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$BooleanLiteral.html
.. _IntegerLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$IntegerLiteral.html
.. _LongLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$LongLiteral.html
.. _FloatingPointLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$FloatingPointLiteral.html
.. _DoubleLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$DoubleLiteral.html
.. _CharacterLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$CharacterLiteral.html
.. _StringLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$StringLiteral.html
.. _NullLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$NullLiteral.html
.. _PostIncExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$PostIncExpr.html
.. _PostDecExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$PostDecExpr.html
.. _PreIncExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$PreIncExpr.html
.. _PreDecExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$PreDecExpr.html
.. _BitNotExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$BitNotExpr.html
.. _MinusExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$MinusExpr.html
.. _PlusExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$PlusExpr.html
.. _LogNotExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$LogNotExpr.html
.. _UnaryAssignExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$UnaryAssignExpr.html
.. _BitwiseExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$BitwiseExpr.html
.. _LogicExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$LogicExpr.html
.. _MulExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$MulExpr.html
.. _DivExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$DivExpr.html
.. _RemExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$RemExpr.html
.. _AddExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AddExpr.html
.. _SubExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$SubExpr.html
.. _LShiftExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$LShiftExpr.html
.. _RShiftExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$RShiftExpr.html
.. _URShiftExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$URShiftExpr.html
.. _AndLogicalExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AndLogicalExpr.html
.. _OrLogicalExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$OrLogicalExpr.html
.. _LTExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$LTExpr.html
.. _GTExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$GTExpr.html
.. _LEExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$LEExpr.html
.. _GEExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$GEExpr.html
.. _EQExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$EQExpr.html
.. _NEExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$NEExpr.html
.. _AndBitwiseExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AndBitwiseExpr.html
.. _OrBitwiseExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$OrBitwiseExpr.html
.. _XorBitwiseExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$XorBitwiseExpr.html
.. _ComparisonExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$ComparisonExpr.html
.. _EqualityTest: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$EqualityTest.html
.. _AssignExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignExpr.html
.. _AssignAddExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignAddExpr.html
.. _AssignSubExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignSubExpr.html
.. _AssignMulExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignMulExpr.html
.. _AssignDivExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignDivExpr.html
.. _AssignRemExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignRemExpr.html
.. _AssignAndExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignAndExpr.html
.. _AssignOrExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignOrExpr.html
.. _AssignXorExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignXorExpr.html
.. _AssignLShiftExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignLShiftExpr.html
.. _AssignRShiftExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignRShiftExpr.html
.. _AssignURShiftExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignURShiftExpr.html
.. _AssignOp: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$AssignOp.html
.. _ArrayCreationExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$ArrayCreationExpr.html
.. _EmptyStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$EmptyStmt.html
.. _ExprStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ExprStmt.html
.. _BlockStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$BlockStmt.html
.. _IfStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$IfStmt.html
.. _WhileStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$WhileStmt.html
.. _DoStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$DoStmt.html
.. _ForStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ForStmt.html
.. _EnhancedForStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$EnhancedForStmt.html
.. _ReturnStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ReturnStmt.html
.. _ThrowStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ThrowStmt.html
.. _BreakStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$BreakStmt.html
.. _ContinueStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ContinueStmt.html
.. _LabeledStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$LabeledStmt.html
.. _SynchronizedStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$SynchronizedStmt.html
.. _AssertStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$AssertStmt.html
.. _LocalVariableDeclStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$LocalVariableDeclStmt.html
.. _LocalClassDeclStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$LocalClassDeclStmt.html
.. _ThisConstructorInvocationStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ThisConstructorInvocationStmt.html
.. _SuperConstructorInvocationStmt: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$SuperConstructorInvocationStmt.html
.. _CatchClause: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$CatchClause.html
.. _ConstCase: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$ConstCase.html
.. _DefaultCase: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Statement.qll/type.Statement$DefaultCase.html
.. _UnaryExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$UnaryExpr.html
.. _BinaryExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$BinaryExpr.html
.. _Assignment: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$Assignment.html
.. _ThisAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$ThisAccess.html
.. _SuperAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$SuperAccess.html
.. _ArrayAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$ArrayAccess.html
.. _MethodAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$MethodAccess.html
.. _WildcardTypeAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$WildcardTypeAccess.html
.. _FieldAccess: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$FieldAccess.html
.. _CastExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$CastExpr.html
.. _InstanceOfExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$InstanceOfExpr.html
.. _ConditionalExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$ConditionalExpr.html
.. _TypeLiteral: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$TypeLiteral.html
.. _ClassInstanceExpr: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$ClassInstanceExpr.html
.. _ArrayInit: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Expr.qll/type.Expr$ArrayInit.html
.. _Annotation: https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/Annotation.qll/type.Annotation$Annotation.html