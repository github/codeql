.. _abstract-syntax-tree-classes-for-working-with-ruby-programs:

Abstract syntax tree classes for working with Ruby programs
===========================================================

CodeQL has a large selection of classes for representing the abstract syntax tree of Ruby programs.

.. include:: ../reusables/abstract-syntax-tree.rst

An ``IDENTIFIER`` should match the regular expression ``/[a-zA-Z_][a-zA-Z0-9_]*/``. A ``CNAME`` should match ``/[A-Z][a-zA-Z0-9_]*/``.

Statement classes
~~~~~~~~~~~~~~~~~

This table lists subclasses of Stmt_ representing Ruby statements.

..
  TODO: FNAME definition

+------------------------------------------------+--------------+----------------+---------+
| Statement syntax                               | CodeQL class | Superclasses   | Remarks |
+================================================+==============+================+=========+
| ``alias`` FNAME FNAME                          | AliasStmt_   | Stmt_          |         |
+------------------------------------------------+--------------+----------------+---------+
| ``BEGIN {`` StmtSequence_ ``}``                | BeginBlock_  | StmtSequence_  |         |
+------------------------------------------------+--------------+----------------+---------+
| ``begin`` StmtSequence_ ``end``                | BeginExpr_   | StmtSequence_  |         |
+------------------------------------------------+--------------+----------------+---------+
| ``break`` [Expr_]                              | BreakStmt_   | ReturningStmt_ |         |
+------------------------------------------------+--------------+----------------+---------+
| ``;``                                          | EmptyStmt_   | Stmt_          |         |
+------------------------------------------------+--------------+----------------+---------+
| ``END {`` StmtSequence_ ``}``                  | EndBlock_    | StmtSequence_  |         |
+------------------------------------------------+--------------+----------------+---------+
| ``next`` [Expr_]                               | NextStmt_    | ReturningStmt_ |         |
+------------------------------------------------+--------------+----------------+---------+
| ``redo``                                       | RedoStmt_    | Stmt_          |         |
+------------------------------------------------+--------------+----------------+---------+
| ``retry``                                      | RetryStmt_   | Stmt_          |         |
+------------------------------------------------+--------------+----------------+---------+
| ``return`` [Expr_]                             | ReturnStmt_  | ReturningStmt_ |         |
+------------------------------------------------+--------------+----------------+---------+
| ``undef`` FNAME (, FNAME)                      | UndefStmt_   | Stmt_          |         |
+------------------------------------------------+--------------+----------------+---------+

Calls
~~~~~

+-------------------------+---------------------+----------------+-------------------------------+
| Expression syntax       | CodeQL class        | Superclasses   | Remarks                       |
+=========================+=====================+================+===============================+
| Expr_ ``[`` Expr_ ``]`` | ElementReference_   | MethodCall_    |                               |
+-------------------------+---------------------+----------------+-------------------------------+
| MethodName_ (, Expr_)   | MethodCall_         | Call_          |                               |
+-------------------------+---------------------+----------------+-------------------------------+
| LhsExpr_ ``=`` Expr_    | SetterMethodCall_   | MethodCall_    |                               |
+-------------------------+---------------------+----------------+-------------------------------+
| ``super``               | SuperCall_          | MethodCall_    |                               |
+-------------------------+---------------------+----------------+-------------------------------+
| ``yield`` (, Expr_)     | YieldCall_          | Call_          |                               |
+-------------------------+---------------------+----------------+-------------------------------+
| ``&IDENTIFIER``         | BlockArgument_      | Expr_          | Used as an argument to a call |
+-------------------------+---------------------+----------------+-------------------------------+
| ``...``                 | ForwardedArguments_ | Expr_          | Used as an argument to a call |
+-------------------------+---------------------+----------------+-------------------------------+

Constant accesses
~~~~~~~~~~~~~~~~~

All classes in this subsection are subclasses of ConstantAccess_.

+----------------------------------------+----------------------+----------------------+-------------------+
| Expression syntax                      | CodeQL class         | Superclasses         | Remarks           |
+========================================+======================+======================+===================+
| CNAME                                  | ConstantReadAccess_  | ConstantAccess_      |                   |
+----------------------------------------+----------------------+----------------------+-------------------+
| ``class`` CNAME StmtSequence_ ``end``  | ConstantWriteAccess_ | ConstantAccess_      | class definition  |
+----------------------------------------+----------------------+----------------------+-------------------+
| ``module`` CNAME StmtSequence_ ``end`` | ConstantWriteAccess_ | ConstantAccess_      | module definition |
+----------------------------------------+----------------------+----------------------+-------------------+
| CNAME ``=`` Expr_                      | ConstantAssignment_  | ConstantWriteAccess_ |                   |
+----------------------------------------+----------------------+----------------------+-------------------+

Control expressions
~~~~~~~~~~~~~~~~~~~

All classes in this subsection are subclasses of ControlExpr_.

+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| Expression syntax                                                                                                             | CodeQL class        | Superclasses                   | Remarks |
+===============================================================================================================================+=====================+================================+=========+
| ``if`` Expr_ ``then`` StmtSequence_ {``elsif`` Expr_ ``then`` StmtSequence_} [``else`` StmtSequence_] ``end``                 | IfExpr_             | ConditionalExpr_, ControlExpr_ |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| ``while`` Expr_ ``do`` StmtSequence_ ``end``                                                                                  | WhileExpr_          | ConditionalLoop_               |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| ``until`` Expr_ ``do`` StmtSequence_ ``end``                                                                                  | UntilExpr_          | ConditionalLoop_               |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| ``for`` LhsExpr_ ``in`` Expr_ ``do`` StmtSequence_ ``end``                                                                    | ForExpr_            | Loop_                          |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| Stmt_ ``while`` Expr_                                                                                                         | WhileModifierExpr_  | ConditionalLoop_               |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| Stmt_ ``until`` Expr_                                                                                                         | UntilModifierExpr_  | ConditionalLoop_               |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| Stmt_ ``if`` Expr_                                                                                                            | IfModifierExpr_     | ConditionalExpr_, ControlExpr_ |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| Stmt_ ``unless`` Expr_                                                                                                        | UnlessModifierExpr_ | ConditionalExpr_, ControlExpr_ |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| Expr_ ``?`` Stmt_ ``:`` Stmt_                                                                                                 | TernaryIfExpr_      | ConditionalExpr_, ControlExpr_ |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| ``case`` Expr_ ``when`` Expr_ ``then`` StmtSequence_ {``when`` Expr_ ``then`` StmtSequence_} [``else`` StmtSequence_] ``end`` | CaseExpr_           | ControlExpr_                   |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+
| ``case when`` Expr_ ``then`` StmtSequence_ [``else`` StmtSequence_] ``end``                                                   | CaseExpr_           | ControlExpr_                   |         |
+-------------------------------------------------------------------------------------------------------------------------------+---------------------+--------------------------------+---------+


Unary operations
~~~~~~~~~~~~~~~~

All classes in this subsection are subclasses of UnaryOperation_.

+--------------------+----------------+----------------------------+-------------------+
| Expression syntax  |  CodeQL class  | Superclasses               | Remarks           |
+====================+================+============================+===================+
| ``~`` Expr_        | ComplementExpr_ | UnaryBitwiseOperation_    |                   |
+--------------------+----------------+----------------------------+-------------------+
| ``defined?`` Expr_ | DefinedExpr_    | UnaryOperation_           |                   |
+--------------------+----------------+----------------------------+-------------------+
| ``**`` Expr_       | HashSplatExpr_  | UnaryOperation_           |                   |
+--------------------+----------------+----------------------------+-------------------+
| ``!`` Expr_        | NotExpr_        | UnaryOperation_           |                   |
+--------------------+----------------+----------------------------+-------------------+
| ``not`` Expr_      | NotExpr_        | UnaryOperation_           |                   |
+--------------------+----------------+----------------------------+-------------------+
| ``*`` Expr_        | SplatExpr_      | UnaryOperation_           |                   |
+--------------------+----------------+----------------------------+-------------------+
| ``-`` Expr_        | UnaryMinusExpr_ | UnaryArithmeticOperation_ |                   |
+--------------------+----------------+----------------------------+-------------------+
| ``+`` Expr_        | UnaryPlusExpr_  | UnaryArithmeticOperation_ |                   |
+--------------------+----------------+----------------------------+-------------------+

Binary operations
~~~~~~~~~~~~~~~~~

All classes in this subsection are subclasses of BinaryOperation_.

+------------------------+--------------------------+----------------------------+-------------------+
| Expression syntax      |  CodeQL class            | Superclasses               | Remarks           |
+========================+==========================+============================+===================+
| Expr_ ``+`` Expr_      | AddExpr_                 | BinaryArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``+=`` Expr_  | AssignAddExpr_           | AssignArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``&=`` Expr_  | AssignBitwiseAndExpr_    | AssignBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``|=`` Expr_  | AssignBitwiseOrExpr_     | AssignBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``^=`` Expr_  | AssignBitwiseXorExpr_    | AssignBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``/=`` Expr_  | AssignDivExpr_           | AssignArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``**=`` Expr_ | AssignExponentExpr_      | AssignArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``<<=`` Expr_ | AssignLShiftExpr_        | AssignBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``&&=`` Expr_ | AssignLogicalAndExpr_    | BinaryLogicalOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``||=`` Expr_ | AssignLogicalOrExpr_     | BinaryLogicalOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``%=`` Expr_  | AssignModuloExpr_        | AssignArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``*=`` Expr_  | AssignMulExpr_           | AssignArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``>>=`` Expr_ | AssignRShiftExpr_        | AssignBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| LhsExpr_ ``-=`` Expr_  | AssignSubExpr_           | AssignArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``&`` Expr_      | BitwiseAndExpr_          | BinaryBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``|`` Expr_      | BitwiseOrExpr_           | BinaryBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``^`` Expr_      | BitwiseXorExpr_          | BinaryBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``===`` Expr_    | CaseEqExpr_              | EqualityOperation_         |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``/`` Expr_      | DivExpr_                 | BinaryArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``===`` Expr_    | EqExpr_                  | EqualityOperation_         |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``^`` Expr_      | ExponentExpr_            | BinaryArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``>=`` Expr_     | GEExpr_                  | RelationalOperation_       |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``>`` Expr_      | GTExpr_                  | RelationalOperation_       |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``<=`` Expr_     | LEExpr_                  | RelationalOperation_       |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``<<`` Expr_     | LShiftExpr_              | BinaryBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``<`` Expr_      | LTExpr_                  | RelationalOperation_       |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``&&`` Expr_     | LogicalAndExpr_          | BinaryLogicalOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``and`` Expr_    | LogicalAndExpr_          | BinaryLogicalOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``||`` Expr_     | LogicalOrExpr_           | BinaryLogicalOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``or`` Expr_     | LogicalOrExpr_           | BinaryLogicalOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``%`` Expr_      | ModuloExpr_              | BinaryArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``*`` Expr_      | MulExpr_                 | BinaryArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``!=`` Expr_     | NEExpr_                  | RelationalOperation_       |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``!~`` Expr_     | NoRegExpMatchExpr_       | BinaryOperation_           |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``>>`` Expr_     | RShiftExpr_              | BinaryBitwiseOperation_    |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``=~`` Expr_     | RegExpMatchExpr_         | BinaryOperation_           |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``<=>`` Expr_    | SpaceshipExpr_           | BinaryOperation_           |                   |
+------------------------+--------------------------+----------------------------+-------------------+
| Expr_ ``-`` Expr_      | SubExpr_                 | BinaryArithmeticOperation_ |                   |
+------------------------+--------------------------+----------------------------+-------------------+

Literals
~~~~~~~~

All classes in this subsection are subclasses of Literal_.

+----------------------------+-------------------+----------------------------+-------------------+
| Example expression syntax  |  CodeQL class     | Superclasses               | Remarks           |
+============================+===================+============================+===================+
| ``[1, 2]``                 | ArrayLiteral_     | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``true``                   | BooleanLiteral_   | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``?a``                     | CharacterLiteral_ | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``__ENCODING__``           | EncodingLiteral_  | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``__FILE__``               | FileLiteral_      | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``{ foo: 123, bar: 456 }`` | HashLiteral_      | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| | ``<<FOO``                | HereDoc_          | StringlikeLiteral_         |                   |
| | ``hello world``          |                   |                            |                   |
| | ``FOO``                  |                   |                            |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``23``                     | IntegerLiteral_   | NumericLiteral_            |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``3.1``                    | FloatLiteral_     | NumericLiteral_            |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``3+2i``                   | ComplexLiteral_   | NumericLiteral_            |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``2/3r``                   | RationalLiteral_  | NumericLiteral_            |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``__LINE__``               | LineLiteral_      | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``nil``                    | NilLiteral_       | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``(1..10)``                | RangeLiteral_     | Literal_                   |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``/[a-z]+/``               | RegExpLiteral_    | StringlikeLiteral_         |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``"hello world"``          | StringLiteral_    | StringlikeLiteral_         |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ```ls -l```                | SubshellLiteral_  | StringlikeLiteral_         |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``%x(/bin/sh foo.sh)``     | SubshellLiteral_  | StringlikeLiteral_         |                   |
+----------------------------+-------------------+----------------------------+-------------------+
| ``:foo``                   | SymbolLiteral_    | StringlikeLiteral_         |                   |
+----------------------------+-------------------+----------------------------+-------------------+

Method classes
~~~~~~~~~~~~~~

All classes in this subsection are subclasses of Callable_.
+----------------------------------------+----------------------+----------------------+-------------------+
| Expression syntax                      | CodeQL class         | Superclasses         | Remarks           |
+========================================+======================+======================+===================+
| | BraceBlock_ | Block_ | |
| | Callable_ | | |
| | DoBlock_ | Block_ | |
| | Lambda_ | | |
| | Method_ | | |
| | MethodBase_ | | |
| | SingletonMethod_ | | |

..
  Expr.qll
| TODO | ArgumentList_ | Expr_ | The right-hand side of an assignment or a ``return``, ``break``, or ``next`` statement |
| StmtSequence_ TODO   | BodyStmt_ | StmtSequence_ | |
| TODO | DestructuredLhsExpr_ | LhsExpr_ | |
| TODO | LhsExpr_ | Expr_ | |
| ``IDENTIFIER:`` Expr_ | Pair_ | Expr_ | Such as in a hash or as a keyword argument |
| ``(`` StmtSequence_ ``)`` | ParenthesizedExpr_ | StmtSequence_ | |
| ``rescue``  TODO   | RescueClause_ | Expr_ |  |
| Stmt_ ``rescue`` Stmt_ | RescueModifierExpr_ | Expr_ | |
| StmtSequence_ ``;`` Stmt_ | StmtSequence_ | Expr_ | A sequence of 0 or more statements, separated by semicolons or newlines |
| StringLiteral_ StringLiteral_ | StringConcatenation_ | Expr_ | Implicit concatenation of consecutive string literals |


..
  Module.qll
| | ClassDeclaration_ | | |
| | Module_ | | |
| | ModuleBase_ | | |
| | ModuleDeclaration_ | | |
| | Namespace_ | | |
| | SingletonClass_ | | |
| | Toplevel_ | | |

..
  Parameter.qll
| | BlockParameter_ | | |
| | DestructuredParameter_ | | |
| | ForwardParameter_ | | |
| | HashSplatNilParameter_ | | |
| | HashSplatParameter_ | | |
| | KeywordParameter_ | | |
| | NamedParameter_ | | |
| | OptionalParameter_ | | |
| | Parameter_ | | |
| | SimpleParameter_ | | |
| | SplatParameter_ | | |

..
  Pattern.qll
| | AlternativePattern_ | | |
| | ArrayPattern_ | | |
| | AsPattern_ | | |
| | CasePattern_ | | |
| | FindPattern_ | | |
| | HashPattern_ | | |
| | ParenthesizedPattern_ | | |
| | ReferencePattern_ | | |

..
  Variable.qll
| | ClassVariable_ | | |
| | ClassVariableAccess_ | | |
| | ClassVariableReadAccess_ | | |
| | ClassVariableWriteAccess_ | | |
| | GlobalVariable_ | | |
| | GlobalVariableAccess_ | | |
| | GlobalVariableReadAccess_ | | |
| | GlobalVariableWriteAccess_ | | |
| | InstanceVariable_ | | |
| | InstanceVariableAccess_ | | |
| | InstanceVariableReadAccess_ | | |
| | InstanceVariableWriteAccess_ | | |
| | LocalVariable_ | | |
| | LocalVariableAccess_ | | |
| | LocalVariableReadAccess_ | | |
| | LocalVariableWriteAccess_ | | |
| | SelfVariable_ | | |
| | SelfVariableAccess_ | | |
| | SelfVariableReadAccess_ | | |
| | Variable_ | | |
| | VariableAccess_ | | |
| | VariableReadAccess_ | | |
| | VariableWriteAccess_ | | |

.. _BlockArgument: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$BlockArgument.html
.. _Call: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$Call.html
.. _ElementReference: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$ElementReference.html
.. _ForwardedArguments: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$ForwardedArguments.html
.. _MethodCall: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$MethodCall.html
.. _SetterMethodCall: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$SetterMethodCall.html
.. _SuperCall: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$SuperCall.html
.. _UnknownMethodCall: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$UnknownMethodCall.html
.. _YieldCall: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Call.qll/type.Call$YieldCall.html
.. _ConstantAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Constant.qll/type.Constant$ConstantAccess.html
.. _ConstantReadAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Constant.qll/type.Constant$ConstantReadAccess.html
.. _ConstantWriteAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Constant.qll/type.Constant$ConstantWriteAccess.html
.. _ConstantAssignment: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Constant.qll/type.Constant$ConstantAssignment.html
.. _ArgumentList: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$ArgumentList.html
.. _BodyStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$BodyStmt.html
.. _DestructuredLhsExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$DestructuredLhsExpr.html
.. _Expr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$Expr.html
.. _LhsExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$LhsExpr.html
.. _Pair: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$Pair.html
.. _ParenthesizedExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$ParenthesizedExpr.html
.. _RescueClause: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$RescueClause.html
.. _RescueModifierExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$RescueModifierExpr.html
.. _StmtSequence: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$StmtSequence.html
.. _StringConcatenation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Expr.qll/type.Expr$StringConcatenation.html
.. _ControlExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$ControlExpr.html
.. _ConditionalExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$ConditionalExpr.html
.. _Loop: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$Loop.html
.. _ConditionalLoop: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$ConditionalLoop.html
.. _ForExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$ForExpr.html
.. _IfExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$IfExpr.html
.. _WhileExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$WhileExpr.html
.. _UntilExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$UntilExpr.html
.. _IfModifierExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$IfModifierExpr.html
.. _UnlessModifierExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$UnlessModifierExpr.html
.. _WhileModifierExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$WhileModifierExpr.html
.. _UntilModifierExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$UntilModifierExpr.html
.. _TernaryIfExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$TernaryIfExpr.html
.. _CaseExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Control.qll/type.Control$CaseExpr.html
.. _AstNode: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/AST.qll/type.AST$AstNode.html
.. _ArrayLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$ArrayLiteral.html
.. _BooleanLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$BooleanLiteral.html
.. _CharacterLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$CharacterLiteral.html
.. _ComplexLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$ComplexLiteral.html
.. _EncodingLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$EncodingLiteral.html
.. _FileLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$FileLiteral.html
.. _FloatLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$FloatLiteral.html
.. _HashLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$HashLiteral.html
.. _HereDoc: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$HereDoc.html
.. _IntegerLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$IntegerLiteral.html
.. _LineLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$LineLiteral.html
.. _Literal: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$Literal.html
.. _MethodName: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$MethodName.html
.. _NilLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$NilLiteral.html
.. _NumericLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$NumericLiteral.html
.. _RangeLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$RangeLiteral.html
.. _RationalLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$RationalLiteral.html
.. _RegExpComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$RegExpComponent.html
.. _RegExpEscapeSequenceComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$RegExpEscapeSequenceComponent.html
.. _RegExpInterpolationComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$RegExpInterpolationComponent.html
.. _RegExpLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$RegExpLiteral.html
.. _RegExpTextComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$RegExpTextComponent.html
.. _StringComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$StringComponent.html
.. _StringEscapeSequenceComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$StringEscapeSequenceComponent.html
.. _StringInterpolationComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$StringInterpolationComponent.html
.. _StringLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$StringLiteral.html
.. _StringTextComponent: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$StringTextComponent.html
.. _StringlikeLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$StringlikeLiteral.html
.. _SubshellLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$SubshellLiteral.html
.. _SymbolLiteral: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Literal.qll/type.Literal$SymbolLiteral.html
.. _Block: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$Block.html
.. _BraceBlock: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$BraceBlock.html
.. _Callable: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$Callable.html
.. _DoBlock: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$DoBlock.html
.. _Lambda: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$Lambda.html
.. _Method: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$Method.html
.. _MethodBase: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$MethodBase.html
.. _SingletonMethod: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Method.qll/type.Method$SingletonMethod.html
.. _ClassDeclaration: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Module.qll/type.Module$ClassDeclaration.html
.. _Module: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Module.qll/type.Module$Module.html
.. _ModuleBase: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Module.qll/type.Module$ModuleBase.html
.. _ModuleDeclaration: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Module.qll/type.Module$ModuleDeclaration.html
.. _Namespace: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Module.qll/type.Module$Namespace.html
.. _SingletonClass: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Module.qll/type.Module$SingletonClass.html
.. _Toplevel: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Module.qll/type.Module$Toplevel.html
.. _AddExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AddExpr.html
.. _AssignAddExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignAddExpr.html
.. _AssignArithmeticOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignArithmeticOperation.html
.. _AssignBitwiseAndExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignBitwiseAndExpr.html
.. _AssignBitwiseOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignBitwiseOperation.html
.. _AssignBitwiseOrExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignBitwiseOrExpr.html
.. _AssignBitwiseXorExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignBitwiseXorExpr.html
.. _AssignDivExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignDivExpr.html
.. _AssignExponentExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignExponentExpr.html
.. _AssignExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignExpr.html
.. _AssignLShiftExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignLShiftExpr.html
.. _AssignLogicalAndExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignLogicalAndExpr.html
.. _AssignLogicalOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignLogicalOperation.html
.. _AssignLogicalOrExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignLogicalOrExpr.html
.. _AssignModuloExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignModuloExpr.html
.. _AssignMulExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignMulExpr.html
.. _AssignOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignOperation.html
.. _AssignRShiftExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignRShiftExpr.html
.. _AssignSubExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$AssignSubExpr.html
.. _Assignment: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$Assignment.html
.. _BinaryArithmeticOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$BinaryArithmeticOperation.html
.. _BinaryBitwiseOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$BinaryBitwiseOperation.html
.. _BinaryLogicalOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$BinaryLogicalOperation.html
.. _BinaryOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$BinaryOperation.html
.. _BitwiseAndExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$BitwiseAndExpr.html
.. _BitwiseOrExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$BitwiseOrExpr.html
.. _BitwiseXorExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$BitwiseXorExpr.html
.. _CaseEqExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$CaseEqExpr.html
.. _ComparisonOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$ComparisonOperation.html
.. _ComplementExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$ComplementExpr.html
.. _DefinedExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$DefinedExpr.html
.. _DivExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$DivExpr.html
.. _EqExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$EqExpr.html
.. _EqualityOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$EqualityOperation.html
.. _ExponentExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$ExponentExpr.html
.. _GEExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$GEExpr.html
.. _GTExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$GTExpr.html
.. _HashSplatExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$HashSplatExpr.html
.. _LEExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$LEExpr.html
.. _LShiftExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$LShiftExpr.html
.. _LTExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$LTExpr.html
.. _LogicalAndExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$LogicalAndExpr.html
.. _LogicalOrExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$LogicalOrExpr.html
.. _ModuloExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$ModuloExpr.html
.. _MulExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$MulExpr.html
.. _NEExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$NEExpr.html
.. _NoRegExpMatchExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$NoRegExpMatchExpr.html
.. _NotExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$NotExpr.html
.. _Operation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$Operation.html
.. _RShiftExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$RShiftExpr.html
.. _RegExpMatchExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$RegExpMatchExpr.html
.. _RelationalOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$RelationalOperation.html
.. _SpaceshipExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$SpaceshipExpr.html
.. _SplatExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$SplatExpr.html
.. _SubExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$SubExpr.html
.. _UnaryArithmeticOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$UnaryArithmeticOperation.html
.. _UnaryBitwiseOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$UnaryBitwiseOperation.html
.. _UnaryLogicalOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$UnaryLogicalOperation.html
.. _UnaryMinusExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$UnaryMinusExpr.html
.. _UnaryOperation: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$UnaryOperation.html
.. _UnaryPlusExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Operation.qll/type.Operation$UnaryPlusExpr.html
.. _BlockParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$BlockParameter.html
.. _DestructuredParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$DestructuredParameter.html
.. _ForwardParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$ForwardParameter.html
.. _HashSplatNilParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$HashSplatNilParameter.html
.. _HashSplatParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$HashSplatParameter.html
.. _KeywordParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$KeywordParameter.html
.. _NamedParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$NamedParameter.html
.. _OptionalParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$OptionalParameter.html
.. _Parameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$Parameter.html
.. _SimpleParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$SimpleParameter.html
.. _SplatParameter: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Parameter.qll/type.Parameter$SplatParameter.html
.. _AlternativePattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$AlternativePattern.html
.. _ArrayPattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$ArrayPattern.html
.. _AsPattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$AsPattern.html
.. _CasePattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$CasePattern.html
.. _FindPattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$FindPattern.html
.. _HashPattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$HashPattern.html
.. _ParenthesizedPattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$ParenthesizedPattern.html
.. _ReferencePattern: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Pattern.qll/type.Pattern$ReferencePattern.html
.. _Scope: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Scope.qll/type.Scope$Scope.html
.. _SelfScope: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Scope.qll/type.Scope$SelfScope.html
.. _AliasStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$AliasStmt.html
.. _BeginBlock: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$BeginBlock.html
.. _BeginExpr: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$BeginExpr.html
.. _BreakStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$BreakStmt.html
.. _EmptyStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$EmptyStmt.html
.. _EndBlock: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$EndBlock.html
.. _NextStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$NextStmt.html
.. _RedoStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$RedoStmt.html
.. _RetryStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$RetryStmt.html
.. _ReturnStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$ReturnStmt.html
.. _ReturningStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$ReturningStmt.html
.. _Stmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$Stmt.html
.. _UndefStmt: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Statement.qll/type.Statement$UndefStmt.html
.. _ClassVariable: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$ClassVariable.html
.. _ClassVariableAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$ClassVariableAccess.html
.. _ClassVariableReadAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$ClassVariableReadAccess.html
.. _ClassVariableWriteAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$ClassVariableWriteAccess.html
.. _GlobalVariable: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$GlobalVariable.html
.. _GlobalVariableAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$GlobalVariableAccess.html
.. _GlobalVariableReadAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$GlobalVariableReadAccess.html
.. _GlobalVariableWriteAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$GlobalVariableWriteAccess.html
.. _InstanceVariable: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$InstanceVariable.html
.. _InstanceVariableAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$InstanceVariableAccess.html
.. _InstanceVariableReadAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$InstanceVariableReadAccess.html
.. _InstanceVariableWriteAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$InstanceVariableWriteAccess.html
.. _LocalVariable: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$LocalVariable.html
.. _LocalVariableAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$LocalVariableAccess.html
.. _LocalVariableReadAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$LocalVariableReadAccess.html
.. _LocalVariableWriteAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$LocalVariableWriteAccess.html
.. _SelfVariable: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$SelfVariable.html
.. _SelfVariableAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$SelfVariableAccess.html
.. _SelfVariableReadAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$SelfVariableReadAccess.html
.. _Variable: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$Variable.html
.. _VariableAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$VariableAccess.html
.. _VariableReadAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$VariableReadAccess.html
.. _VariableWriteAccess: https://codeql.github.com/codeql-standard-libraries/ruby/codeql/ruby/ast/Variable.qll/type.Variable$VariableWriteAccess.html
