using System;
using System.Collections.Generic;
using System.Linq;

class Queries
{
    void Queries1()
    {
        IList<int> list1 = new List<int> { 1, 2, 3 };
        IList<IList<int>> list2 = new List<IList<int>> { list1, list1 };

        var list3 =
          from a in list1
          where a == 2 || a == 3
          orderby a ascending
          select a + 1;

        var list4 = list1.
          Where(a => a == 2 || a == 3).
          OrderBy(a => a).
          Select(a => a + 1);

        var list5 =
          from a in list2
          from b in a
          let next = b + 1
          join c in list1 on next equals c
          select 1;

        var list6 =
          from a in list2
          from b in a
          let next = b + 1
          orderby next * 2 descending
          group b by next;

        var list7 = new B();

        var list8 =
          from object a in list7
          select a;

        var list9 = new C();

        var list10 =
          from a in list9
          select a;

        var list11 =
          from string a in list7
          select a;

        var list12 =
          from a in list1
          join c in list2 on a equals c[0] into d
          select (a,d);
    }

    class A : System.Collections.IEnumerable
    {
        public System.Collections.IEnumerator GetEnumerator()
        {
            throw new NotImplementedException();
        }
    }

    class B : A { }

    class C : List<int> { }
}

// semmle-extractor-options: /r:System.Linq.dll
