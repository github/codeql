import csharp

/*
 *  This tests a regression in the extractor where the following failed to extract:
 *
 *    class Foo<T>
 *    {
 *        enum E { a };
 *    }
 */

from Enum e, Class c
where
  c.hasName("Param<>") and
  e.hasName("E") and
  e.getDeclaringType() = c
select c, e
