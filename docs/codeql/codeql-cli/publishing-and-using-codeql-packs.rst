.. _publishing-and-using-codeql-packs:

Publishing and using CodeQL packs
=================================

You can publish your own CodeQL packs and use packs published by other people.

.. include:: ../reusables/beta-note-package-management.rst

Configuring the ``qlpack.yml`` file before publishing
-----------------------------------------------------

You can check and modify the configuration details of your CodeQL pack prior to publishing. Open the ``qlpack.yml`` file in your preferred text editor.

.. code-block:: none

   library: # set to true if the pack is a library. Set to false or omit for a query pack
   name: <scope>/<pack>
   version: <x.x.x>
   description: <Description to publish with the package>
   default-suite: # optional, one or more queries in the pack to run by default
       - query: <relative-path>/query-file>.ql
   default-suite-file: default-queries.qls # optional, a pointer to a query-suite in this pack
   license: # optional, the license under which the pack is published
   dependencies: # map from CodeQL pack name to version range

- ``name:`` must follow the <scope>/<pack> format, where <scope> is the GitHub organization that you will publish to and <pack> is the name for the pack.
- A maximum of one of ``default-suite`` or ``default-suite-file`` is allowed. These are two different ways to define a default query suite to be run, the first by specifying queries directly in the `qlpack.yml` file and the second by specifying a query suite in the pack.

Running ``codeql pack publish``
-------------------------------

When you are ready to publish a pack to the GitHub Container registry, you can run the following command in the root of the pack directory:

::

  codeql pack publish

The published package will be displayed in the packages section of GitHub organization specified by the scope in the ``qlpack.yml`` file.

Running ``codeql pack download <scope>/<pack>``
-----------------------------------------------

To run a pack that someone else has created, you must first download it by running the following command:

::

  codeql pack download <scope>/<pack>@x.x.x

- ``<scope>``: the name of the GitHub organization that you will download from.
- ``<pack>``: the name for the pack that you want to download.
- ``@x.x.x``: an optional version number. If omitted, the latest version will be downloaded.

This command accepts arguments for multiple packs.

Using a CodeQL pack to analyze a CodeQL database
------------------------------------------------

To analyze a CodeQL database with a CodeQL pack, run the following command:

::

   codeql database analyze <database> <scope>/<pack>@x.x.x

- ``<database>``: the CodeQL database to be analyzed.
- ``<scope>``: the name of the GitHub organization that the pack is published to.
- ``<pack>``: the name for the pack that you are using.
- ``@x.x.x``: an optional version number. If omitted, the latest version will be used.

The ``analyze`` command will run the default suite of any specified CodeQL packs. You can specify multiple CodeQL packs to be used for analyzing a CodeQL database. For example:

::

   codeql <database> analyze <scope>/<pack> <scope>/<other-pack>
