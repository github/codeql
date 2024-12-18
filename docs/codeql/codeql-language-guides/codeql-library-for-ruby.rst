.. _codeql-library-for-ruby:

CodeQL library for Ruby
=======================

When you're analyzing a Ruby program, you can make use of the large collection of classes in the CodeQL library for Ruby.

Overview
--------

CodeQL ships with an extensive library for analyzing Ruby code.  The classes in this library present
the data from a CodeQL database in an object-oriented form and provide abstractions and predicates
to help you with common analysis tasks.

The library is implemented as a set of CodeQL modules, that is, files with the extension ``.qll``. The
module `ruby.qll <https://github.com/github/codeql/blob/main/ruby/ql/lib/ruby.qll>`__ imports most other standard library modules, so you can include the complete
library by beginning your query with:

.. code-block:: ql

   import codeql.ruby.AST

The CodeQL libraries model various aspects of Ruby code, depending on the type of query you want to write.
For example the abstract syntax tree (AST) library is used for locating program elements, to match syntactic
elements in the source code. This can be used to find values, patterns and structures.

The control flow graph (CFG) is imported using

.. code-block:: ql

   import codeql.ruby.CFG

The CFG models the control flow between statements and expressions, for example whether one expression can
flow to another expression, or whether an expression "dominates" another one, meaning that all paths to an
expression must flow through another expression first.

The data flow library is imported using 

.. code-block:: ql

   import codeql.ruby.DataFlow

Data flow tracks the flow of data through the program, including through function calls (interprocedural data flow).
Data flow is particularly useful for security queries, where untrusted data flows to vulnerable parts of the program
to exploit it. Related to data flow, is the taint-tracking library, which finds how data can *influence* other values
in a program, even when it is not copied exactly.

The API graphs library is used to locate methods in libraries. This is particuarly useful when locating
particular functions or parameters that could be used as a source or sink of data in a security query.

To summarize, the main Ruby modules are:

.. list-table:: Main Ruby modules
   :header-rows: 1

   * - Import
     - Description
   * - ``ruby``
     - The standard Ruby library
   * - ``codeql.ruby.AST``
     - The abstract syntax tree library (also imported by `ruby.qll`)
   * - ``codeql.ruby.ApiGraphs``
     - The API graphs library
   * - ``codeql.ruby.CFG``
     - The control flow graph library
   * - ``codeql.ruby.DataFlow``
     - The data flow library
   * - ``codeql.ruby.TaintTracking``
     - The taint tracking library

The CodeQL examples in this article are only excerpts and are not meant to represent complete queries.

Abstract syntax
---------------

The abstract syntax tree (AST) represents the elements of the source code organized into a tree. The `AST viewer <https://docs.github.com/en/code-security/codeql-for-vs-code/using-the-advanced-functionality-of-the-codeql-for-vs-code-extension/exploring-the-structure-of-your-source-code/>`__
in Visual Studio Code shows the AST nodes, including the relevant CodeQL classes and predicates.

All CodeQL AST classes inherit from the `AstNode` class, which provides the following member predicates
to all AST classes:

.. list-table:: Main predicates in ``AstNode``
   :header-rows: 1

   * - Predicate
     - Description
   * - ``getEnclosingModule()``
     - Gets the enclosing module, if any.
   * - ``getEnclosingMethod()``
     - Gets the enclosing method, if any.
   * - ``getLocation()``
     - Gets the location of this node.
   * - ``getAChild()``
     - Gets a child node of this node.
   * - ``getParent()``
     - Gets the parent of this `AstNode`, if this node is not a root node.
   * - ``getDesugared``
     - Gets the desugared version of this AST node, if any.
   * - ``isSynthesized()``
     - Holds if this node was synthesized to represent an implicit AST node not
       present in the source code.

Modules
~~~~~~~

Modules represent the main structural elements of Ruby programs, and include modules (``Module``), 
namespaces  (``Namespace``) and classes (``ClassDeclaration``).

.. list-table:: Callable classes
   :header-rows: 1

   * - CodeQL class
     - Description and selected predicates
   * - ``Module``
     -  A representation of a runtime `module` or `class` value.

        - `getADeclaration()` - Gets a declaration
        - `getSuperClass()` - Gets the super class of this module, if any.
        - `getAPrependedModule()` - Gets a prepended module.
        - `getAnIncludedModule()` - Gets an included module.
   * - ``Namespace``
     - A class or module definition.
     
       - `getName()` - Gets the name of the module/class.
       - `getAMethod()`, `getMethod(name)` - Gets a method in this namespace.
       - `getAClass()`, `getClass(name)` - Gets a class in this namespace.
       - `getAModule()`, `getModule(name)` - Gets a module in this namespace.
   * - ``ClassDeclaration``
     - A class definition.
   * - ``SingletonClass``
     - A definition of a singleton class on an object.
   * - ``ModuleDeclaration``
     - A module definition.
   * - ``Toplevel``
     - The node representing the entire Ruby source file.

The following example lists all methods in the class `ApiController`:

.. code-block:: ql

   import codeql.ruby.AST

   from ClassDeclaration m
   where m.getName() = "ApiController"
   select m, m.getAMethod()

Callables
~~~~~~~~~

`Callables` are elements that can be called, including methods and blocks.

.. list-table:: Callable classes
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * - ``Callable``
     - A callable.

       - `getAParameter()` - gets a parameter of this callable.
       - `getParameter(n)` - gets the nth parameter of this callable.
   * - ``Private``
     - A call to ``private``.
   * - ``Method``
     - A method.
  
       - `getName()` - gets the name of this method
   * - ``SingletonMethod``
     - A singleton method.
   * - ``Lambda``
     - A lambda (anonymous method).
   * - ``Block``
     - A block.
   * - ``DoBlock``
     - A block enclosed within `do` and `end`.
   * - ``BraceBlock``
     - A block defined using curly braces.

*Parameters* are the values that are passed into callables. Unlike other CodeQL language models,
parameters in Ruby are not variables themselves, but can introduce variables into the
callable. The variables of a parameter are given by the `getAVariable()` predicate.

.. list-table:: Parameter classes
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * - ``Parameter``
     - A parameter.
  
       - `getCallable()` - Gets the callable that this parameter belongs to.
       - `getPosition()` - Gets the zero-based position of this parameter.
       - `getAVariable()`, `getVariable(name)` - Gets a variable introduced by this parameter.
   * - ``PatternParameter``
     - A parameter defined using a pattern.
   * - ``TuplePatternParameter``
     - A parameter defined using a tuple pattern.
   * - ``NamedParameter``
     - A named parameter.

       - `getName()`, `hasName(name)` - Gets the name of this parameter.
       - `getAnAccess()` - Gets an access to this parameter.
       - `getDefiningAccess()` - Gets the access that defines the underlying local variable.
   * - ``SimpleParameter``
     - A simple (normal) parameter.
   * - ``BlockParameter``
     - A parameter that is a block.
   * - ``HashSplatParameter``
     - A hash-splat (or double-splat) parameter.
   * - ``KeywordParameter``
     - A keyword parameter, including a default value if the parameter is optional.

       - `getDefaultValue()` - Gets the default value, i.e. the value assigned to the parameter when one is not provided by the caller.
   * - ``OptionalParameter``
     - An optional parameter.

       - `getDefaultValue()` - Gets the default value, i.e. the value assigned to the parameter when one is not provided by the caller.
   * - ``SplatParameter``
     - A splat parameter.


Example

.. code-block:: ql

   import codeql.ruby.AST

   from Method m
   where m.getName() = "show"
   select m.getParameter(0)

Statements
~~~~~~~~~~

Statements are the elements of code blocks. Statements that produce a value are called *expressions*
and have CodeQL class `Expr`. The remaining statement types (that do not produce values) are listed below.

.. list-table:: Statement classes
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * -  ``Stmt``
     - The base class for all statements.

       - `getAControlFlowNode()` - Gets a control-flow node for this statement, if any.
       - `getEnclosingCallable()` - Gets the enclosing callable, if any.
   * - ``EmptyStmt``
     - An empty statement.
   * - ``BeginExpr``
     - A `begin` statement.
   * - ``BeginBlock``
     - A `BEGIN` block.
   * - ``EndBlock``
     - An `END` block.
   * - ``UndefStmt``
     - An `undef` statement.
   * - ``AliasStmt``
     - An `alias` statement.
   * - ``ReturningStmt``
     - A statement that may return a value: `return`, `break` and `next`.
   * - ``ReturnStmt``
     - A `return` statement.
   * - ``BreakStmt``
     - A `break` statement.
   * - ``NextStmt``
     - A `next` statement.
   * - ``RedoStmt``
     - A `redo` statement.
   * - ``RetryStmt``
     - A `retry` statement.

The following example finds all literals that are returned by a `return` statement.

.. code-block:: ql

   import codeql.ruby.AST

   from ReturnStmt return, Literal lit
   where lit.getParent() = return 
   select lit, "Returning a literal " + lit.getValueText()

Expressions
~~~~~~~~~~~

Expressions are types of statement that evaluate to a value. The CodeQL class `Expr` is the base class of all expression types.

.. list-table:: Expressions
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * - ``Expr``
     - An expression.
 
       This is the root class for all expressions.

       - `getValueText()` - Gets the textual (constant) value of this expression, if any.
   * - ``Self``
     - A reference to the current object.
   * - ``Pair``
     - A pair expression.
   * - ``RescueClause``
     - A `rescue` clause.
   * - ``RescueModifierExpr``
     - An expression with a `rescue` modifier.
   * - ``StringConcatenation``
     - A concatenation of string literals.

       - `getConcatenatedValueText()` - Gets the result of concatenating all the string literals, if and only if they do not contain any interpolations.

.. list-table:: Statement sequences
   :header-rows: 1

   * - CodeQL class
     - Description
   * - ``StmtSequence``
     - A sequence of expressions.

       - `getAStmt()`, `getStmt(n)` - Gets a statement in this sequence.
       - `isEmpty()` - Holds if this sequence has no statements.
       - `getNumberOfStatements()` - Gets the number of statements in this sequence.
   * - ``BodyStmt``
     - A sequence of statements representing the body of a method, class, module, or do-block.

       - `getARescue()`, `getRescue(n)` - Gets a rescue clause in this block.
       - `getElse()` - Gets the `else` clause in this block, if any.
       - `getEnsure()` - Gets the `ensure` clause in this block, if any.
   * - ``ParenthesizedExpr``
     - A parenthesized expression sequence, typically containing a single expression.


Literals are expressions that evaluate directly to the given value. The CodeQL Ruby library models all types of
Ruby literal.

.. list-table:: Literals
   :header-rows: 1

   * - CodeQL class
     - Description
   * - ``Literal``
     - A literal. This is the base class for all literals.

       - `getValueText()` - Gets the source text for this literal, if this is a simple literal.
   * - ``NumericLiteral``
     - A numerical literal. The literal types are ``IntegerLiteral``, ``FloatLiteral``, ``RationalLiteral``, and ``ComplexLiteral``.
   * - ``NilLiteral``
     - A `nil` literal.
   * - ``BooleanLiteral``
     - A Boolean value. The classes ``TrueLiteral`` and ``FalseLiteral`` match `true` and `false` respectively.
   * - ``StringComponent``
     - A component of a string. Either a ``StringTextComponent``, ``StringEscapeSequenceComponent``, or ``StringInterpolationComponent``.
   * - ``RegExpLiteral``
     - A regular expression literal.
   * - ``SymbolLiteral``
     - A symbol literal.
   * - ``SubshellLiteral``
     - A subshell literal.
   * - ``CharacterLiteral``
     - A character literal.
   * - ``ArrayLiteral``
     - An array literal.
   * - ``HashLiteral``
     - A hash literal.
   * - ``RangeLiteral``
     - A range literal.
   * - ``MethodName``
     - A method name literal.

The following example defines a string literal class containing the text "username":

.. code-block:: ql

   class UsernameLiteral extends Literal
   {
     UsernameLiteral() { this.getValueText().toLowerCase().matches("%username%") }
   }


*Operations* are types of expression that typically perform some sort of calculation. Most operations are ``MethodCalls`` because often
there is an underlying call to the operation.

.. list-table:: Operations
   :header-rows: 1

   * - CodeQL class
     - Description
   * - ``Operation``
     - An operation.
   * - ``UnaryOperation``
     - A unary operation.

       Types of unary operation include ``UnaryLogicalOperation``, ``NotExpr``, ``UnaryPlusExpr``, ``UnaryMinusExpr``, ``SplatExpr``, 
       ``HashSplatExpr``, ``UnaryBitwiseOperation``, and ``ComplementExpr``.
   * - ``DefinedExpr``
     - A call to the special `defined?` operator
   * - ``BinaryOperation``
     - A binary operation, that includes many other operation categories such as ``BinaryArithmeticOperation``, ``BinaryBitwiseOperation``, ``ComparisonOperation``, ``SpaceshipExpr``, and ``Assignment``.
   * - ``BinaryArithmeticOperation``
     - A binary arithmetic operation. Includes: ``AddExpr``, ``SubExpr``, ``MulExpr``, ``DivExpr``, ``ModuloExpr``, and ``ExponentExpr``.
   * - ``BinaryLogicalOperation``
     - A binary logical operation. Includes: ``LogicalAndExpr`` and ``LogicalOrExpr``.
   * - ``BinaryBitwiseOperation``
     - A binary bitwise operation. Includes: ``LShiftExpr``, ``RShiftExpr``, ``BitwiseAndExpr``, ``BitwiseOrExpr``, and ``BitwiseXorExpr``.
   * - ``ComparisonOperation``
     - A comparison operation, including the classes ``EqualityOperation``, ``EqExpr``, ``NEExpr``, ``CaseEqExpr``, ``RelationalOperation``, ``GTExpr``, ``GEExpr``, ``LTExpr``, and ``LEExpr``.
   * - ``RegExpMatchExpr``
     - A regexp match expression.
   * - ``NoRegExpMatchExpr``
     - A regexp-doesn't-match expression.
   * - ``Assignment``
     - An assignment. Assignments are simple assignments (``AssignExpr``), or assignment operations (``AssignOperation``).

       The assignment arithmetic operations (``AssignArithmeticOperation``) are ``AssignAddExpr``, ``AssignSubExpr``, ``AssignMulExpr``, ``AssignDivExpr``, ``AssignModuloExpr``, and ``AssignExponentExpr``.
       
       The assignment logical operations (``AssignLogicalOperation``) are ``AssignLogicalAndExpr`` and ``AssignLogicalOrExpr``.

       The assignment bitwise operations (``AssignBitwiseOperation``) are ``AssignLShiftExpr``, ``AssignRShiftExpr``, ``AssignBitwiseAndExpr``, ``AssignBitwiseOrExpr``, and ``AssignBitwiseXorExpr``.

The following example finds "chained assignments" (of the form ``A=B=C``):

.. code-block:: ql

   import codeql.ruby.AST
   
   from Assignment op
   where op.getRightOperand() instanceof Assignment
   select op, "This is a chained assignment."

Calls pass control to another function, include explicit method calls (``MethodCall``), but also include other types of call such as `super` calls or `yield` calls.

.. list-table:: Calls
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * - ``Call``
     - A call.
        
       - `getArgument(n)`, `getAnArgument()`, `getKeywordArgument(keyword)` - Gets an argument of this call.
       - `getATarget()` - Gets a potential target of this call, if any.
   * - ``MethodCall``
     - A method call.

       - `getReceiver()` - Gets the receiver of this call, if any. This is the object being invoked.
       - `getMethodName()` - Gets the name of the method being called.
       - `getBlock()` - Gets the block of this method call, if any.
   * - ``SetterMethodCall``
     - A call to a setter method.
   * - ``ElementReference``
     - An element reference; a call to the `[]` method.
   * - ``YieldCall``
     - A call to `yield`.
   * - ``SuperCall``
     - A call to `super`.
   * - ``BlockArgument``
     - A block argument in a method call.

The following example finds all method calls to a method called `delete`.

.. code-block:: ql

   import codeql.ruby.AST

   from MethodCall call
   where call.getMethodName() = "delete"
   select call, "Call to 'delete'."

Control expressions are expressions used for control flow.  They are classed as expressions because they can produce a value.

.. list-table:: Control expressions
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * - ``ControlExpr``
     - A control expression, such as a `case`, `if`, `unless`, ternary-if (`?:`), `while`, `until` (including expression-modifier variants), and `for`.
   * - ``ConditionalExpr``
     - A conditional expression.

       - `getCondition()` - Gets the condition expression.
   * - ``IfExpr``
     - An `if` or `elsif` expression.

       - `getThen()` - Gets the `then` branch.
       - `getElse()` - Gets the `elseif` or `else` branch.
   * - ``UnlessExpr``
     - An `unless` expression.
   * - ``IfModifierExpr``
     - An expression modified using `if`.
   * - ``UnlessModifierExpr``
     - An expression modified using `unless`.
   * - ``TernaryIfExpr``
     - A conditional expression using the ternary (`?:`) operator.
   * - ``CaseExpr``
     - A `case` expression.
   * - ``WhenExpr``
     - A `when` branch of a `case` expression.
   * - ``Loop``
     - A loop. That is, a `for` loop, a `while` or `until` loop, or their expression-modifier variants.
   * - ``ConditionalLoop``
     - A loop using a condition expression. That is, a `while` or `until` loop, or their expression-modifier variants.

       - `getCondition()` - Gets the condition expression of this loop.
   * - ``WhileExpr``
     - A `while` loop.
   * - ``UntilExpr``
     - An `until` loop.
   * - ``WhileModifierExpr``
     - An expression looped using the `while` modifier.
   * - ``UntilModifierExpr``
     - An expression looped using the `until` modifier.
   * - ``ForExpr``
     - A `for` loop.

The following example finds `if`-expressions that are missing a `then` branch.

.. code-block:: ql
   
   import codeql.ruby.AST

   from IfExpr expr
   where not exists(expr.getThen())
   select expr, "This if-expression is redundant."

Variables
~~~~~~~~~

*Variables* are names that hold values in a Ruby program. If you want to query *any* type 
of variable, then use the ``Variable`` class, otherwise use one of the subclasses
``LocalVariable``, ``InstanceVariable``, ``ClassVariable`` or ``GlobalVariable``.

Local variables have the scope of a single function or block, instance variables have the
scope of an object (like member variables), *class* variables have the scope of a class and are
shared between all instances of that class (like static variables), and *global* variables
have the scope of the entire program.

.. list-table:: Variable classes
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * - ``Variable``
     - A variable declared in a scope.

       - `getName()`, `hasName(name)` - Gets the name of this variable.
       - `getDeclaringScope()` - Gets the scope this variable is declared in.
       - `getAnAccess()` - Gets an access to this variable.
   * - ``LocalVariable``
     - A local variable.
   * - ``InstanceVariable``
     - An instance variable.
   * - ``ClassVariable``
     - A class variable.
   * - ``GlobalVariable``
     - A global variable.

The following example finds all class variables in the class `StaticController`:

.. code-block:: ql

   import codeql.ruby.AST

   from ClassDeclaration cd, ClassVariable v
   where
     v.getDeclaringScope() = cd and
     cd.getName() = "StaticController"
   select v, "This is a static variable in 'StaticController'."

Variable accesses are the uses of a variable in the source code. Note that variables, and *uses* of variables are different concepts.
Variables are modelled using the ``Variable`` class, whereas uses of the variable are modelled using the ``VariableAccess`` class.
``Variable.getAnAccess()`` gets the accesses of a variable.

Variable accesses come in two types: *reads* of the variable (a ``ReadAccess``), and *writes* to the variable (a ``WriteAccess``). 
Accesses are a type of expression, so extend the ``Expr`` class. 

.. list-table:: Variable access classes
   :header-rows: 1

   * - CodeQL class
     - Description and main predicates
   * - ``VariableAccess``
     - An access to a variable.

       - `getVariable()` - Gets the variable that is accessed.
   * - ``VariableReadAccess``
     - An access to a variable where the value is read.
   * - ``VariableWriteAccess``
     - An access to a variable where the value is updated.
   * - ``LocalVariableAccess``
     - An access to a local variable.
   * - ``LocalVariableWriteAccess``
     - An access to a local variable where the value is updated.
   * - ``LocalVariableReadAccess``
     - An access to a local variable where the value is read.
   * - ``GlobalVariableAccess``
     - An access to a global variable where the value is updated.
   * - ``InstanceVariableAccess``
     - An access to a global variable where the value is read.
   * - ``InstanceVariableReadAccess``
     - An access to an instance variable.
   * - ``InstanceVariableWriteAccess``
     - An access to an instance variable where the value is updated.
   * - ``ClassVariableAccess``
     - An access to a class variable.
   * - ``ClassVariableWriteAccess``
     - An access to a class variable where the value is updated.
   * - ``ClassVariableReadAccess``
     - An access to a class variable where the value is read.

The following example finds writes to class variables in the class `StaticController`:

.. code-block:: ql

   import codeql.ruby.AST

   from ClassVariableWriteAccess write, ClassDeclaration cd, ClassVariable v
   where
     v.getDeclaringScope() = cd and
     cd.getName() = "StaticController" and
     write.getVariable() = v
   select write, "'StaticController' class variable is written here."