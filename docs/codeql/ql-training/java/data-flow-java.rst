=========================
Introduction to data flow
=========================

Finding SPARQL injection vulnerabilities in Java

.. rst-class:: setup

Setup
=====

For this example you need to set up `CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/installing-codeql-for-vs-code>`__ and download the CodeQL database for `VIVO Vitro <https://github.com/vivo-project/Vitro>`__ from GitHub.

.. rst-class:: agenda

Agenda
======

- SPARQL injection
- Data flow
- Modules and libraries
- Local data flow
- Local taint tracking

Motivation
==========

`SPARQL <https://en.wikipedia.org/wiki/SPARQL>`__ is a language for querying key-value databases in RDF format, which can suffer from SQL injection-like vulnerabilities:

.. code-block:: none

  sparqlAskQuery("ASK { <" + individualURI + "> ?p ?o }")

``individualURI`` is provided by a user, allowing an attacker to prematurely close the ``>``, and provide additional content.

**Goal**: Find query strings that are created by concatenation.

.. note::

  If you have completed the “Example: Query injection” slide deck which was part of the previous course, this example will look familiar to you.

  To understand the scope of this vulnerability, consider what would happen if a malicious user could provide the following as the content of the ``individualURI`` variable:

  ``“http://vivoweb.org/ontology/core#FacultyMember> ?p ?o . FILTER regex("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!", "(.*a){50}") } #``


Example: SPARQL injection
=========================

We can write a simple query that finds string concatenations that occur in calls to SPARQL query APIs.

.. rst-class:: build

.. literalinclude:: ../query-examples/java/data-flow-java-1.ql
   :language: ql

.. note::

  This is similar, but not identical, to the formulation we had in the previous training deck. It has been rewritten to make it easier for the next step.

Success! But also missing results...
====================================

Query finds a CVE reported by Semmle (CVE-2019-6986), plus one other result, but misses other opportunities where:

  - String concatenation occurs on a different line in the same method.
  - String concatenation occurs in a different method.
  - String concatenation occurs through ``StringBuilders`` or similar.
  - Entirety of user input is provided as the query.

We want to improve our query to catch more of these cases.

.. note::

   For more details of the CVE, see: https://github.com/Semmle/SecurityExploits/tree/master/vivo-project/CVE-2019-6986

   As an example, consider this SPARQL query call:
   
   .. code-block:: none
   
      String queryString = "ASK { <" + individualURI + "> ?p ?o }";
       sparqlAskQuery(queryString);
   
   Here the concatenation occurs before the call, so the existing query would miss this - the string concatenation does not occur *directly* as the first argument of the call.

.. include general data flow slides

.. include:: ../slide-snippets/local-data-flow.rst

.. resume language-specific slides

Exercise: revisiting SPARQL injection
=====================================

Refine the query to find string concatenation that occurs in the same method, but a different line.

**Hint**: Use ``DataFlow::localFlow`` to assert that the result flows to the SPARQL call argument, using ``DataFlow::exprNode`` to get the data flow nodes for the relevant expression nodes.

.. rst-class:: build

.. literalinclude:: ../query-examples/java/data-flow-java-2.ql
  :language: ql

Refinements (take home exercise)
================================

In Java, strings are often created using ``StringBuilder`` and ``StringBuffer`` classes. For example:

    .. code-block:: java
    
       StringBuilder queryBuilder = new StringBuilder();
       queryBuilder.add("ASK { <");
       queryBuilder.add(individualURI);
       queryBuilder.add("> ?p ?o }");
       sparqlAskQuery(queryBuilder);

**Exercise**: Refine the query to consider strings created from ``StringBuilder`` and ``StringBuffer`` classes as sources of concatenation.

Beyond local data flow
======================

- We are still missing possible results.

  - Concatenation that occurs outside the enclosing method.

- Instead, let’s turn the problem around and find user-controlled data that flows into a ``printf`` format argument, potentially through calls.
- This needs :doc:`global data flow <global-data-flow-java>`.