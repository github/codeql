import semmle.code.csharp.commons.ComparisonTest

from ComparisonTest ct
select ct, ct.getComparisonKind(), ct.getFirstArgument(), ct.getSecondArgument()
