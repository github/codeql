.. _codeql-library-for-typescript:

CodeQL library for TypeScript
=============================

When you're analyzing a TypeScript program, you can make use of the large collection of classes in the CodeQL library for TypeScript.

Overview
--------

Support for analyzing TypeScript code is bundled with the CodeQL libraries for JavaScript, so you can include the full TypeScript library by importing the ``javascript.qll`` module:

.. code-block:: ql

   import javascript

:doc:`CodeQL libraries for JavaScript <codeql-library-for-javascript>` covers most of this library, and is also relevant for TypeScript analysis. This document supplements the JavaScript documentation with the TypeScript-specific classes and predicates.

Syntax
------

Most syntax in TypeScript is represented in the same way as its JavaScript counterpart. For example, ``a+b`` is represented by an `AddExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AddExpr.html>`__; the same as it would be in JavaScript. On the other hand, ``x as number`` is represented by `TypeAssertion <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeAssertion.html>`__, a class that is specific to TypeScript.

Type annotations
~~~~~~~~~~~~~~~~

The `TypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeExpr.html>`__ class represents anything that is part of a type annotation.

Only type annotations that are explicit in the source code occur as a ``TypeExpr``. Types inferred by the TypeScript compiler are ``Type`` entities; for details about this, see the section on `static type information <#static-type-information>`__.

There are several ways to access type annotations, for example:

-  ``VariableDeclaration.getTypeAnnotation()``
-  ``Function.getReturnTypeAnnotation()``
-  ``BindingPattern.getTypeAnnotation()``
-  ``Parameter.getTypeAnnotation()`` (special case of ``BindingPattern.getTypeAnnotation()``)
-  ``VarDecl.getTypeAnnotation()`` (special case of ``BindingPattern.getTypeAnnotation()``)
-  ``FieldDeclaration.getTypeAnnotation()``

The `TypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeExpr.html>`__ class provides some convenient member predicates such as ``isString()`` and ``isVoid()`` to recognize commonly used types.

The subclasses that represent type annotations are:

-  `TypeAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeAccess.html>`__: a name referring to a type, such as ``Date`` or ``http.ServerRequest``.

   -  `LocalTypeAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalTypeAccess.html>`__: an unqualified name, such as ``Date``.
   -  `QualifiedTypeAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$QualifiedTypeAccess.html>`__: a name prefixed by a namespace, such as ``http.ServerRequest``.
   -  `ImportTypeAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ImportTypeAccess.html>`__: an ``import`` used as a type, such as ``import("./foo")``.

-  `PredefinedTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$PredefinedTypeExpr.html>`__: a predefined type, such as ``number``, ``string``, ``void``, or ``any``.
-  `ThisTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ThisTypeExpr.html>`__: the ``this`` type.
-  `InterfaceTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$InterfaceTypeExpr.html>`__, also known as a literal type, such as ``{x: number}``.
-  `FunctionTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$FunctionTypeExpr.html>`__: a type such as ``(x: number) => string``.
-  `GenericTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$GenericTypeExpr.html>`__: a named type with type arguments, such as ``Array<string>``.
-  `LiteralTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LiteralTypeExpr.html>`__: a string, number, or boolean constant used as a type, such as ``'foo'``.
-  `ArrayTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ArrayTypeExpr.html>`__: a type such as ``string[]``.
-  `UnionTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$UnionTypeExpr.html>`__: a type such as ``string | number``.
-  `IntersectionTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$IntersectionTypeExpr.html>`__: a type such as ``S & T``.
-  `IndexedAccessTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$IndexedAccessTypeExpr.html>`__: a type such as ``T[K]``.
-  `ParenthesizedTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ParenthesizedTypeExpr.html>`__: a type such as ``(string)``.
-  `TupleTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TupleTypeExpr.html>`__: a type such as ``[string, number]``.
-  `KeyofTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$KeyofTypeExpr.html>`__: a type such as ``keyof T``.
-  `TypeofTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeofTypeExpr.html>`__: a type such as ``typeof x``.
-  `IsTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$IsTypeExpr.html>`__: a type such as ``x is string``.
-  `MappedTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$MappedTypeExpr.html>`__: a type such as ``{ [K in C]: T }``.

There are some subclasses that may be part of a type annotation, but are not themselves types:

-  `TypeParameter <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeParameter.html>`__: a type parameter declared on a type or function, such as ``T`` in ``class C<T> {}``.
-  `NamespaceAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$NamespaceAccess.html>`__: a name referring to a namespace from inside a type, such as ``http`` in ``http.ServerRequest``.

   -  `LocalNamespaceAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalNamespaceAccess.html>`__: the initial identifier in a prefix, such as ``http`` in ``http.ServerRequest``.
   -  `QualifiedNamespaceAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$QualifiedNamespaceAccess.html>`__: a qualified name in a prefix, such as ``net.client`` in ``net.client.Connection``.
   -  `ImportNamespaceAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ImportNamespaceAccess.html>`__: an ``import`` used as a namespace in a type, such as in ``import("http").ServerRequest``.

-  `VarTypeAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$VarTypeAccess.html>`__: a reference to a value from inside a type, such as ``x`` in ``typeof x`` or ``x is string``.

Function signatures
~~~~~~~~~~~~~~~~~~~

The `Function <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Functions.qll/type.Functions$Function.html>`__ class is a broad class that includes both concrete functions and function signatures.

Function signatures can take several forms:

-  Function types, such as ``(x: number) => string``.
-  Abstract methods, such as ``abstract foo(): void``.
-  Overload signatures, such as ``foo(x: number): number`` followed by an implementation of ``foo``.
-  Call signatures, such as in ``{ (x: string): number }``.
-  Index signatures, such as in ``{ [x: string]: number }``.
-  Functions in an ambient context, such as ``declare function foo(x: number): string``.

We recommend that you use the predicate ``Function.hasBody()`` to distinguish concrete functions from signatures.

Type parameters
~~~~~~~~~~~~~~~

The `TypeParameter <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeParameter.html>`__ class represents type parameters, and the `TypeParameterized <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeParameterized.html>`__ class represents entities that can declare type parameters. Classes, interfaces, type aliases, functions, and mapped type expressions are all ``TypeParameterized``.

You can access type parameters using the following predicates:

-  ``TypeParameterized.getTypeParameter(n)`` gets the ``n``\ th declared type parameter.
-  ``TypeParameter.getHost()`` gets the entity declaring a given type parameter.

You can access type arguments using the following predicates:

-  ``GenericTypeExpr.getTypeArgument(n)`` gets the ``n``\ th type argument of a type.
-  ``TypeAccess.getTypeArgument(n)`` is a convenient alternative for the above (a `TypeAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeAccess.html>`__ with type arguments is wrapped in a `GenericTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$GenericTypeExpr.html>`__).
-  ``InvokeExpr.getTypeArgument(n)`` gets the ``n``\ th type argument of a call.
-  ``ExpressionWithTypeArguments.getTypeArgument(n)`` gets the ``n``\ th type argument of a generic superclass expression.

To select references to a given type parameter, use ``getLocalTypeName()`` (see `Name binding <#name-binding>`__ below).

Examples
^^^^^^^^

Select expressions that cast a value to a type parameter:

.. code-block:: ql

   import javascript

   from TypeParameter param, TypeAssertion assertion
   where assertion.getTypeAnnotation() = param.getLocalTypeName().getAnAccess()
   select assertion, "Cast to type parameter."

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505979606441/>`__.

Classes and interfaces
~~~~~~~~~~~~~~~~~~~~~~

The CodeQL class `ClassOrInterface <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ClassOrInterface.html>`__ is a common supertype of classes and interfaces, and provides some TypeScript-specific member predicates:

-  ``ClassOrInterface.isAbstract()`` holds if this is an interface or a class with the ``abstract`` modifier.
-  ``ClassOrInterface.getASuperInterface()`` gets a type from the ``implements`` clause of a class or from the ``extends`` clause of an interface.
-  ``ClassOrInterface.getACallSignature()`` gets a call signature of an interface, such as in ``{ (arg: string): number }``.
-  ``ClassOrInterface.getAnIndexSignature()`` gets an index signature, such as in ``{ [key: string]: number }``.
-  ``ClassOrInterface.getATypeParameter()`` gets a declared type parameter (special case of ``TypeParameterized.getATypeParameter()``).

Note that the superclass of a class is an expression, not a type annotation. If the superclass has type arguments, it will be an expression of kind `ExpressionWithTypeArguments <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ExpressionWithTypeArguments.html>`__.

Also see the documentation for classes in the "`CodeQL libraries for JavaScript <https://codeql.github.com/docs/codeql-language-guides/codeql-library-for-javascript/#classes>`__."

To select the type references to a class or an interface, use ``getTypeName()``.

Statements
~~~~~~~~~~

The following are TypeScript-specific statements:

-  `NamespaceDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$NamespaceDeclaration.html>`__: a statement such as ``namespace M {}``.
-  `EnumDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$EnumDeclaration.html>`__: a statement such as ``enum Color { red, green, blue }``.
-  `TypeAliasDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeAliasDeclaration.html>`__: a statement such as ``type A = number``.
-  `InterfaceDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$InterfaceDeclaration.html>`__: a statement such as ``interface Point { x: number; y: number; }``.
-  `ImportEqualsDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ImportEqualsDeclaration.html>`__: a statement such as ``import fs = require("fs")``.
-  `ExportAssignDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ExportAssignDeclaration.html>`__: a statement such as ``export = M``.
-  `ExportAsNamespaceDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ExportAsNamespaceDeclaration.html>`__: a statement such as ``export as namespace M``.
-  `ExternalModuleDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ExternalModuleDeclaration.html>`__: a statement such as ``module "foo" {}``.
-  `GlobalAugmentationDeclaration <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$GlobalAugmentationDeclaration.html>`__: a statement such as ``global {}``

Expressions
~~~~~~~~~~~

The following are TypeScript-specific expressions:

-  `ExpressionWithTypeArguments <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ExpressionWithTypeArguments.html>`__: occurs when the ``extends`` clause of a class has type arguments, such as in ``class C extends D<string>``.
-  `TypeAssertion <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeAssertion.html>`__: asserts that a value has a given type, such as ``x as number`` or ``<number> x``.
-  `NonNullAssertion <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$NonNullAssertion.html>`__: asserts that a value is not null or undefined, such as ``x!``.
-  `ExternalModuleReference <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$ExternalModuleReference.html>`__: a ``require`` call on the right-hand side of an import-assign, such as ``import fs = require("fs")``.

Ambient declarations
~~~~~~~~~~~~~~~~~~~~

Type annotations, interfaces, and type aliases are considered ambient AST nodes, as is anything with a ``declare`` modifier.

The predicate ``ASTNode.isAmbient()`` can be used to determine if an AST node is ambient.

Ambient nodes are mostly ignored by control flow and data flow analysis. The outermost part of an ambient declaration has a single no-op node in the control flow graph, and it has no internal control flow.

Static type information
-----------------------

Static type information and global name binding is available for projects with "full" TypeScript extraction enabled. This option is enabled by default for projects on LGTM.com and when you create databases with the :ref:`CodeQL CLI <codeql-cli>`.

Basic usage
~~~~~~~~~~~

The `Type <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$Type.html>`__ class represents a static type, such as ``number`` or ``string``. The type of an expression can be obtained with ``Expr.getType()``.

Types that refer to a specific named type can be recognized in various ways:

-  ``type.(TypeReference).hasQualifiedName(name)`` holds if the type refers to the given named type.
-  ``type.(TypeReference).hasUnderlyingType(name)`` holds if the type refers to the given named type or a transitive subtype thereof.
-  ``type.hasUnderlyingType(name)`` is like the above, but additionally holds if the reference is wrapped in a union and/or intersection type.

The ``hasQualifiedName`` and ``hasUnderlyingType`` predicates have two overloads:

-  The single-argument version takes a qualified name relative to the global scope.
-  The two-argument version takes the name of a module and qualified name relative to that module.

Example
^^^^^^^

The following query can be used to find all ``toString`` calls on a Node.js ``Buffer`` object:

.. code-block:: ql

   import javascript

   from MethodCallExpr call
   where call.getReceiver().getType().hasUnderlyingType("Buffer")
     and call.getMethodName() = "toString"
   select call

Working with types
~~~~~~~~~~~~~~~~~~

``Type`` entities are not associated with a specific source location. For instance, there can be many uses of the ``number`` keyword, but there is only one ``number`` type.

Some important member predicates of ``Type`` are:

-  ``Type.getProperty(name)`` gets the type of a named property.
-  ``Type.getMethod(name)`` gets the signature of a named method.
-  ``Type.getSignature(kind,n)`` gets the ``n``\ th overload of a call or constructor signature.
-  ``Type.getStringIndexType()`` gets the type of the string index signature.
-  ``Type.getNumberIndexType()`` gets the type of the number index signature.

A ``Type`` entity always belongs to exactly one of the following subclasses:

-  ``TypeReference``: a named type, possibly with type arguments.
-  ``UnionType``: a union type such as ``string | number``.
-  ``IntersectionType``: an intersection type such as ``T & U``.
-  ``TupleType``: a tuple type such as ``[string, number]``.
-  ``StringType``: the ``string`` type.
-  ``NumberType``: the ``number`` type.
-  ``AnyType``: the ``any`` type.
-  ``NeverType``: the ``never`` type.
-  ``VoidType``: the ``void`` type.
-  ``NullType``: the ``null`` type.
-  ``UndefinedType``: the ``undefined`` type.
-  ``ObjectKeywordType``: the ``object`` type.
-  ``SymbolType``: a ``symbol`` or ``unique symbol`` type.
-  ``AnonymousInterfaceType``: an anonymous type such as ``{x: number}``.
-  ``TypeVariableType``: a reference to a type variable.
-  ``ThisType``: the ``this`` type within a specific type.
-  ``TypeofType``: the type of a named value, such as ``typeof X``.
-  ``BooleanLiteralType``: the ``true`` or ``false`` type.
-  ``StringLiteralType``: the type of a string constant.
-  ``NumberLiteralType``: the type of a number constant.

Additionally, ``Type`` has the following subclasses which overlap partially with those above:

-  ``BooleanType``: the type ``boolean``, internally represented as the union type ``true | false``.
-  ``PromiseType``: a type that describes a promise such as ``Promise<T>``.
-  ``ArrayType``: a type that describes an array object, possibly a tuple type.

   -  ``PlainArrayType``: a type of form ``Array<T>``.
   -  ``ReadonlyArrayType``: a type of form ``ReadonlyArray<T>``.

-  ``LiteralType``: a boolean, string, or number literal type.
-  ``NumberLikeType``: the ``number`` type or a number literal type.
-  ``StringLikeType``: the ``string`` type or a string literal type.
-  ``BooleanLikeType``: the ``true``, ``false``, or ``boolean`` type.

Canonical names and named types
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``CanonicalName`` is a CodeQL class representing a qualified name relative to a root scope, such as a module or the global scope. It typically represents an entity such as a type, namespace, variable, or function. ``TypeName`` and ``Namespace`` are subclasses of this class.

Canonical names can be recognized using the ``hasQualifiedName`` predicate:

-  ``hasQualifiedName(name)`` holds if the qualified name is ``name`` relative to the global scope.
-  ``hasQualifiedName(module,name)`` holds if the qualified name is ``name`` relative to the given module name.

For convenience, this predicate is also available on other classes, such as ``TypeReference`` and ``TypeofType``, where it forwards to the underlying canonical name.

Function types
~~~~~~~~~~~~~~

There is no CodeQL class for function types, as any type with a call or construct signature is usable as a function. The type ``CallSignatureType`` represents such a signature (with or without the ``new`` keyword).

Signatures can be obtained in several ways:

-  ``Type.getFunctionSignature(n)`` gets the ``n``\ th overloaded function signature.
-  ``Type.getConstructorSignature(n)`` gets the ``n``\ th overloaded constructor signature.
-  ``Type.getLastFunctionSignature()`` gets the last declared function signature.
-  ``Type.getLastConstructorSignature()`` gets the last declared constructor signature.

Some important member predicates of ``CallSignatureType`` are:

-  ``CallSignatureType.getParameter(n)`` gets the type of the ``n``\ th parameter.
-  ``CallSignatureType.getParameterName(n)`` gets the name of the ``n``\ th parameter.
-  ``CallSignatureType.getReturnType()`` gets the return type.

Note that a signature is not associated with a specific declaration site.

Call resolution
~~~~~~~~~~~~~~~

Additional type information is available for invocation expressions:

-  ``InvokeExpr.getResolvedCallee()`` gets the callee as a concrete ``Function``.
-  ``InvokeExpr.getResolvedCalleeName()`` get the callee as a canonical name.
-  ``InvokeExpr.getResolvedSignature()`` gets the signature of the invoked function, with overloading resolved and type arguments substituted.

Note that these refer to the call target as determined by the type system. The actual call target may differ at runtime, for instance, if the target is a method that has been overridden in a subclass.

Inheritance and subtyping
~~~~~~~~~~~~~~~~~~~~~~~~~

The declared supertypes of a named type can be obtained using ``TypeName.getABaseTypeName()``.

This operates at the level of type names, hence the specific type arguments used in the inheritance chain are not available. However, these can often be deduced using ``Type.getProperty`` or ``Type.getMethod`` which both take inheritance into account.

This only accounts for types explicitly mentioned in the ``extends`` or ``implements`` clause of a type. There is no predicate that determines subtyping or assignability between types in general.

The following two predicates can be useful for recognising subtypes of a given type:

-  ``Type.unfold()`` unfolds unions and/or intersection types and get the underlying types, or the type itself if it is not a union or intersection.
-  ``Type.hasUnderlyingType(name)`` holds if the type is a reference to the given named type, possibly after unfolding unions/intersections and following declared supertypes.

Example
^^^^^^^

The following query can be used to find all classes that are React components, along with the type of their ``props`` property, which generally coincides with its first type argument:

.. code-block:: ql

   import javascript

   from ClassDefinition cls, TypeName name
   where name = cls.getTypeName()
     and name.getABaseTypeName+().hasQualifiedName("React.Component")
   select cls, name.getType().getProperty("props")

Name binding
------------

In TypeScript, names can refer to variables, types, and namespaces, or a combination of these.

These concepts are modeled as distinct entities: `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__, `TypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$TypeName.html>`__, and `Namespace <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$Namespace.html>`__. For example, the class ``C`` below introduces both a variable and a type:

.. code-block:: typescript

   class C {}
   let x = C; // refers to the variable C
   let y: C;  // refers to the type C

The variable ``C`` and the type ``C`` are modeled as distinct entities. One is a `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__, the other is a `TypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$TypeName.html>`__.

TypeScript also allows you to import types and namespaces, and give them local names in different scopes. For example, the import below introduces a local type name ``B``:

.. code-block:: typescript

   import {C as B} from "./foo"

The local name ``B`` is represented as a `LocalTypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalTypeName.html>`__ named ``B``, restricted to just the file containing the import. An import statement can also introduce a `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__ and a `LocalNamespaceName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalNamespaceName.html>`__.

The following table shows the relevant classes for working with each kind of name. The classes are described in more detail below.

+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
|   Kind    |                                                                           Local alias                                                                            |                                                                     Canonical name                                                                     |                                                                             Definition                                                                              |                                                                           Access                                                                           |
+===========+==================================================================================================================================================================+========================================================================================================================================================+=====================================================================================================================================================================+============================================================================================================================================================+
| Value     | `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__                       |                                                                                                                                                        |                                                                                                                                                                     | `VarAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarAccess.html>`__               |
+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Type      | `LocalTypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalTypeName.html>`__           | `TypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$TypeName.html>`__   | `TypeDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeDefinition.html>`__            | `TypeAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeAccess.html>`__           |
+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Namespace | `LocalNamespaceName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalNamespaceName.html>`__ | `Namespace <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$Namespace.html>`__ | `NamespaceDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$NamespaceDeclaration.html>`__ | `NamespaceAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$NamespaceAccess.html>`__ |
+-----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------+

**Note:** ``TypeName`` and ``Namespace`` are only populated if the database is generated using full TypeScript extraction. ``LocalTypeName`` and ``LocalNamespaceName`` are always populated.

Type names
~~~~~~~~~~

A `TypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$TypeName.html>`__ is a qualified name for a type and is not bound to a specific lexical scope. The `TypeDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$TypeDefinition.html>`__ class represents an entity that defines a type, namely a class, interface, type alias, enum, or enum member. The relevant predicates for working with type names are:

-  ``TypeAccess.getTypeName()`` gets the qualified name being referenced (if any).
-  ``TypeDefinition.getTypeName()`` gets the qualified name of a class, interface, type alias, enum, or enum member.
-  ``TypeName.getAnAccess()``, gets an access to a given type.
-  ``TypeName.getADefinition()``, get a definition of a given type. Note that interfaces can have multiple definitions.

A `LocalTypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalTypeName.html>`__ behaves like a block-scoped variable, that is, it has an unqualified name and is restricted to a specific scope. The relevant predicates are:

-  ``LocalTypeAccess.getLocalTypeName()`` gets the local name referenced by an unqualified type access.
-  ``LocalTypeName.getAnAccess()`` gets an access to a local type name.
-  ``LocalTypeName.getADeclaration()`` gets a declaration of this name.
-  ``LocalTypeName.getTypeName()`` gets the qualified name to which this name refers.

Examples
^^^^^^^^

Find references that omit type arguments to a generic type.

It is best to use `TypeName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$TypeName.html>`__ to resolve through imports and qualified names:

.. code-block:: ql

   import javascript

   from TypeDefinition def, TypeAccess access
   where access.getTypeName().getADefinition() = def
     and def.(TypeParameterized).hasTypeParameters()
     and not access.hasTypeArguments()
   select access, "Type arguments are omitted"

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505985316500/>`__.

Find imported names that are used as both a type and a value:

.. code-block:: ql

   import javascript

   from ImportSpecifier spec
   where exists (LocalTypeAccess access | access.getLocalTypeName().getADeclaration() = spec.getLocal())
     and exists (VarAccess access | access.getVariable().getADeclaration() = spec.getLocal())
   select spec, "Used as both variable and type"

➤ `See this in the query console on LGTM.com <https://lgtm.com/query/1505975787348/>`__.

Namespace names
~~~~~~~~~~~~~~~

Namespaces are represented by the classes `Namespace <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$Namespace.html>`__ and `LocalNamespaceName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalNamespaceName.html>`__. The `NamespaceDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$NamespaceDefinition.html>`__ class represents a syntactic definition of a namespace, which includes ordinary namespace declarations as well as enum declarations.

Note that these classes deal exclusively with namespaces referenced from inside type annotations, not through expressions.

A `Namespace <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CanonicalNames.qll/type.CanonicalNames$Namespace.html>`__ is a qualified name for a namespace, and is not bound to a specific scope. The relevant predicates for working with namespaces are:

-  ``NamespaceAccess.getNamespace()`` gets the namespace being referenced by a namespace access.
-  ``NamespaceDefinition.getNamespace()`` gets the namespace defined by a namespace or enum declaration.
-  ``Namespace.getAnAccess()`` gets an access to a namespace from inside a type.
-  ``Namespace.getADefinition()`` gets a definition of this namespace. Note that namespaces can have multiple definitions.
-  ``Namespace.getNamespaceMember(name)`` gets an inner namespace with a given name.
-  ``Namespace.getTypeMember(name)`` gets a type exported under a given name.
-  ``Namespace.getAnExportingContainer()`` gets a `StmtContainer <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$StmtContainer.html>`__ whose exports contribute to this namespace. This can be a the body of a namespace declaration or the top-level of a module. Enums have no exporting containers.

A `LocalNamespaceName <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/TypeScript.qll/type.TypeScript$LocalNamespaceName.html>`__ behaves like a block-scoped variable, that is, it has an unqualified name and is restricted to a specific scope. The relevant predicates are:

-  ``LocalNamespaceAccess.getLocalNamespaceName()`` gets the local name referenced by an identifier.
-  ``LocalNamespaceName.getAnAccess()`` gets an identifier that refers to this local name.
-  ``LocalNamespaceName.getADeclaration()`` gets an identifier that declares this local name.
-  ``LocalNamespaceName.getNamespace()`` gets the namespace to which this name refers.

Further reading
---------------

.. include:: ../reusables/javascript-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
