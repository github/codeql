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
