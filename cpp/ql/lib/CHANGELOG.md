## 3.2.0

### New Features

* Add a new predicate `getAnIndirectBarrier` to the parameterized module `InstructionBarrierGuard` in `semmle.code.cpp.dataflow.new.DataFlow` for computing indirect dataflow nodes that are guarded by a given instruction. This predicate is similar to the `getAnIndirectBarrier` predicate on the parameterized module `BarrierGuard`.
* A new predicate `getDecltype` was added to the `ProxyClass` class, which yields the decltype for the proxy class.
* Template classes that are of `struct` type are now also instances of the `Struct` class.
* Template classes that are of `union` type are now also instances of the `Union` class.
* A new abstract class `ConfigurationTestFile` (`semmle.code.cpp.ConfigurationTestFile.ConfigurationTestFile`) was introduced, which represents files created to test the build configuration. A subclass `CmakeTryCompileFile` of `ConfigurationTestFile` was also introduced, which represents files created by CMake to test the build configuration.
* New predicates `getARequiresClause`, `getTemplateRequiresClause` and `getFunctionRequiresClause` were added to the `FunctionDeclarationEntry` class, which yield the requires clauses when the entry represents a function template declaration with requires clauses.
* A new predicate `getRequiresClause` was added to the `TypeDeclarationEntry` class, which yields the requires clause when the entry represents a class template declaration with a requires clause.
* A new predicate `getRequiresClause` was added to the `VariableDeclarationEntry` class, which yields the requires clause when the entry represents a variable template declaration with a requires clause.
* A new predicate `getTypeConstraint` was added to the `TypeTemplateParameter` class, which yields the type constraint of the parameter if it exists.
* A new class `VariableTemplateSpecialization` was introduced, which represents explicit specializations of variable templates.
* A new predicate `isSpecialization` was added to the `Variable` class, which holds if the variable is a template specialization.
* A new class `ConceptIdExpr` was introduced, which represents C++20 concept id expressions.
* A new class `Concept` was introduced, which represents C++20 concepts.
* The `getTemplateArgumentType` and `getTemplateArgumentValue` predicates of the `Declaration` class now also yield template arguments of concepts.
* A new class `ConstevalIfStmt` was introduced, which represents the C++23 `if consteval` and `if ! consteval` statements.

### Minor Analysis Improvements

* `DefaultOptions::exits` now holds for C23 functions with the `_Noreturn` or `___Noreturn__` attribute.

## 3.1.0

### Deprecated APIs

* The `TemplateParameter` class, representing C++ type template parameters has been deprecated. Use `TypeTemplateParameter` instead.

### New Features

* New classes `SizeofPackExprOperator` and `SizeofPackTypeOperator` were introduced, which represent the C++ `sizeof...` operator taking expressions and type arguments, respectively.
* A new class `TemplateTemplateParameterInstantiation` was introduced, which represents instantiations of template template parameters.
* A new predicate `getAnInstantiation` was added to the `TemplateTemplateParameter` class, which yields instantiations of template template parameters.
* The `getTemplateArgumentType` and `getTemplateArgumentValue` predicates of the `Declaration` class now also yield template arguments of template template parameters.
* A new class `NonTypeTemplateParameter` was introduced, which represents C++ non-type template parameters.
* A new class `TemplateParameterBase` was introduced, which represents C++ non-type template parameters, type template parameters, and template template parameters.

### Minor Analysis Improvements

* The `Guards` library (`semmle.code.cpp.controlflow.Guards`) has been improved to recognize more guard conditions.

## 3.0.0

### Breaking Changes

* Deleted the old deprecated data flow API that was based on extending a configuration class. See https://github.blog/changelog/2023-08-14-new-dataflow-api-for-writing-custom-codeql-queries for instructions on migrating your queries to use the new API.

### Deprecated APIs

* The `NonThrowingFunction` class (`semmle.code.cpp.models.interfaces.NonThrowing.NonThrowingFunction`) has been deprecated. Please use the `NonCppThrowingFunction` class instead.

## 2.1.1

No user-facing changes.

## 2.1.0

### New Features

* Added a new predicate `DataFlow::getARuntimeTarget` for getting a function that may be invoked by a `Call` expression. Unlike `Call.getTarget` this new predicate may also resolve function pointers.
* Added the predicate `mayBeFromImplicitlyDeclaredFunction()` to the `Call` class to represent calls that may be the return value of an implicitly declared C function.
* Added the predicate `getAnExplicitDeclarationEntry()` to the `Function` class to get a `FunctionDeclarationEntry` that is not implicit.
* Added classes `RequiresExpr`, `SimpleRequirementExpr`, `TypeRequirementExpr`, `CompoundRequirementExpr`, and `NestedRequirementExpr` to represent C++20 requires expressions and the simple, type, compound, and nested requirements that can occur in `requires` expressions.

### Minor Analysis Improvements

* The function call target resolution algorithm has been improved to resolve more calls through function pointers. As a result, dataflow queries may have more results.

## 2.0.2

### Minor Analysis Improvements

* Added taint flow model for `fopen` and related functions.
* The `SimpleRangeAnalysis` library (`semmle.code.cpp.rangeanalysis.SimpleRangeAnalysis`) now generates more precise ranges for calls to `fgetc` and `getc`.

## 2.0.1

No user-facing changes.

## 2.0.0

### Breaking Changes

* Deleted many deprecated taint-tracking configurations based on `TaintTracking::Configuration`. 
* Deleted many deprecated dataflow configurations based on `DataFlow::Configuration`. 
* Deleted the deprecated `hasQualifiedName` and `isDefined` predicates from the `Declaration` class, use `hasGlobalName` and `hasDefinition` respectively instead.
* Deleted the `getFullSignature` predicate from the `Function` class, use `getIdentityString(Declaration)` from `semmle.code.cpp.Print` instead.
* Deleted the deprecated `freeCall` predicate from `Alloc.qll`. Use `DeallocationExpr` instead.
* Deleted the deprecated `explorationLimit` predicate from `DataFlow::Configuration`, use `FlowExploration<explorationLimit>` instead.
* Deleted the deprecated `getFieldExpr` predicate from `ClassAggregateLiteral`, use `getAFieldExpr` instead.
* Deleted the deprecated `getElementExpr` predicate from `ArrayOrVectorAggregateLiteral`, use `getAnElementExpr` instead.

### New Features

* Added a class `C11GenericExpr` to represent C11 generic selection expressions. The generic selection is represented as a `Conversion` on the expression that will be selected.
* Added subclasses of `BuiltInOperations` for the `__is_scoped_enum`, `__is_trivially_equality_comparable`, and `__is_trivially_relocatable` builtin operations.
* Added a subclass of `Expr` for `__datasizeof` expressions.

### Minor Analysis Improvements

* Added a data flow model for `swap` member functions, which were previously modeled as taint tracking functions. This change improves the precision of queries where flow through `swap` member functions might affect the results.
* Added a data flow model for `realloc`-like functions, which were previously modeled as a taint tracking functions. This change improves the precision of queries where flow through `realloc`-like functions might affect the results.

## 1.4.2

No user-facing changes.

## 1.4.1

No user-facing changes.

## 1.4.0

### New Features

* A `getTemplateClass` predicate was added to the `DeductionGuide` class to get the class template for which the deduction guide is a guide.
* An `isExplicit` predicate was added to the `Function` class that determines whether the function was declared as explicit.
* A `getExplicitExpr` predicate was added to the `Function` class that yields the constant boolean expression (if any) that conditionally determines whether the function is explicit.
* A `isDestroyingDeleteDeallocation` predicate was added to the `NewOrNewArrayExpr` and `DeleteOrDeleteArrayExpr` classes to indicate whether the deallocation function is a destroying delete. 

### Minor Analysis Improvements

* The controlling expression of a `constexpr if` is now always recognized as an unevaluated expression.
* Improved performance of alias analysis of large function bodies. In rare cases, alerts that depend on alias analysis of large function bodies may be affected.
* A `UsingEnumDeclarationEntry` class has been added for C++ `using enum` declarations. As part of this, synthesized `UsingDeclarationEntry`s are no longer emitted for individual enumerators of the referenced enumeration.

## 1.3.0

### New Features

* Models-as-data alert provenance information has been extended to the C/C++ language. Any qltests that include the edges relation in their output (for example, `.qlref`s that reference path-problem queries) will need to be have their expected output updated accordingly.
* Added subclasses of `BuiltInOperations` for `__builtin_has_attribute`, `__builtin_is_corresponding_member`, `__builtin_is_pointer_interconvertible_with_class`, `__is_assignable_no_precondition_check`, `__is_bounded_array`, `__is_convertible`, `__is_corresponding_member`, `__is_nothrow_convertible`, `__is_pointer_interconvertible_with_class`, `__is_referenceable`, `__is_same_as`, `__is_trivially_copy_assignable`, `__is_unbounded_array`, `__is_valid_winrt_type`, `_is_win_class`, `__is_win_interface`, `__reference_binds_to_temporary`, `__reference_constructs_from_temporary`, and `__reference_converts_from_temporary`.
* The class `NewArrayExpr` adds a predicate `getArraySize()` to allow a more convenient way to access the static size of the array when the extent is missing.

## 1.2.0

### New Features

* The syntax for models-as-data rows has been extended to make it easier to select sources, sinks, and summaries that involve templated functions and classes. Additionally, the syntax has also been extended to make it easier to specify models with arbitrary levels of indirection. See `dataflow/ExternalFlow.qll` for the updated documentation and specification for the model format.
* It is now possible to extend the classes `AllocationFunction` and `DeallocationFunction` via data extensions. Extensions of these classes should be added to the `lib/ext/allocation` and `lib/ext/deallocation` directories respectively.

### Minor Analysis Improvements

* The queries "Potential double free" (`cpp/double-free`) and "Potential use after free" (`cpp/use-after-free`) now produce fewer false positives.
* The "Guards" library (`semmle.code.cpp.controlflow.Guards`) now also infers guards from calls to the builtin operation `__builtin_expect`. As a result, some queries may produce fewer false positives.

## 1.1.1

No user-facing changes.

## 1.1.0

### New Features

* Data models can now be added with data extensions. In this way source, sink and summary models can be added in extension `.model.yml` files, rather than by writing classes in QL code. New models should be added in the `lib/ext` folder.

### Minor Analysis Improvements

* A partial model for the `Boost.Asio` network library has been added. This includes sources, sinks and summaries for certain functions in `Boost.Asio`, such as `read_until` and `write`.

## 1.0.0

### Breaking Changes

* CodeQL package management is now generally available, and all GitHub-produced CodeQL packages have had their version numbers increased to 1.0.0.

## 0.13.1

No user-facing changes.

## 0.13.0

### Breaking Changes

* Deleted the deprecated `GlobalValueNumberingImpl.qll` implementation.

### New Features

* Models-as-Data support has been added for C/C++. This feature allows flow sources, sinks and summaries to be expressed in compact strings as an alternative to modelling each source / sink / summary with explicit QL. See `dataflow/ExternalFlow.qll` for documentation and specification of the model format, and `models/implementations/ZMQ.qll` for a simple example of models. Importing models from `.yml` is not yet supported.

### Minor Analysis Improvements

* Source models have been added for the standard library function `getc` (and variations).
* Source, sink and flow models for the ZeroMQ (ZMQ) networking library have been added.
* Parameters of functions without definitions now have `ParameterNode`s.
* The alias analysis used internally by various libraries has been improved to answer alias questions more conservatively. As a result, some queries may report fewer false positives.

## 0.12.11

No user-facing changes.

## 0.12.10

### New Features

* Added a `TaintInheritingContent` class that can be extended to model taint flowing from a qualifier to a field.
* Added a predicate `GuardCondition.comparesEq/4` to query whether an expression is compared to a constant. 
* Added a predicate `GuardCondition.ensuresEq/4` to query whether a basic block is guarded by an expression being equal to a constant.
* Added a predicate `GuardCondition.comparesLt/4` to query whether an expression is compared to a constant. 
* Added a predicate `GuardCondition.ensuresLt/4` to query whether a basic block is guarded by an expression being less than a constant.
* Added a predicate `GuardCondition.valueControls` to query whether a basic block is guarded by a particular `case` of a `switch` statement.

### Minor Analysis Improvements

* Added destructors for temporary objects with extended lifetimes to the intermediate representation.

## 0.12.9

No user-facing changes.

## 0.12.8

No user-facing changes.

## 0.12.7

### Minor Analysis Improvements

* Added destructors for named objects to the intermediate representation.

## 0.12.6

### New Features

* A `getInitialization` predicate was added to the `RangeBasedForStmt` class that yields the C++20-style initializer of the range-based `for` statement when it exists.

## 0.12.5

### New Features

* Added the `PreprocBlock.qll` library to this repository.  This library offers a view of `#if`, `#elif`, `#else` and similar directives as a tree with navigable parent-child relationships.
* Added a new `ThrowingFunction` abstract class that can be used to model an external function that may throw an exception.

## 0.12.4

### Minor Analysis Improvements

* Deleted many deprecated predicates and classes with uppercase `XML`, `SSA`, `SAL`, `SQL`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `StrcatFunction` class, use `semmle.code.cpp.models.implementations.Strcat.qll` instead.

## 0.12.3

### Deprecated APIs

* The `isUserInput`, `userInputArgument`, and `userInputReturned` predicates from `SecurityOptions` have been deprecated. Use `FlowSource` instead.

### New Features

* `UserDefineLiteral` and `DeductionGuide` classes have been added, representing C++11 user defined literals and C++17 deduction guides.

### Minor Analysis Improvements

* Changed the output of `Node.toString` to better reflect how many indirections a given dataflow node has.
* Added a new predicate `Node.asDefinition` on `DataFlow::Node`s for selecting the dataflow node corresponding to a particular definition.
* The deprecated `DefaultTaintTracking` library has been removed.
* The `Guards` library has been replaced with the API-compatible `IRGuards` implementation, which has better precision in some cases.

### Bug Fixes

* Under certain circumstances a function declaration that is not also a definition could be associated with a `Function` that did not have the definition as a `FunctionDeclarationEntry`. This is now fixed when only one definition exists, and a unique `Function` will exist that has both the declaration and the definition as a `FunctionDeclarationEntry`.

## 0.12.2

No user-facing changes.

## 0.12.1

### New Features

* Added an `isPrototyped` predicate to `Function` that holds when the function has a prototype.

## 0.12.0

### Breaking Changes

* The expressions `AssignPointerAddExpr` and `AssignPointerSubExpr` are no longer subtypes of `AssignBitwiseOperation`.

### Minor Analysis Improvements

* The "Returning stack-allocated memory" (`cpp/return-stack-allocated-memory`) query now also detects returning stack-allocated memory allocated by calls to `alloca`, `strdupa`, and `strndupa`.
* Added models for `strlcpy` and `strlcat`.
* Added models for the `sprintf` variants from the `StrSafe.h` header.
* Added SQL API models for `ODBC`.
* Added taint models for `realloc` and related functions.

## 0.11.0

### Breaking Changes

* The `Container` and `Folder` classes now derive from `ElementBase` instead of `Locatable`, and no longer expose the `getLocation` predicate. Use `getURL` instead.

### New Features

* Added a new class `AdditionalCallTarget` for specifying additional call targets.

### Minor Analysis Improvements

* More field accesses are identified as `ImplicitThisFieldAccess`.
* Added support for new floating-point types in C23 and C++23.

## 0.10.1

### Minor Analysis Improvements

* Deleted the deprecated `AnalysedString` class, use the new name `AnalyzedString`.
* Deleted the deprecated `isBarrierGuard` predicate from the dataflow library and its uses, use `isBarrier` and the `BarrierGuard` module instead.

## 0.10.0

### Minor Analysis Improvements

* Functions that do not return due to calling functions that don't return (e.g. `exit`) are now detected as
 non-returning in the IR and dataflow.
* Treat functions that reach the end of the function as returning in the IR.
  They used to be treated as unreachable but it is allowed in C. 
* The `DataFlow::asDefiningArgument` predicate now takes its argument from the range starting at `1` instead of `2`. Queries that depend on the single-parameter version of `DataFlow::asDefiningArgument` should have their arguments updated accordingly.

## 0.9.3

No user-facing changes.

## 0.9.2

### Deprecated APIs

* `getAllocatorCall` on `DeleteExpr` and `DeleteArrayExpr` has been deprecated. `getDeallocatorCall` should be used instead.

### New Features

* Added `DeleteOrDeleteArrayExpr` as a super type of `DeleteExpr` and `DeleteArrayExpr`

### Minor Analysis Improvements

* `delete` and `delete[]` are now modeled as calls to the relevant `operator delete` in the IR. In the case of a dynamic delete call a new instruction `VirtualDeleteFunctionAddress` is used to represent a function that dispatches to the correct delete implementation.
* Only the 2 level indirection of `argv` (corresponding to `**argv`) is consided for `FlowSource`.

## 0.9.1

No user-facing changes.

## 0.9.0

### Breaking Changes

* The `shouldPrintFunction` predicate from `PrintAstConfiguration` has been replaced by `shouldPrintDeclaration`. Users should now override `shouldPrintDeclaration` if they want to limit the declarations that should be printed.
* The `shouldPrintFunction` predicate from `PrintIRConfiguration` has been replaced by `shouldPrintDeclaration`. Users should now override `shouldPrintDeclaration` if they want to limit the declarations that should be printed.

### Major Analysis Improvements

* The `PrintAST` library now also prints global and namespace variables and their initializers.

### Minor Analysis Improvements

* The `_Float128x` type is no longer exposed as a builtin type. As this type could not occur any code base, this should only affect queries that explicitly looked at the builtin types.

## 0.8.1

### Deprecated APIs

* The library `semmle.code.cpp.dataflow.DataFlow` has been deprecated. Please use `semmle.code.cpp.dataflow.new.DataFlow` instead.

### New Features

* The `DataFlow::StateConfigSig` signature module has gained default implementations for `isBarrier/2` and `isAdditionalFlowStep/4`. 
  Hence it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Data flow configurations can now include a predicate `neverSkip(Node node)`
  in order to ensure inclusion of certain nodes in the path explanations. The
  predicate defaults to the end-points of the additional flow steps provided in
  the configuration, which means that such steps now always are visible by
  default in path explanations.
* The `IRGuards` library has improved handling of pointer addition and subtraction operations.

## 0.8.0

### New Features

* The `ProductFlow::StateConfigSig` signature now includes default predicates for `isBarrier1`, `isBarrier2`, `isAdditionalFlowStep1`, and `isAdditionalFlowStep1`. Hence, it is no longer needed to provide `none()` implementations of these predicates if they are not needed.

### Minor Analysis Improvements

* Deleted the deprecated `getURL` predicate from the `Container`, `Folder`, and `File` classes. Use the `getLocation` predicate instead.

## 0.7.4

No user-facing changes.

## 0.7.3

### Minor Analysis Improvements

* Deleted the deprecated `hasCopyConstructor` predicate from the `Class` class in `Class.qll`.
* Deleted many deprecated predicates and classes with uppercase `AST`, `SSA`, `CFG`, `API`, etc. in their names. Use the PascalCased versions instead.
* Deleted the deprecated `CodeDuplication.qll` file.

## 0.7.2

### New Features

* Added an AST-based interface (`semmle.code.cpp.rangeanalysis.new.RangeAnalysis`) for the relative range analysis library.
* A new predicate `BarrierGuard::getAnIndirectBarrierNode` has been added to the new dataflow library (`semmle.code.cpp.dataflow.new.DataFlow`) to mark indirect expressions as barrier nodes using the `BarrierGuard` API.

### Major Analysis Improvements

* In the intermediate representation, handling of control flow after non-returning calls has been improved. This should remove false positives in queries that use the intermedite representation or libraries based on it, including the new data flow library.

### Minor Analysis Improvements

* The `StdNamespace` class now also includes all inline namespaces that are children of `std` namespace.
* The new dataflow (`semmle.code.cpp.dataflow.new.DataFlow`) and taint-tracking libraries (`semmle.code.cpp.dataflow.new.TaintTracking`) now support tracking flow through static local variables.

## 0.7.1

No user-facing changes.

## 0.7.0

### Breaking Changes

* The internal `SsaConsistency` module has been moved from `SSAConstruction` to `SSAConsitency`, and the deprecated `SSAConsistency` module has been removed.

### Deprecated APIs

* The single-parameter predicates `ArrayOrVectorAggregateLiteral.getElementExpr` and `ClassAggregateLiteral.getFieldExpr` have been deprecated in favor of `ArrayOrVectorAggregateLiteral.getAnElementExpr` and `ClassAggregateLiteral.getAFieldExpr`.
* The recently introduced new data flow and taint tracking APIs have had a
  number of module and predicate renamings. The old APIs remain in place for
  now.
* The `SslContextCallAbstractConfig`, `SslContextCallConfig`, `SslContextCallBannedProtocolConfig`, `SslContextCallTls12ProtocolConfig`, `SslContextCallTls13ProtocolConfig`, `SslContextCallTlsProtocolConfig`, `SslContextFlowsToSetOptionConfig`, `SslOptionConfig` dataflow configurations from `BoostorgAsio` have been deprecated. Please use `SslContextCallConfigSig`, `SslContextCallGlobal`, `SslContextCallFlow`, `SslContextCallBannedProtocolFlow`, `SslContextCallTls12ProtocolFlow`, `SslContextCallTls13ProtocolFlow`, `SslContextCallTlsProtocolFlow`, `SslContextFlowsToSetOptionFlow`.

### New Features

* Added overridable predicates `getSizeExpr` and `getSizeMult` to the `BufferAccess` class (`semmle.code.cpp.security.BufferAccess.qll`). This makes it possible to model a larger class of buffer reads and writes using the library.

### Minor Analysis Improvements

* The `BufferAccess` library (`semmle.code.cpp.security.BufferAccess`) no longer matches buffer accesses inside unevaluated contexts (such as inside `sizeof` or `decltype` expressions). As a result, queries using this library may see fewer false positives.

### Bug Fixes

* Fixed some accidental predicate visibility in the backwards-compatible wrapper for data flow configurations. In particular `DataFlow::hasFlowPath`, `DataFlow::hasFlow`, `DataFlow::hasFlowTo`, and `DataFlow::hasFlowToExpr` were accidentally exposed in a single version.

## 0.6.1

No user-facing changes.

## 0.6.0

### Breaking Changes

* The `semmle.code.cpp.commons.Buffer` and `semmle.code.cpp.commons.NullTermination` libraries no longer expose `semmle.code.cpp.dataflow.DataFlow`. Please import `semmle.code.cpp.dataflow.DataFlow` directly.

### Deprecated APIs

* The `WriteConfig` taint tracking configuration has been deprecated. Please use `WriteFlow`.

### New Features

* Added support for merging two `PathGraph`s via disjoint union to allow results from multiple data flow computations in a single `path-problem` query.

### Major Analysis Improvements

* A new C/C++ dataflow library (`semmle.code.cpp.dataflow.new.DataFlow`) has been added.
  The new library behaves much more like the dataflow library of other CodeQL supported
  languages by following use-use dataflow paths instead of def-use dataflow paths.
  The new library also better supports dataflow through indirections, and new predicates
  such as `Node::asIndirectExpr` have been added to facilitate working with indirections.

  The `semmle.code.cpp.ir.dataflow.DataFlow` library is now identical to the new
  `semmle.code.cpp.dataflow.new.DataFlow` library.
* The main data flow and taint tracking APIs have been changed. The old APIs
  remain in place for now and translate to the new through a
  backwards-compatible wrapper. If multiple configurations are in scope
  simultaneously, then this may affect results slightly. The new API is quite
  similar to the old, but makes use of a configuration module instead of a
  configuration class.

### Minor Analysis Improvements

* Deleted the deprecated `hasGeneratedCopyConstructor` and `hasGeneratedCopyAssignmentOperator` predicates from the `Folder` class.
* Deleted the deprecated `getPath` and `getFolder` predicates from the `XmlFile` class.
* Deleted the deprecated `getMustlockFunction`, `getTrylockFunction`, `getLockFunction`, and `getUnlockFunction` predicates from the `MutexType` class.
* Deleted the deprecated `getPosInBasicBlock` predicate from the `SubBasicBlock` class.
* Deleted the deprecated `getExpr` predicate from the `PointerDereferenceExpr` class.
* Deleted the deprecated `getUseInstruction` and `getDefinitionInstruction` predicates from the `Operand` class.
* Deleted the deprecated `isInParameter`, `isInParameterPointer`, and `isInQualifier` predicates from the `FunctionInput` class.
* Deleted the deprecated `isOutParameterPointer`, `isOutQualifier`, `isOutReturnValue`, and `isOutReturnPointer` predicate from the `FunctionOutput` class.
* Deleted the deprecated 3-argument `isGuardPhi` predicate from the `RangeSsaDefinition` class.

## 0.5.4

No user-facing changes.

## 0.5.3

No user-facing changes.

## 0.5.2

No user-facing changes.

## 0.5.1

No user-facing changes.

## 0.5.0

### Breaking Changes

The predicates in the `MustFlow::Configuration` class used by the `MustFlow` library (`semmle.code.cpp.ir.dataflow.MustFlow`) have changed to be defined directly in terms of the C++ IR instead of IR dataflow nodes.

### Deprecated APIs

* Deprecated `semmle.code.cpp.ir.dataflow.DefaultTaintTracking`. Use `semmle.code.cpp.ir.dataflow.TaintTracking`.
* Deprecated `semmle.code.cpp.security.TaintTrackingImpl`. Use `semmle.code.cpp.ir.dataflow.TaintTracking`.
* Deprecated `semmle.code.cpp.valuenumbering.GlobalValueNumberingImpl`. Use `semmle.code.cpp.valuenumbering.GlobalValueNumbering`, which exposes the same API.

### Minor Analysis Improvements

* The `ArgvSource` flow source now uses the second parameter of `main` as its source instead of the uses of this parameter.
* The `ArgvSource` flow source has been generalized to handle cases where the argument vector of `main` is not named `argv`.
* The `getaddrinfo` function is now recognized as a flow source.
* The `secure_getenv` and `_wgetenv` functions are now recognized as local flow sources.
* The `scanf` and `fscanf` functions and their variants are now recognized as flow sources.
* Deleted the deprecated `getName` and `getShortName` predicates from the `Folder` class.

## 0.4.6

No user-facing changes.

## 0.4.5

No user-facing changes.

## 0.4.4

No user-facing changes.

## 0.4.3

### Minor Analysis Improvements

* Fixed bugs in the `FormatLiteral` class that were causing `getMaxConvertedLength` and related predicates to return no results when the format literal was `%e`, `%f` or `%g` and an explicit precision was specified.

## 0.4.2

No user-facing changes.

## 0.4.1

No user-facing changes.

## 0.4.0

### Deprecated APIs

* Some classes/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* Added subclasses of `BuiltInOperations` for `__is_same`, `__is_function`, `__is_layout_compatible`, `__is_pointer_interconvertible_base_of`, `__is_array`, `__array_rank`, `__array_extent`, `__is_arithmetic`, `__is_complete_type`, `__is_compound`, `__is_const`, `__is_floating_point`, `__is_fundamental`, `__is_integral`, `__is_lvalue_reference`, `__is_member_function_pointer`, `__is_member_object_pointer`, `__is_member_pointer`, `__is_object`, `__is_pointer`, `__is_reference`, `__is_rvalue_reference`, `__is_scalar`, `__is_signed`, `__is_unsigned`, `__is_void`, and `__is_volatile`.

### Bug Fixes

* Fixed an issue in the taint tracking analysis where implicit reads were not allowed by default in sinks or additional taint steps that used flow states.

## 0.3.5

## 0.3.4

### Deprecated APIs

* Many classes/predicates/modules with upper-case acronyms in their name have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* Added support for getting the link targets of global and namespace variables.
* Added a `BlockAssignExpr` class, which models a `memcpy`-like operation used in compiler generated copy/move constructors and assignment operations.

### Minor Analysis Improvements

* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.3.3

### New Features

* Added a predicate `getValueConstant` to `AttributeArgument` that yields the argument value as an `Expr` when the value is a constant expression.
* A new class predicate `MustFlowConfiguration::allowInterproceduralFlow` has been added to the `semmle.code.cpp.ir.dataflow.MustFlow` library. The new predicate can be overridden to disable interprocedural flow.
* Added subclasses of `BuiltInOperations` for `__builtin_bit_cast`, `__builtin_shuffle`, `__has_unique_object_representations`, `__is_aggregate`, and `__is_assignable`.

### Major Analysis Improvements

* The IR dataflow library now includes flow through global variables. This enables new findings in many scenarios.

## 0.3.2

### Bug Fixes

* Under certain circumstances a variable declaration that is not also a definition could be associated with a `Variable` that did not have the definition as a `VariableDeclarationEntry`. This is now fixed, and a unique `Variable` will exist that has both the declaration and the definition as a `VariableDeclarationEntry`.

## 0.3.1

### Minor Analysis Improvements

* `AnalysedExpr::isNullCheck` and `AnalysedExpr::isValidCheck` have been updated to handle variable accesses on the left-hand side of the C++ logical "and", and variable declarations in conditions.

## 0.3.0

### Deprecated APIs

* The `BarrierGuard` class has been deprecated. Such barriers and sanitizers can now instead be created using the new `BarrierGuard` parameterized module.

### Bug Fixes

* `UserType.getADeclarationEntry()` now yields all forward declarations when the user type is a `class`, `struct`, or `union`.

## 0.2.3

### New Features

* An `isBraced` predicate was added to the `Initializer` class which holds when a C++ braced initializer was used in the initialization.

## 0.2.2

### Deprecated APIs

 * The `AnalysedString` class in the `StringAnalysis` module has been replaced with `AnalyzedString`, to follow our style guide. The old name still exists as a deprecated alias.

### New Features

* A `getInitialization` predicate was added to the `ConstexprIfStmt`, `IfStmt`, and `SwitchStmt` classes that yields the C++17-style initializer of the `if` or `switch` statement when it exists.

## 0.2.1

## 0.2.0

### Breaking Changes

* The signature of `allowImplicitRead` on `DataFlow::Configuration` and `TaintTracking::Configuration` has changed from `allowImplicitRead(DataFlow::Node node, DataFlow::Content c)` to `allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c)`.

### Minor Analysis Improvements

* More Windows pool allocation functions are now detected as `AllocationFunction`s.
* The `semmle.code.cpp.commons.Buffer` library has been enhanced to handle array members of classes that do not specify a size.

## 0.1.0

### Breaking Changes

* The recently added flow-state versions of `isBarrierIn`, `isBarrierOut`, `isSanitizerIn`, and `isSanitizerOut` in the data flow and taint tracking libraries have been removed.

### New Features

* A new library `semmle.code.cpp.security.PrivateData` has been added. The new library heuristically detects variables and functions dealing with sensitive private data, such as e-mail addresses and credit card numbers.

### Minor Analysis Improvements

* The `semmle.code.cpp.security.SensitiveExprs` library has been enhanced with some additional rules for detecting credentials.

## 0.0.13

## 0.0.12

### Breaking Changes

* The flow state variants of `isBarrier` and `isAdditionalFlowStep` are no longer exposed in the taint tracking library. The `isSanitizer` and `isAdditionalTaintStep` predicates should be used instead.

### Deprecated APIs

* Many classes/predicates/modules that had upper-case acronyms have been renamed to follow our style-guide. 
  The old name still exists as a deprecated alias.

### New Features

* The data flow and taint tracking libraries have been extended with versions of `isBarrierIn`, `isBarrierOut`, and `isBarrierGuard`, respectively `isSanitizerIn`, `isSanitizerOut`, and `isSanitizerGuard`, that support flow states.

### Minor Analysis Improvements

* `DefaultOptions::exits` now holds for C11 functions with the `_Noreturn` or `noreturn` specifier.
* `hasImplicitCopyConstructor` and `hasImplicitCopyAssignmentOperator` now correctly handle implicitly-deleted operators in templates.
* All deprecated predicates/classes/modules that have been deprecated for over a year have been deleted.

## 0.0.11

### Minor Analysis Improvements

* Many queries now support structured bindings, as structured bindings are now handled in the IR translation.

## 0.0.10

### New Features

* Added a `isStructuredBinding` predicate to the `Variable` class which holds when the variable is declared as part of a structured binding declaration.

## 0.0.9


## 0.0.8

### Deprecated APIs

* The `codeql/cpp-upgrades` CodeQL pack has been removed. All upgrades scripts have been merged into the `codeql/cpp-all` CodeQL pack.

### Minor Analysis Improvements

* `FormatLiteral::getMaxConvertedLength` now uses range analysis to provide a
  more accurate length for integers formatted with `%x`

## 0.0.7

## 0.0.6

## 0.0.5

## 0.0.4

### New Features

* The QL library `semmle.code.cpp.commons.Exclusions` now contains a predicate
  `isFromSystemMacroDefinition` for identifying code that originates from a
  macro outside the project being analyzed.
