.. _upgrading-codeql-databases:

Upgrading CodeQL databases
==========================

As the CodeQL CLI tools and queries evolve, you may find that some of your
CodeQL databases become out of date. You must upgrade out-of-date databases
before you can analyze them.

Databases become out of date when:

- For databases created using the CodeQL CLI, the version of CLI tools used to
  create them is older than your copy of the CodeQL queries.
- For databases downloaded from LGTM.com, the CodeQL tools used by LGTM.com to create
  that revision of the code are older than your copy of the CodeQL queries.

If you have a local checkout of the ``github/codeql`` repository, please note that
the ``main`` branch of the CodeQL queries is updated more often than both the
CLI and LGTM.com, so databases are most likely to become out of date if you use
the queries on this branch. For more information about the different versions of
the CodeQL queries, see ":ref:`Getting started with the CodeQL CLI <local-copy-codeql-queries>`."

Out-of-date databases must be upgraded before they can be analyzed. This topic
shows you how to upgrade a CodeQL database using the ``database upgrade``
subcommand.

Prerequisites
-------------

Archived databases downloaded from LGTM.com must be unzipped before they are
upgraded.

Running ``codeql database upgrade``
-----------------------------------

CodeQL databases are upgraded by running the following command::

   codeql database upgrade <database>

where ``<database>``, the path to the CodeQL database you
want to upgrade, must be specified.

For full details of all the options you can use when upgrading databases,
see the "`database upgrade <../manual/database-upgrade>`__"  reference documentation.

Progress and results
--------------------

When you execute the ``database upgrade`` command, CodeQL identifies the version
of the :ref:`schema <codeql-database-schema>` associated with the database. From
there, it works out what (if anything) is required to make the database work
with your queries and libraries. It will rewrite the database, if necessary, or
make no changes if the database is already compatible (or if it finds no
information about how to perform an upgrade). Once a database has been upgraded
it cannot be downgraded for use with older versions of the CodeQL products.
