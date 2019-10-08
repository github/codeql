What's in a snapshot database?
===============================

A snapshot database contains a variety of data related to a particular code base at a particular point in time. For details of how the database is generated see `Database generation <https://lgtm.com/help/lgtm/generate-database>`__.

The database contains a full, hierarchical representation of the program defined by the code base. The database schema varies according to the language analyzed. The schema provides an interface between the initial lexical analysis during the extraction process, and the actual complex analysis using TEST. When the source code languages being analyzed change (such as Java 7 evolving into Java 8), this interface between the analysis phases can also change.

For each language, a TEST library defines classes to provide a layer of abstraction over the database tables. This provides an object-oriented view of the data which makes it easier to write queries. This is easiest to explain using an example.

Example
-------

For a Java program, two key tables are:

-  The ``expressions`` table containing a row for every single expression in the source code that was analyzed during the build process.
-  The ``statements`` table containing a row for every single statement in the source code that was analyzed during the build process.

The library defines classes to provide a layer of abstraction over each of these tables (and the related auxiliary tables): ``Expr`` and ``Stmt``.

Most classes in the library are similar: they are abstractions over one or more database tables. Looking at one of the TEST libraries illustrates this:

.. code-block:: ql

   class Expr extends StmtParent, @expr {
       ...

       /** the location of this expression */
       Location getLocation() { exprs(this,_,_,result) }

       ...
   }

The ``Expr`` class, shown here, extends from the database type ``@expr``. Member predicates of the ``Expr`` class are implemented in terms of the database-provided ``exprs`` table.
