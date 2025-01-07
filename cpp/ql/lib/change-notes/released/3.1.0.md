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
