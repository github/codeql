private import codeql.unified.internal.mad.DynamicMaD as DynamicMaD

query predicate invalidAccessPath = DynamicMaD::Debug::invalidAccessPath/3;
