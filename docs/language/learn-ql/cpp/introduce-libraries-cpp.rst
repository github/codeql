Introducing the C/C++ libraries
===============================

Overview
--------

There is an extensive QL library for analyzing C/C++ code. The QL classes in this library present the data from a snapshot database in an object-oriented form and provide abstractions and predicates to help you with common analysis tasks. The library is implemented as a set of QL modules, that is, files with the extension ``.qll``. The module ``cpp.qll`` imports all the core library modules, so you can include the complete library by beginning your query with:

.. code-block:: ql

   import cpp

The rest of this topic briefly summarizes the most important QL classes and predicates provided by this library.

   You can find related classes and features using the query console's auto-complete feature. You can also press **F3** to jump to the definition of any element (QL library files are opened in new tabs in the console).

Summary of the library classes
------------------------------

The most commonly used standard QL library classes are organized as follows:

Preprocessor logic
~~~~~~~~~~~~~~~~~~

-  ``Include`` — ``#include`` directives (defined in the `Include.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Include.qll/module.Include.html>`__ library)
-  ``Macro``, ``MacroInvocation`` — ``#define`` directives and uses (defined in the `Macro.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Macro.qll/module.Macro.html>`__ library)
-  ``PreprocessorIf``, ``PreprocessorElse``, ``PreprocessorIfdef``, ``PreprocessorIfndef``, ``PreprocessorEndif`` — conditional processing directives (defined in the `Preprocessor.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Preprocessor.qll/module.Preprocessor.html>`__ library)

Symbol table
~~~~~~~~~~~~

-  ``Function`` — all functions, including member functions (defined in the `Function.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Function.qll/module.Function.html>`__ library)

   -  ``MemberFunction``

-  ``Variable`` (defined in the `Variable.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Variable.qll/module.Variable.html>`__ library)

   -  ``LocalScopeVariable``— local variables and parameters

      -  ``Parameter``

   -  ``MemberVariable`` — member variables of classes
   -  ``GlobalOrNamespaceVariable`` — global variables

-  ``Type`` — built-in and user-defined types (defined in the `Type.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Type.qll/module.Type.html>`__ library)

   -  ``Class`` — classes and structs
   -  ``Enum`` — enums, including scoped enums
   -  ``TypedefType`` — typedefs
   -  ``ArrayType`` — arrays
   -  ``PointerType`` — pointers
   -  ``SpecifiedType`` — qualifiers such as ``const``, ``volatile``, or ``restrict``

-  ``Namespace`` — namespaces (defined in the `Namespace.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Namespace.qll/module.Namespace.html>`__ library)

   -  ``GlobalNamespace`` — the global namespace

-  ``Initializer`` — initializers for variables (defined in the `Initializer.qll <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Initializer.qll/module.Initializer.html>`__ library)

Abstract syntax tree
~~~~~~~~~~~~~~~~~~~~

-  `Expr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$Expr.html>`__ — all expressions that occur in the code

   -  `Assignment <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Assignment.qll/type.Assignment$Assignment.html>`__ — assignment operators, for example: ``=``, ``+=``, ``-=``, ``*=``, ``/=``, ``%=``, ``&=``, ``|=``, ``^=``, ``<<=``, ``>>=``
   -  `UnaryOperation <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$UnaryOperation.html>`__ — unary operators, for example: ``+``, ``-``, ``~``, ``++``, ``--``, ``~``, ``!``, ``&``, ``*``
   -  `BinaryOperation <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$BinaryOperation.html>`__ — binary operators, for example: ``+``, ``-``, ``*``, ``/``, ``%``, ``&``, ``|``, ``^``, ``<<``, ``>>``, ``&&``, ``||``, ``==``, ``!=``, ``<=``, ``<``, ``>``, ``>=``
   -  `ConditionalExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/LogicalOperation.qll/type.LogicalOperation$ConditionalExpr.html>`__ — the ternary conditional operator, ``? :``
   -  `ParenthesisExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$ParenthesisExpr.html>`__
   -  `Literal <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Literal.qll/type.Literal$Literal.html>`__ — string, numeric and character literals
   -  `Conversion <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Cast.qll/type.Cast$Conversion.html>`__ — casts and compiler generated conversions
   -  `Call <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Call.qll/type.Call$Call.html>`__ — function calls, function pointer calls...

      -  ``FunctionCall``

   -  `Access <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Access.qll/type.Access$Access.html>`__

      -  ``VariableAccess``
      -  ``FunctionAccess``

   -  `ArrayExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Access.qll/type.Access$ArrayExpr.html>`__
   -  `SizeofOperator <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Cast.qll/type.Cast$SizeofOperator.html>`__
   -  `ThrowExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Call.qll/type.Call$ThrowExpr.html>`__
   -  `ThisExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$ThisExpr.html>`__
   -  `NewExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$NewExpr.html>`__, `NewArrayExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$NewArrayExpr.html>`__, `DeleteExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$DeleteExpr.html>`__, `DeleteArrayExpr <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/exprs/Expr.qll/type.Expr$DeleteArrayExpr.html>`__

-  `Stmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$Stmt.html>`__ — C/C++ statements

   -  `IfStmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$IfStmt.html>`__, `WhileStmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$WhileStmt.html>`__, `ForStmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$ForStmt.html>`__, `DoStmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$DoStmt.html>`__, `SwitchStmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$SwitchStmt.html>`__, `TryStmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$TryStmt.html>`__
   -  `ExprStmt <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Stmt.qll/type.Stmt$ExprStmt.html>`__ — expressions used as a statement, for example, an assignment
   -  `Block <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/stmts/Block.qll/type.Block$Block.html>`__ — ``{ }`` blocks containing more statements

-  `DeclarationEntry <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Declaration.qll/type.Declaration$DeclarationEntry.html>`__ — sites where items from the symbol table are declared and/or defined in code

   -  ``FunctionDeclarationEntry``
   -  ``VariableDeclarationEntry``
   -  ``TypeDeclarationEntry``

Control flow graph
~~~~~~~~~~~~~~~~~~

-  `ControlFlowNode <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/controlflow/ControlFlowGraph.qll/type.ControlFlowGraph$ControlFlowNode.html>`__ — statements, expressions and functions; control flow can be explored via the predicate ``ControlFlowNode.getASuccessor()``
-  `BasicBlock <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/controlflow/BasicBlocks.qll/type.BasicBlocks$BasicBlock.html>`__ — a `basic block <http://en.wikipedia.org/wiki/Basic_block>`__

External data
~~~~~~~~~~~~~

-  `Diagnostic <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/Diagnostics.qll/type.Diagnostics$Diagnostic.html>`__ — messages (such as errors or warnings) that were produced by the compiler
-  `XMLParent <https://help.semmle.com/qldoc/cpp/semmle/code/cpp/XML.qll/type.XML$XMLParent.html>`__ — XML data that was added to the snapshot

   -  ``XMLFile``
   -  ``XMLElement``

-  `ExternalData <https://help.semmle.com/qldoc/cpp/external/ExternalArtifact.qll/type.ExternalArtifact$ExternalData.html>`__ — any CSV data that has been imported into the snapshot

What next?
----------

-  Experiment with the worked examples in the QL for C/C++ topics: :doc:`Function classes <function-classes>`, :doc:`Expressions, types and statements <expressions-types>`, :doc:`Conversions and classes <conversions-classes>`, and :doc:`Analyzing data flow in C/C++ <dataflow>`.
-  Find out more about QL in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ and `QL language specification <https://help.semmle.com/QL/QLLanguageSpecification.html>`__.
-  Learn more about the query console in `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.
