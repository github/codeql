.. _creating-and-working-with-codeql-packs:

Creating and working with CodeQL packs
======================================

You can use CodeQL packs to create, share, depend on, and run CodeQL queries and libraries.

.. pull-quote::

   Note

   The CodeQL package manager is currently in beta and subject to change. During the beta, CodeQL packs are available only in the GitHub Package Registry (GHPR).

About CodeQL packs
------------------

There are two types of CodeQL packs: query packs and library packs.

* Query packs are designed to be run. The query packs are bundled with all transitive dependencies and a compilation cache is included in the tarball.
* Library packs are designed to be used by query packs (or other library packs) and do not contain queries themselves. The libraries are not compiled and there is no compilation cache included in the final pack.

You can the CodeQL package manger in the CodeQL CLI to create CodeQL packs, add dependencies to packs, and install or update dependencies. You can also publish and download CodeQL packs using the CodeQL package manager. For more information, see ":doc:`Publishing and using CodeQL packs <publishing-and-using-codeql-packs>`."

Creating a CodeQL pack with the CodeQL package manager
------------------------------------------------------