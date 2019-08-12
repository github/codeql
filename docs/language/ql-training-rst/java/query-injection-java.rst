========================
Example: Query injection
========================

QL for Java

.. container:: semmle-logo

   Semmle :sup:`TM`

.. rst-class:: setup

Setup
=====

For this example you should download:

- `QL for Eclipse <https://help.semmle.com/ql-for-eclipse/Content/WebHelp/install-plugin-free.html>`__
- `VIVO Vitro snapshot <http://downloads.lgtm.com/snapshots/java/vivo-project/Vitro/vivo-project_Vitro_java-srcVersion_47ae42c01954432c3c3b92d5d163551ce367f510-dist_odasa-lgtm-2019-04-23-7ceff95-linux64.zip>`__

.. note::

   For this example, we will be analyzing `VIVO Vitro <https://github.com/vivo-project/Vitro>`__.

   You can also query the project in `the query console <https://lgtm.com/query/project:14040005/lang:java/>`__ on LGTM.com.

   Note that results generated in the query console are likely to differ to those generated in the QL plugin as LGTM.com analyzes the most recent revisions of each project that has been added–the snapshot available to download above is based on an historical version of the code base.

SQL injection
=============

- Occurs when user input is used to construct an SQL query without any sanitization or escaping.

- Classic example involves constructing a query using string concatenation:

  .. code-block:: sql

     runQuery("SELECT * FROM users WHERE id='" + userId + "'");


- If the ``userId`` can be provided by a user, and is not sanitized, then a malicious user can provide input that manipulates the intended query.

- For example, providing the input ``"' OR '1'='1"`` would allow the attacker to return all records in the users table.

.. note::

   `SQL <https://en.wikipedia.org/wiki/SQL>`__ is a database query language, which is often used from within other programming languages to interact with a database. The typical case is that a query is to be executed to find some data, based on some input provided by the user - for example, the user’s ID. However, the interface between the host programming language and SQL is typically implemented by passing a string containing the query to some API.

SPARQL injection
================

- `SPARQL <https://en.wikipedia.org/wiki/SPARQL>`__ is a language for querying key-value databases in RDF format.

- The same type of vulnerability can occur for SPARQL as for SQL: if the SPARQL query is constructed through string concatenation, a malicious user can subvert the query:

  .. code-block:: sql
  
     sparqlAskQuery("ASK { <" + individualURI + "> ?p ?o }");

- SPARQL is used by many projects, but we will be looking at `VIVO Vitro <https://github.com/vivo-project/Vitro/>`__.

.. rst-class:: background2

Developing a QL query
======================

Finding a query concatenation

QL query: find SPARQL methods
=============================

Let’s start by looking for calls to methods with names of the form ``sparql*Query``, using the classes ``Method`` and ``MethodAccess`` from the Java library.

.. rst-class:: build

.. literalinclude:: ../query-examples/java/query-injection-java-1.ql 

.. note::

  - When performing `variant analysis <https://semmle.com/  variant-analysis>`__, it is usually helpful to write a simple   query that finds the simple syntactic pattern, before trying to   go on to describe the cases where it goes wrong.
  - In this case, we start by looking for all the method calls   which appear to run, before trying to refine the query to find   cases which are vulnerable to query injection.
  - The ``select`` clause defines what this query is looking for:
  
    - a ``MethodAccess``: the call to a SPARQL query method
    - a ``Method``: the SPARQL query method.
  
  - The ``where`` part of the query ties these three QL variables   together using `predicates <https://help.semmle.com/QL/  ql-handbook/predicates.html>`__ defined in the `standard QL for   Java library <https://help.semmle.com/qldoc/java/>`__.

QL query: find string concatenation
===================================

We now need to define what would make these API calls unsafe.

A simple heuristic would be to look for string concatenation used in the query argument. We may want to reuse this logic, so let us create a separate predicate.

Looking at autocomplete suggestions, we see that we can get the type of an expression using the getType() method.

.. rst-class:: build

.. code-block:: ql

   predicate isStringConcat(AddExpr ae) {
     ae.getType() instanceof TypeString
   }

.. note::

  - An important part of the query is to determine whether a given expression is string concatenation.
  - We therefore write a helper predicate for finding string   concatenation.
  - This predicate effectively represents the set of all add expressions in the database where the type of the expression is ``TypeString`` - that is, the addition produces a ``String``   value.

QL query: SPARQL injection
==========================

We can now combine our predicate with the existing query.
Note that we do not need to specify that the argument of the method access is an ``AddExpr`` - this is implied by the ``isStringConcat`` requirement.

Now our query becomes:

.. rst-class:: build

.. literalinclude:: ../query-examples/java/query-injection-java-2.ql
   :language: ql

The final query
===============

.. literalinclude:: ../query-examples/java/query-injection-java-3.ql
   :language: ql

There are two results, one of which was assigned **CVE-2019-6986**.

.. note::

  Full write up and exploit can be found here: https://github.com/Semmle/SecurityExploits/tree/master/vivo-project/CVE-2019-6986

Follow up
=========

- Our query successfully finds cases where the concatenation occurs in the argument to the SPARQL API.

- However, in general, the concatenation could occur before the method call.

- For this, we would need to use :doc:`local data flow <data-flow-java>`, which is the topic of the next set of training slides.
