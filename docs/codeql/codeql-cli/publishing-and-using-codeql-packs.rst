.. publishing-and-using-codeql-packs:

Publishing and using CodeQL packs
=================================

You can publish your own CodeQL packs and use packs published by other people.

.. pull-quote::

   Note

   The CodeQL package manager is currently in beta and subject to change. During the beta, CodeQL packs are available only in the GitHub Package Registry (GHPR). You must use version 2.5.8 or later of the CodeQL CLI to use the CodeQL package manager.

Configuring the ``qlpack.yml`` file before publishing
-----------------------------------------------------

You can check and modify the configuration details of your CodeQL pack prior to publishing. Open the ``qlpack.yml`` file in your preferred text editor.

   library: # set to true if the pack is a library. Set to false or omit for a query pack
   name: <scope>/<pack>
   version: x.x.x
   description: 
   default-suite: # a query-suite file that has been inlined
       - query:
   default-suite-file: default-queries.qls # a pointer to a query-suite in this pack
   license:
   dependencies:

- ``name:`` must follow the <scope>/<pack> format, where <scope> is the GitHub organization that you will publish to and <pack> is the name for the pack.
- Only one of ``default-suite`` or ``default-suite-file`` is allowed. Both options define a default query suite to be run.

Running ``codeql pack publish``
-------------------------------

When you are ready to upload a pack to a shared repository, you can run the following command:

::

  codeql pack publish

The published package will appear in the packages section of your GitHub organization.

Running ``codeql pack download <scope>/<pack>``
-----------------------------------------------

To run a pack that someone else has created, you must download it by running the following command:

::

  codeql pack download <scope>/<pack>@x.x.x

- ``<scope>``: the name of the GitHub organization that you will download from.
- ``<pack>``: the name for the pack that you are creating.
- ``@x.x.x``: an optional version number. If omitted, the latest version will be downloaded.

Using a CodeQL pack to analyze a CodeQL database
------------------------------------------------

To analyze a CodeQL database with a CodeQL pack, run the following command:

::

   codeql database analyze <database> --allow-packs <scope>/<pack>@x.x.x

- ``<database>``: the CodeQL database to be analyzed.
- ``<scope>``: the name of the GitHub organization that the pack is published to.
- ``<pack>``: the name for the pack that you are using.
- ``@x.x.x``: an optional version number. If omitted, the latest version will be used.
 
The ``analyze`` command will run the default suite of any specified CodeQL packs. You can specify multiple CodeQL packs to be used for analyzing a CodeQL database. For example:

::

   codeql <database> analyze --allow-packs <scope>/<pack> <scope>/<other-pack>
