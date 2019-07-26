Folding predicates
==================

Sometimes you can assist the query optimizer by "folding" parts of predicates out into their own predicates.

The general principle is to split off chunks of work that are "linear" - that is, there is not too much branching - and tightly bound, such that the chunks then join with each other on as many variables as possible.

Example
-------

.. code-block:: ql

   predicate similar(Element e1, Element e2) {
       e1.getName() = e2.getName() and
       e1.getFile() = e2.getFile() and
       e1.getLocation().getStartLine() = e2.getLocation().getStartLine()
   }

Here we are doing some lookups on ``Element``\ s. Going from ``Element -> File`` and ``Element -> Location -> StartLine`` are linear: there is only one ``File`` for each ``Element``, and one ``Location`` for each ``Element``, etc. However, as written it is difficult for the optimizer to pick out the best ordering here. We want to do the quick, linear parts first, and then join on the resultant larger tables, rather than joining first and then doing the linear lookups. We can precipitate this kind of ordering by rewriting the above predicate as follows:

.. code-block:: ql

   predicate locInfo(Element e, string name, File f, int startLine) {
       name = e.getName() and
       f = e.getFile() and
       startLine = e.getLocation().getStartLine()
   }

   predicate sameLoc(Element e1, Element e2) {
       exists(string name, File f, int startLine |
           locInfo(e1, name, f, startLine) and
           locInfo(e2, name, f, startLine)
       )
   }

Now the structure we want is clearer: we've separated out the easy part into its own predicate ``locInfo``, and the main predicate is just a larger join.
