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

Working with CodeQL packs on GitHub Enterprise Server
-----------------------------------------------------

.. pull-quote::

   Note

   The Container registry for GitHub Enterprise Server supports CodeQL query packs from GitHub Enterprise Server 3.6 onward.

By default, the CodeQL CLI expects to download CodeQL packs from and publish packs to the Container registry on GitHub.com. However, you can also work with CodeQL packs in a Container registry on GitHub Enterprise Server 3.6, and later, by creating a ``qlconfig.yml`` file to tell the CLI which Container registry to use for each pack.

Create a ``~/.codeql/qlconfig.yml`` file using your preferred text editor, and add entries to specify which registry to use for one or more package name patterns.
For example, the following ``qlconfig.yml`` file associates all packs with the Container registry for the GitHub Enterprise Server at ``GHE_HOSTNAME``, except packs matching ``codeql/*``, which are associated with the Container registry on GitHub.com:

.. code-block:: yaml

   registries:
   - packages: 'codeql/*'
     url: https://ghcr.io/v2/
   - packages: '*'
     url: https://containers.GHE_HOSTNAME/v2/

The CodeQL CLI will determine which registry to use for a given package name by finding the first item in the ``registries`` list with a ``packages`` property that matches that package name.
This means that you'll generally want to define the most specific package name patterns first.

You can now use ``codeql pack publish``, ``codeql pack download``, and ``codeql database analyze`` to manage packs on GitHub Enterprise Server.

Authenticating to GitHub Container registries
---------------------------------------------

You can publish packs and download private packs by authenticating to the appropriate GitHub Container registry.

You can authenticate to the Container registry on GitHub.com in two ways:

1. Pass the ``--github-auth-stdin`` option to the CodeQL CLI, then supply a GitHub Apps token or personal access token via standard input.
2. Set the ``GITHUB_TOKEN`` environment variable to a GitHub Apps token or personal access token.

Similarly, you can authenticate to a GHES Container registry, or authenticate to multiple registries simultaneously (for example, to download or run private packs from multiple registries) in two ways:

1. Pass the ``--registries-auth-stdin`` option to the CodeQL CLI, then supply a registry authentication string via standard input.
2. Set the ``CODEQL_REGISTRIES_AUTH`` environment variable to a registry authentication string.

A registry authentication string is a comma-separated list of ``<registry-url>=<token>`` pairs, where ``registry-url`` is a GitHub Container registry URL, such as ``https://containers.GHE_HOSTNAME/v2/``, and ``token`` is a GitHub Apps token or personal access token for that GitHub Container registry.
This ensures that each token is only passed to the Container registry you specify.
For instance, the following registry authentication string specifies that the CodeQL CLI should authenticate to the Container registry on GitHub.com using the token ``<token1>`` and to the Container registry for the GHES instance at ``GHE_HOSTNAME`` using the token ``<token2>``:

.. code-block:: none

   https://ghcr.io/v2/=<token1>,https://containers.GHE_HOSTNAME/v2/=<token2>
