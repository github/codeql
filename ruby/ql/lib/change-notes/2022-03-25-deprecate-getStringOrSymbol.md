---
 category: minorAnalysis
---
 *  Whereas `ConstantValue::getString()` previously returned both string and regular-expression values, it now returns only string values. The same applies to `ConstantValue::isString(value)`.
 *  Regular-expression values can now be accessed with the new predicates `ConstantValue::getRegExp()`, `ConstantValue::isRegExp(value)`, and `ConstantValue::isRegExpWithFlags(value, flags)`.
