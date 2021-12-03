.. _codeql-library-for-csharp:

CodeQL library for C#
=====================

When you're analyzing a C# program, you can make use of the large collection of classes in the CodeQL library for C#.

About the CodeQL libraries for C#
---------------------------------

There is an extensive core library for analyzing CodeQL databases extracted from C# projects. The classes in this library present the data from a database in an object-oriented form and provide abstractions and predicates to help you with common analysis tasks. The library is implemented as a set of QL modules, that is, files with the extension ``.qll``. The module ``csharp.qll`` imports all the core C# library modules, so you can include the complete library by beginning your query with:

.. code-block:: ql

   import csharp

Since this is required for all C# queries, it's omitted from code snippets below.

The core library contains all the program elements, including `files <#files>`__, `types <#types>`__, methods, `variables <#variables>`__, `statements <#statements>`__, and `expressions <#expressions>`__. This is sufficient for most queries, however additional libraries can be imported for bespoke functionality such as control flow and data flow. For information about these additional libraries, see ":ref:`CodeQL for C# <codeql-for-csharp>`." 

Class hierarchies
~~~~~~~~~~~~~~~~~

Each section contains a class hierarchy, showing the inheritance structure between CodeQL classes. For example:

-  ``Expr``

   -  ``Operation``

      -  ``ArithmeticOperation``

         -  ``UnaryArithmeticOperation``

            -  ``UnaryMinusExpr``, ``UnaryPlusExpr``
            -  ``MutatorOperation``

               -  ``IncrementOperation``

                  -  ``PreIncrExpr``, ``PostIncrExpr``

               -  ``DecrementOperation``

                  -  ``PreDecrExpr``, ``PostDecrExpr``

         -  ``BinaryArithmeticOperation``

            -  ``AddExpr``, ``SubExpr``, ``MulExpr``, ``DivExpr``, ``RemExpr``

This means that the class ``AddExpr`` extends class ``BinaryArithmeticOperation``, which in turn extends class ``ArithmeticOperation`` and so on. If you want to query any arithmetic operation, use the class ``ArithmeticOperation``, but if you specifically want to limit the query to addition operations, use the class ``AddExpr``.

Classes can also be considered to be *sets*, and the ``extends`` relation between classes defines a subset. Every member of class ``AddExpr`` is also in the class ``BinaryArithmeticOperation``. In general, classes overlap and an entity can be a member of several classes.

This overview omits some of the less important or intermediate classes from the class hierarchy.

Each class has predicates, which are logical propositions about that class. They also define navigable relationships between classes. Predicates are inherited, so for example the ``AddExpr`` class inherits the predicates ``getLeftOperand()`` and ``getRightOperand()`` from ``BinaryArithmeticOperation``, and ``getType()`` from class ``Expr``. This is similar to how methods are inherited in object-oriented programming languages.

In this overview, we present the most common and useful predicates. For the complete list of predicates available on each class, you can look in the CodeQL source code, use autocomplete in the editor, or see the `C# reference <https://codeql.github.com/codeql-standard-libraries/csharp>`__.

Exercises
~~~~~~~~~

Each section in this topic contains exercises to check your understanding.

Exercise 1: Simplify this query:

.. code-block:: ql

   from BinaryArithmeticOperation op
   where op instanceof AddExpr
   select op

(`Answer <#exercise-1>`__)

Files
-----

Files are represented by the class `File <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/csharp/File.qll/type.File$File.html>`__, and directories by the class `Folder <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/csharp/File.qll/type.File$Folder.html>`__. The database contains all of the source files and assemblies used during the compilation.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``File`` - any file in the database (including source files, XML and assemblies)

   -  ``SourceFile`` - a file containing source code

-  ``Folder`` - a directory

Predicates
~~~~~~~~~~

-  ``getName()`` - gets the full path of the file (for example, ``C:\Temp\test.cs``).
-  ``getNumberOfLines()`` - gets the number of lines (for source files only).
-  ``getShortName()`` - gets the name of the file without the extension (for example, ``test``).
-  ``getBaseName()`` - gets the name and extension of the file (for example, ``test.cs``).
-  ``getParent()`` - gets the parent directory.

Examples
~~~~~~~~

Count the number of source files:

.. code-block:: ql

   select count(SourceFile f)

Count the number of lines of code, excluding the directory ``external``:

.. code-block:: ql

   select sum(SourceFile f |
     not exists(Folder ext | ext.getShortName() = "external" |
                ext.getAFolder*().getAFile() = f) |
     f.getNumberOfLines())

Exercises
~~~~~~~~~

Exercise 2: Write a query to find the source file with the largest number of lines. Hint: Find the source file with the same number of lines as the ``max`` number of lines in any file. (`Answer <#exercise-2>`__)

Elements
--------

The class `Element <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/cil/Element.qll/type.Element$Element.html>`__ is the base class for all parts of a C# program, and it's the root of the element class hierarchy. All program elements (such as types, methods, statements, and expressions) ultimately derive from this common base class.

``Element`` forms a hierarchical structure of the program, which can be navigated using the ``getParent()`` and ``getChild()`` predicates. This is much like an abstract syntax tree, and also applies to elements in assemblies.

Predicates
~~~~~~~~~~

The ``Element`` class provides common functionality for all program elements, including:

-  ``getLocation()`` - gets the text span in the source code.
-  ``getFile()`` - gets the ``File`` containing the ``Element``.
-  ``getParent()`` - gets the parent ``Element``, if any.
-  ``getAChild()`` - gets a child ``Element`` of this element, if any.

Examples
~~~~~~~~

To list all elements in ``Main.cs``, their QL class and location:

.. code-block:: ql

   from Element e
   where e.getFile().getShortName() = "Main"
   select e, e.getAQlClass(), e.getLocation()

Note that ``getAQlClass()`` is available on all entities and is a useful way to figure out the QL class of something. Often the same element will have several classes which are all returned by ``getAQlClass()``.

Locations
---------

`Location <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/csharp/Location.qll/type.Location$Location.html>`__ represents a section of text in the source code, or an assembly. All elements have a ``Location`` obtained by their ``getLocation()`` predicate. A ``SourceLocation`` represents a span of text in source code, whereas an ``Assembly`` location represents a referenced assembly.

Sometimes elements have several locations, for example if they occur in both source code and an assembly. In this case, only the ``SourceLocation`` is returned.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Location``

   -  ``SourceLocation``
   -  ``Assembly``

Predicates
~~~~~~~~~~

Some predicates of ``Location`` include:

-  ``getFile()`` - gets the ``File``.
-  ``getStartLine()`` - gets the first line of the text.
-  ``getEndLine()`` - gets the last line of the text.
-  ``getStartColumn()`` - gets the column of the start of the text.
-  ``getEndColumn()`` - gets the column of the end of the text.

Examples
~~~~~~~~

Find all elements that are one character wide:

.. code-block:: ql

   from Element e, Location l
   where l = e.getLocation()
     and l.getStartLine() = l.getEndLine()
     and l.getStartColumn() = l.getEndColumn()
   select e, "This element is a single character."

Declarations
------------

`Declaration <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/cil/Declaration.qll/type.Declaration$Declaration.html>`__ is the common class of all entities defined in the program, such as types, methods, variables etc. The database contains all declarations from the source code and all referenced assemblies.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Element``

   -  ``Declaration``

      -  ``Callable``
      -  ``UnboundGeneric``
      -  ``ConstructedGeneric``
      -  ``Modifiable`` - a declaration which can have a modifier (for example ``public``)

         -  ``Member`` - a declaration that is member of a type

      -  ``Assignable`` - an element that can be assigned to

         -  ``Variable``
         -  ``Property``
         -  ``Indexer``
         -  ``Event``

Predicates
~~~~~~~~~~

Useful member predicates on ``Declaration`` include:

-  ``getDeclaringType()`` - gets the type containing the declaration, if any.
-  ``getName()``/``hasName(string)`` - gets the name of the declared entity.
-  ``isSourceDeclaration()`` - whether the declaration is source code and is not a constructed type/method.
-  ``getSourceDeclaration()`` - gets the original (unconstructed) declaration.

Examples
~~~~~~~~

Find declarations containing a username:

.. code-block:: ql

   from Declaration decl
   where decl.getName().regexpMatch("[uU]ser([Nn]ame)?")
   select decl, "A username."

Variables
---------

The class `Variable <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/cil/Variable.qll/type.Variable$Variable.html>`__ represents C# variables, such as fields, parameters and local variables. The database contains all variables from the source code, as well as all fields and parameters from assemblies referenced by the program.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Element``

   -  ``Declaration``

      -  ``Variable`` - any type of variable

         -  ``Field`` - a field in a ``class``/``struct``

            -  ``MemberConstant`` - a ``const`` field

               -  ``EnumConstant`` - a field in an ``enum``

         -  ``LocalScopeVariable`` - a variable whose scope is limited to a single ``Callable``

            -  ``LocalVariable`` - a local variable in a ``Callable``

               -  ``LocalConstant`` - a locally defined constant in a ``Callable``

            -  ``Parameter`` - a parameter to a ``Callable``

Predicates
~~~~~~~~~~

Some common predicates on ``Variable`` are:

-  ``getType()`` - gets the ``Type`` of this variable.
-  ``getAnAccess()`` - gets an expression that accesses (reads or writes) this variable, if any.
-  ``getAnAssignedValue()`` - gets an expression that is assigned to this variable, if any.
-  ``getInitializer()`` - gets the expression used to initialize the variable, if any.

Examples
~~~~~~~~

Find all unused local variables:

.. code-block:: ql

   from LocalVariable v
   where not exists(v.getAnAccess())
   select v, "This local variable is unused."

Types
-----

Types are represented by the CodeQL class `Type <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/cil/Type.qll/type.Type$Type.html>`__ and consist of builtin types, interfaces, classes, structs, enums, and type parameters. The database contains types from the program and all referenced assemblies including mscorlib and the .NET framework.

The builtin types (``object``, ``int``, ``double`` etc.) have corresponding types (``System.Object``, ``System.Int32`` etc.) in mscorlib.

Class ``ValueOrRefType`` represents defined types, such as a ``class``, ``struct``, ``interface`` or ``enum``.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Element``

   -  ``Declaration``

      -  ``Modifiable`` - a declaration which can have a modifier (for example ``public``)

         -  ``Member`` - a declaration that is member of a type

            -  ``Type`` - all types

               -  ``ValueOrRefType`` - a defined type

                  -  ``ValueType`` - a value type (see below for further hierarchy)
                  -  ``RefType`` - a reference type (see below for further hierarchy)
                  -  ``NestedType`` - a type defined in another type

               -  ``VoidType`` - ``void``
               -  ``PointerType`` - a pointer type

The ``ValueType`` class extends further:

-  ``ValueType`` - a value type

   -  ``SimpleType`` - a simple built-in type

      -  ``BoolType`` - ``bool``
      -  ``CharType`` - ``char``
      -  ``IntegralType``

         -  ``UnsignedIntegralType``

            -  ``ByteType`` - ``byte``
            -  ``UShortType`` - ``unsigned short``/``System.UInt16``
            -  ``UIntType`` - ``unsigned int``/``System.UInt32``
            -  ``ULongType`` - ``unsigned long``/``System.UInt64``

         -  ``SignedIntegralType``

            -  ``SByteType`` - ``signed byte``
            -  ``ShortType`` - ``short``/``System.Int16``
            -  ``IntType`` - ``int``/``System.Int32``
            -  ``LongType`` - ``long``/``System.Int64``

         -  ``FloatingPointType``

            -  ``FloatType`` - ``float``/``System.Single``
            -  ``DoubleType`` - ``double``/``System.Double``

         -  ``DecimalType`` - ``decimal``/``System.Decimal``

      -  ``Enum`` - an ``enum``
      -  ``Struct`` - a ``struct``
      -  ``NullableType``
      -  ``ArrayType``

The ``RefType`` class extends further:

-  ``RefType``

   -  ``Class`` - a ``class``

      -  ``AnonymousClass``
      -  ``ObjectType`` - ``object``/``System.Object``
      -  ``StringType`` - ``string``/``System.String``

   -  ``Interface`` - an ``interface``
   -  ``DelegateType``
   -  ``NullType`` - the type of ``null``
   -  ``DynamicType`` - ``dynamic``

-  ``NestedType`` - a type defined in another type

These class hierarchies omit generic types for simplicity.

Predicates
~~~~~~~~~~

Useful members of ``ValueOrRefType`` include:

-  ``getQualifiedName()/hasQualifiedName(string)`` - gets the qualified name of the type (for example, ``"System.String"``).
-  ``getABaseInterface()`` - gets an immediate interface of this type, if any.
-  ``getABaseType()`` - gets an immediate base class or interface of this type, if any.
-  ``getBaseClass()`` - gets the immediate base class of this type, if any.
-  ``getASubType()`` - gets an immediate subtype, a type which directly inherits from this type, if any.
-  ``getAMember()`` - gets any member (field/method/property etc), if any.
-  ``getAMethod()`` - gets a method, if any.
-  ``getAProperty()`` - gets a property, if any.
-  ``getAnIndexer()`` - gets an indexer, if any.
-  ``getAnEvent()`` - gets an event, if any.
-  ``getAnOperator()`` - gets an operator, if any.
-  ``getANestedType()`` - gets a nested type.
-  ``getNamespace()`` - gets the enclosing namespace.

Examples
~~~~~~~~

Find all members of ``System.Object``:

.. code-block:: ql

   from ObjectType object
   select object.getAMember()

Find all types which directly implement ``System.Collections.IEnumerable``:

.. code-block:: ql

   from Interface ienumerable
   where ienumerable.hasQualifiedName("System.Collections.IEnumerable")
   select ienumerable.getASubType()

List all simple types in the ``System`` namespace:

.. code-block:: ql

   select any(SimpleType t | t.getNamespace().hasName("System"))

Find all variables of type ``PointerType``:

.. code-block:: ql

   from Variable v
   where v.fromSource()
     and v.getType() instanceof PointerType
   select v

List all classes in source files:

.. code-block:: ql

   from Class c
   where c.fromSource()
   select c

Exercises
~~~~~~~~~

Exercise 3: Write a query to list the methods in ``string``. (`Answer <#exercise-3>`__)

Exercise 4: Adapt the example to find all types which indirectly implement ``IEnumerable``. (`Answer <#exercise-4>`__)

Exercise 5: Write a query to find all classes starting with the letter ``A``. (`Answer <#exercise-5>`__)

Callables
---------

Callables are represented by the class `Callable <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/csharp/Callable.qll/type.Callable$Callable.html>`__ and are anything that can be called independently, such as methods, constructors, destructors, operators, anonymous functions, indexers, and property accessors.

The database contains all of the callables in your program and in all referenced assemblies.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Element``

   -  ``Declaration``

      -  ``Callable``

         -  ``Method``

            -  ``ExtensionMethod``

         -  ``Constructor``

            -  ``StaticConstructor``
            -  ``InstanceConstructor``

         -  ``Destructor``
         -  ``Operator``

            -  ``UnaryOperator``

               -  ``PlusOperator``, ``MinusOperator``, ``NotOperator``, ``ComplementOperator``, ``IncrementOperator``, ``DecrementOperator``, ``FalseOperator``, ``TrueOperator``

            -  ``BinaryOperator``

               -  ``AddOperator``, ``SubOperator``, ``MulOperator``, ``DivOperator``, ``RemOperator``, ``AndOperator``, ``OrOperator``, ``XorOperator``, ``LShiftOperator``, ``RShiftOperator``, ``EQOperator``, ``NEOperator``, ``LTOperator``, ``GTOperator``, ``LEOperator``, ``GEOperator``

            -  ``ConversionOperator``

               -  ``ImplicitConversionOperator``
               -  ``ExplicitConversionOperator``

         -  ``AnonymousFunctionExpr``

            -  ``LambdaExpr``
            -  ``AnonymousMethodExpr``

         -  ``Accessor``

            -  ``Getter``
            -  ``Setter``
            -  ``EventAccessor``

               -  ``AddEventAccessor``, ``RemoveEventAccessor``

Predicates
~~~~~~~~~~

Here are a few useful predicates on the ``Callable`` class:

-  ``getParameter(int)``/``getAParameter()`` - gets a parameter.
-  ``calls(Callable)`` - whether there's a direct call from one callable to another.
-  ``getReturnType()`` - gets the return type.
-  ``getBody()``/``getExpressionBody()`` - gets the body of the callable.

Since ``Callable`` extends ``Declaration``, it also has predicates from ``Declaration``, such as:

-  ``getName()``/``hasName(string)``
-  ``getSourceDeclaration()``
-  ``getName()``
-  ``getDeclaringType()``

Methods have additional predicates, including:

-  ``getAnOverridee()`` - gets a method that is immediately overridden by this method.
-  ``getAnOverrider()`` - gets a method that immediately overrides this method.
-  ``getAnImplementee()`` - gets an interface method that is immediately implemented by this method.
-  ``getAnImplementor()`` - gets a method that immediately implements this interface method.

Examples
~~~~~~~~

List all types which override ``ToString``:

.. code-block:: ql

   from Method m
   where m.hasName("ToString")
   select m

Find methods that look like ``ToString`` methods but don't override ``Object.ToString``:

.. code-block:: ql

   from Method toString, Method falseToString
   where toString.hasQualifiedName("System.Object.ToString")
    and falseToString.getName().toLowerCase() = "tostring"
    and not falseToString.overrides*(toString) 
    and falseToString.getNumberOfParameters() = 0
   select falseToString, "This method looks like it overrides Object.ToString but it doesn't."

Find all methods which take a pointer type:

.. code-block:: ql

   from Method m
   where m.getAParameter().getType() instanceof PointerType
   select m, "This method uses pointers."

Find all classes which have a destructor but aren't disposable:

.. code-block:: ql

   from Class c
   where c.getAMember() instanceof Destructor
     and not c.getABaseType*().hasQualifiedName("System.IDisposable")
   select c, "This class has a destructor but is not IDisposable."

Find ``Main`` methods which are not ``private``:

.. code-block:: ql

   from Method m
   where m.hasName("Main")
     and not m.isPrivate()
   select m, "Main method should be private."

Statements
----------

Statements are represented by the class `Stmt <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/csharp/Stmt.qll/type.Stmt$Stmt.html>`__ and make up the body of methods (and other callables). The database contains all statements in the source code, but does not contain any statements from referenced assemblies where the source code is not available.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Element``

   -  ``ControlFlowElement``

      -  ``Stmt``

         -  ``BlockStmt`` - ``{ ... }``
         -  ``ExprStmt``
         -  ``SelectionStmt``

            -  ``IfStmt`` - ``if``
            -  ``SwitchStmt`` - ``switch``

         -  ``LabeledStmt``

            -  ``ConstCase``
            -  ``DefaultCase`` - ``default``
            -  ``LabelStmt``

         -  ``LoopStmt``

            -  ``WhileStmt`` - ``while(...) { ... }``
            -  ``DoStmt`` - ``do { ... } while(...)``
            -  ``ForStmt`` - ``for``
            -  ``ForEachStmt`` - ``foreach``

         -  ``JumpStmt``

            -  ``BreakStmt`` - ``break``
            -  ``ContinueStmt`` - ``continue``
            -  ``GotoStmt`` - ``goto``

               -  ``GotoLabelStmt``
               -  ``GotoCaseStmt``
               -  ``GotoDefaultStmt``

            -  ``ThrowStmt`` - ``throw``
            -  ``ReturnStmt`` - ``return``
            -  ``YieldStmt``

               -  ``YieldBreakStmt`` - ``yield break``
               -  ``YieldReturnStmt`` - ``yield return``

         -  ``TryStmt`` - ``try``
         -  ``CatchClause`` - ``catch``

            -  ``SpecificCatchClause``
            -  ``GeneralCatchClause``

         -  ``CheckedStmt`` - ``checked``
         -  ``UncheckedStmt`` - ``unchecked``
         -  ``LockStmt`` - ``lock``
         -  ``UsingStmt`` - ``using``
         -  ``LocalVariableDeclStmt``

            -  ``LocalConstantDeclStmt``

         -  ``EmptyStmt`` - ``;``
         -  ``UnsafeStmt`` - ``unsafe``
         -  ``FixedStmt`` - ``fixed``

Examples
~~~~~~~~

Find long methods:

.. code-block:: ql

   from Method m
   where m.getBody().(BlockStmt).getNumberOfStmts() >= 100
   select m, "This is a long method!"

Find ``for(;;)``:

.. code-block:: ql

   from ForStmt for
   where not exists(for.getAnInitializer())
     and not exists(for.getUpdate(_))
     and not exists(for.getCondition())
   select for, "Infinite loop."

Find ``catch(NullDefererenceException)``:

.. code-block:: ql

   from SpecificCatchClause catch
   where catch.getCaughtExceptionType().hasQualifiedName("System.NullReferenceException")
   select catch, "Catch NullReferenceException."

Find an ``if`` statement with a constant condition:

.. code-block:: ql

   from IfStmt ifStmt
   where ifStmt.getCondition().hasValue()
   select ifStmt, "This 'if' statement is constant."

Find an ``if`` statement with an empty "then" block:

.. code-block:: ql

   from IfStmt ifStmt
   where ifStmt.getThen().(BlockStmt).isEmpty()
   select ifStmt, "If statement with empty 'then' block."

The ``(BlockStmt)`` is an inline cast, which restricts the query to cases where the result of ``getThen()`` has the QL class ``BlockStmt``, and allows predicates on ``BlockStmt`` to be used, such as ``isEmpty()``.

Exercises
~~~~~~~~~

Exercise 6: Write a query to list all empty methods. (`Answer <#exercise-6>`__)

Exercise 7: Modify the last example to also detect empty statements (``;``) in the "then" block. (`Answer <#exercise-7>`__)

Exercise 8: Modify the last example to exclude chains of ``if`` statements, where the ``else`` part is another ``if`` statement. (`Answer <#exercise-8>`__)

Expressions
-----------

The `Expr <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/csharp/exprs/Expr.qll/type.Expr$Expr.html>`__ class represents all C# expressions in the program. An expression is something producing a value such as ``a+b`` or ``new List<int>()``. The database contains all expressions from the source code, but no expressions from referenced assemblies where the source code is not available.

The ``Access`` class represents any use or cross-reference of another ``Declaration`` such a variable, property, method or field. The ``getTarget()`` predicate gets the declaration being accessed.

The ``Call`` class represents a call to a ``Callable``, for example to a ``Method`` or an ``Accessor``, and the ``getTarget()`` method gets the ``Callable`` being called. The ``Operation`` class consists of arithmetic, bitwise operations and logical operations.

Some expressions use a qualifier, which is the object on which the expression operates. A typical example is a ``MethodCall``. In this case, the ``getQualifier()`` predicate is used to get the expression on the left of the ``.``, and ``getArgument(int)`` is used to get the arguments of the call.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Element``

   -  ``ControlFlowElement``

      -  ``Expr``

         -  ``LocalVariableDeclExpr``

            -  ``LocalConstantDeclExpr``

         -  ``Operation``

            -  ``UnaryOperation``

               -  ``SizeofExpr``, ``PointerIndirectionExpr``, ``AddressOfExpr``

            -  ``BinaryOperation``

               -  ``ComparisonOperation``

                  -  ``EqualityOperation``

                     -  ``EQExpr``, ``NEExpr``
                     -  ``RelationalOperation``

                        -  ``GTExpr``, ``LTExpr``, ``GEExpr``, ``LEExpr``

            -  ``Assignment``

               -  ``AssignOperation``

                  -  ``AddOrRemoveEventExpr``

                     -  ``AddEventExpr``
                     -  ``RemoveEventExpr``

                  -  ``AssignArithmeticOperation``

                     -  ``AssignAddExpr``, ``AssignSubExpr``, ``AssignMulExpr``, ``AssignDivExpr``, ``AssignRemExpr``

                  -  ``AssignBitwiseOperation``

                     -  ``AssignAndExpr``, ``AssignOrExpr``, ``AssignXorExpr``, ``AssignLShiftExpr``, ``AssignRShiftExpr``

               -  ``AssignExpr``

                  -  ``MemberInitializer``

            -  ``ArithmeticOperation``

               -  ``UnaryArithmeticOperation``

                  -  ``UnaryMinusExpr``, ``UnaryPlusExpr``
                  -  ``MutatorOperation``

                     -  ``IncrementOperation``

                        -  ``PreIncrExpr``, ``PostIncrExpr``

                     -  ``DecrementOperation``

                        -  ``PreDecrExpr``, ``PostDecrExpr``

               -  ``BinaryArithmeticOperation``

                  -  ``AddExpr``, ``SubExpr``, ``MulExpr``, ``DivExpr``, ``RemExpr``

            -  ``BitwiseOperation``

               -  ``UnaryBitwiseOperation``

                  -  ``ComplementOperation``

               -  ``BinaryBitwiseOperation``

                  -  ``LShiftExpr``, ``RShiftExpr``, ``BitwiseAndExpr``, ``BitwiseOrExpr``, ``BitwiseXorExpr``

            -  ``LogicalOperation``

               -  ``UnaryLogicalOperation``

                  -  ``LogicalNotOperation``

               -  ``BinaryLogicalOperation``

                  -  ``LogicalAndExpr``, ``LogicalOrExpr``, ``NullCoalescingExpr``

               -  ``ConditionalExpr``

         -  ``ParenthesisedExpr``, ``CheckedExpr``, ``UncheckedExpr``, ``IsExpr``, ``AsExpr``, ``CastExpr``, ``TypeofExpr``, ``DefaultValueExpr``, ``AwaitExpr``, ``NameofExpr``, ``InterpolatedStringExpr``
         -  ``Access``

            -  ``ThisAccess``
            -  ``BaseAccess``
            -  ``MemberAccess``

               -  ``MethodAccess``

                  -  ``VirtualMethodAccess``

               -  ``FieldAccess``, ``PropertyAccess``, ``IndexerAccess``, ``EventAccess``, ``MethodAccess``

            -  ``AssignableAccess``

               -  ``VariableAccess``

                  -  ``ParameterAccess``
                  -  ``LocalVariableAccess``
                  -  ``LocalScopeVariableAccess``
                  -  ``FieldAccess``

                     -  ``MemberConstantAccess``

               -  ``PropertyAccess``

                  -  ``TrivialPropertyAccess``
                  -  ``VirtualPropertyAccess``

               -  ``IndexerAccess``

                  -  ``VirtualIndexerAccess``

               -  ``EventAccess``

                  -  ``VirtualEventAccess``

            -  ``TypeAccess``
            -  ``ArrayAccess``

         -  ``Call``

            -  ``PropertyCall``
            -  ``IndexerCall``
            -  ``EventCall``
            -  ``MethodCall``

               -  ``VirtualMethodCall``
               -  ``ElementInitializer``

            -  ``ConstructorInitializer``
            -  ``OperatorCall``

               -  ``MutatorOperatorCall``

            -  ``DelegateCall``
            -  ``ObjectCreation``

               -  ``DefaultValueTypeObjectCreation``
               -  ``TypeParameterObjectCreation``
               -  ``AnonymousObjectCreation``

         -  ``ObjectOrCollectionInitializer``

            -  ``ObjectInitializer``
            -  ``CollectionInitializer``

         -  ``DelegateCreation``

            -  ``ExplicitDelegateCreation``, ``ImplicitDelegateCreation``

         -  ``ArrayInitializer``
         -  ``ArrayCreation``
         -  ``AnonymousFunctionExpr``

            -  ``LambdaExpr``
            -  ``AnonymousMethodExpr``

         -  ``Literal``

            -  ``BoolLiteral``, ``CharLiteral``, ``IntegerLiteral``, ``IntLiteral``, ``LongLiteral``, ``UIntLiteral``, ``ULongLiteral``, ``RealLiteral``, ``FloatLiteral``, ``DoubleLiteral``, ``DecimalLiteral``, ``StringLiteral``, ``NullLiteral``

Predicates
~~~~~~~~~~

Useful predicates on ``Expr`` include:

-  ``getType()`` - gets the ``Type`` of the expression.
-  ``getValue()`` - gets the compile-time constant, if any.
-  ``hasValue()`` - whether the expression has a compile-time constant.
-  ``getEnclosingStmt()`` - gets the statement containing the expression, if any.
-  ``getEnclosingCallable()`` - gets the callable containing the expression, if any.
-  ``stripCasts()`` - remove all explicit or implicit casts.
-  ``isImplicit()`` - whether the expression was implicit, such as an implicit ``this`` qualifier (``ThisAccess``).

Examples
~~~~~~~~

Find calls to ``String.Format`` with just one argument:

.. code-block:: ql

   from MethodCall c
   where c.getTarget().hasQualifiedName("System.String.Format")
     and c.getNumberOfArguments() = 1
   select c, "Missing arguments to 'String.Format'."

Find all comparisons of floating point values:

.. code-block:: ql

   from ComparisonOperation cmp
   where (cmp instanceof EQExpr or cmp instanceof NEExpr)
     and cmp.getAnOperand().getType() instanceof FloatingPointType
   select cmp, "Comparison of floating point values."

Find hard-coded passwords:

.. code-block:: ql

   from Variable v, string value
   where v.getName().regexpMatch("[pP]ass(word|wd|)")
     and value = v.getAnAssignedValue().getValue()
   select v, "Hard-coded password '" + value + "'."

Exercises
~~~~~~~~~

Exercise 9: Limit the previous query to string types. Exclude empty passwords or null passwords. (`Answer <#exercise-9>`__)

Attributes
----------

C# attributes are represented by the class `Attribute <https://codeql.github.com/codeql-standard-libraries/csharp/semmle/code/cil/Attribute.qll/type.Attribute$Attribute.html>`__. They can be present on many C# elements, such as classes, methods, fields, and parameters. The database contains attributes from the source code and all assembly references.

The attribute of any ``Element`` can be obtained via ``getAnAttribute()``, whereas if you have an attribute, you can find its element via ``getTarget()``. These two query fragments are identical:

.. code-block:: ql

     attribute = element.getAnAttribute()
     element = attribute.getTarget() 

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Element``

   -  ``Attribute``

Predicates
~~~~~~~~~~

-  ``getTarget()`` - gets the ``Element`` to which this attribute applies.
-  ``getArgument(int)`` - gets the given argument of the attribute.
-  ``getType()`` - gets the type of this attribute. Note that the class name must end in ``"Attribute"``.

Examples
~~~~~~~~

Find all obsolete elements:

.. code-block:: ql

   from Element e, Attribute attribute
   where e = attribute.getTarget()
     and attribute.getType().hasName("ObsoleteAttribute")
   select e, "This is obsolete because " + attribute.getArgument(0).getValue()

Model NUnit test fixtures:

.. code-block:: ql

   class TestFixture extends Class
   {
     TestFixture() {
       this.getAnAttribute().getType().hasName("TestFixtureAttribute")
     }
     
     TestMethod getATest() {
       result = this.getAMethod()
     }
   }

   class TestMethod extends Method
   {
     TestMethod() {
       this.getAnAttribute().getType().hasName("TestAttribute")
     }
   }

   from TestFixture f
   select f, f.getATest()

Exercises
~~~~~~~~~

Exercise 10: Write a query to find just obsolete methods. (`Answer <#exercise-10>`__)

Exercise 11: Write a query to find all places where the ``Obsolete`` attribute is used without a reason string (that is, ``[Obsolete]``). (`Answer <#exercise-11>`__)

Exercise 12: In the first example, what happens if the ``Obsolete`` attribute doesn't have a reason string? How could the query be fixed to accommodate this? (`Answer <#exercise-12>`__)

--------------

Answers
-------

Exercise 1
~~~~~~~~~~

.. code-block:: ql

   from AddExpr op
   select op

or

.. code-block:: ql

   select any(AddExpr op)

Exercise 2
~~~~~~~~~~

.. code-block:: ql

   from File f
   where f.getNumberOfLines() = max(any(File g).getNumberOfLines())
   select f

Exercise 3
~~~~~~~~~~

.. code-block:: ql

   from StringType s
   select s.getAMethod()

Exercise 4
~~~~~~~~~~

.. code-block:: ql

   from Interface ienumerable
   where ienumerable.hasQualifiedName("System.Collections.IEnumerable")
   select ienumerable.getASubType*()

Exercise 5
~~~~~~~~~~

.. code-block:: ql

   from Class a
   where a.getName().toLowerCase().matches("a%")
   select a

Exercise 6
~~~~~~~~~~

.. code-block:: ql

   select any(Method m | m.getBody().(BlockStmt).isEmpty())

Exercise 7
~~~~~~~~~~

.. code-block:: ql

   from IfStmt ifStmt
   where ifStmt.getThen().(BlockStmt).isEmpty() or ifStmt.getThen() instanceof EmptyStmt
   select ifStmt, "If statement with empty 'then' block."

Exercise 8
~~~~~~~~~~

.. code-block:: ql

   from IfStmt ifStmt
   where (ifStmt.getThen().(BlockStmt).isEmpty() or ifStmt.getThen() instanceof EmptyStmt)
     and not ifStmt.getElse() instanceof IfStmt
   select ifStmt, "If statement with empty 'then' block."

Exercise 9
~~~~~~~~~~

.. code-block:: ql

   from Variable v, StringLiteral value
   where v.getName().regexpMatch("[pP]ass(word|wd|)")
     and value = v.getAnAssignedValue()
     and value.getValue() != ""
   select v, "Hard-coded password '" + value.getValue() + "'."

Exercise 10
~~~~~~~~~~~

.. code-block:: ql

   from Method method, Attribute attribute
   where method = attribute.getTarget()
     and attribute.getType().hasName("ObsoleteAttribute")
   select method, "This is obsolete because " + attribute.getArgument(0).getValue()

Exercise 11
~~~~~~~~~~~

.. code-block:: ql

   from Attribute attribute
   where attribute.getType().hasName("ObsoleteAttribute")
     and not exists(attribute.getArgument(0))
   select attribute, "Missing reason in 'Obsolete' attribute."

Exercise 12
~~~~~~~~~~~

The query does not return results where the argument is missing.

Here is the fixed version:

.. code-block:: ql

   from Element e, Attribute attribute, string reason
   where e = attribute.getTarget()
     and attribute.getType().hasName("ObsoleteAttribute")
     and if exists(attribute.getArgument(0)) 
       then reason = attribute.getArgument(0).getValue() 
       else reason = "(not given)"
   select e, "This is obsolete because " + reason

Further reading
---------------

.. include:: ../reusables/csharp-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
