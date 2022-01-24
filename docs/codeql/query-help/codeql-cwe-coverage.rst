CodeQL CWE coverage
===================

You can view the full coverage of MITRE's Common Weakness Enumeration (CWE) or coverage by language for the latest release of CodeQL.

About CWEs
##########

The CWE categorization contains several types of entity, collectively known as CWEs. The CWEs that we consider in this report are only those of the types:

- Weakness Class
- Weakness Base
- Weakness Variant
- Compound Element

Other types of CWE that do not correspond directly to weaknesses are omitted.

The CWE categorization includes relationships between entities, in particular a parent-child relationship.
These relationships are associated with Views (another kind of CWE entity). For the purposes of coverage claims, we use the "`Research View <https://cwe.mitre.org/data/definitions/1000.html>`_."

Every security query is associated with one or more CWEs, which are the most precise CWEs that are covered by that query.
Overall coverage is claimed for the most-precise CWEs, as well as for any of their ancestors in the View.

Note that the CWE coverage includes both "`supported queries <https://github.com/github/codeql/blob/main/docs/supported-queries.md>`_" and "`experimental queries <https://github.com/github/codeql/blob/main/docs/experimental.md>`_."

.. toctree::
   :titlesonly:

   full-cwe
   cpp-cwe
   csharp-cwe
   go-cwe
   java-cwe
   javascript-cwe
   python-cwe
   ruby-cwe

.. include:: ../reusables/ruby-beta-note.rst
