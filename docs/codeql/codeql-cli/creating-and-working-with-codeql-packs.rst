.. _creating-and-working-with-codeql-packs:

Creating and working with CodeQL packs
======================================

You can use CodeQL packs to create, share, depend on, and run CodeQL queries and libraries.

.. pull-quote::

   Note

   The CodeQL package manager is currently in beta and subject to change. During the beta, CodeQL packs are available only in the GitHub Package Registry (GHPR). You must use version 2.5.8 or later of the CodeQL CLI to use the CodeQL package manager.

About CodeQL packs and the CodeQL CLI package manager
-----------------------------------------------------

With CodeQL packs and the CodeQL CLI package manager, you can publish your custom queries and integrate them into your CodeQL code scanning workflow to run and analyze your codebase.

There are two types of CodeQL packs: query packs and library packs.

* Query packs are designed to be run. The query packs are bundled with all transitive dependencies and a compilation cache is included in the tarball.
* Library packs are designed to be used by query packs (or other library packs) and do not contain queries themselves. The libraries are not compiled and there is no compilation cache included in the final pack.

You can use the CodeQL package manger in the CodeQL CLI to create CodeQL packs, add dependencies to packs, and install or update dependencies. You can also publish and download CodeQL packs using the CodeQL package manager. For more information, see ":doc:`Publishing and using CodeQL packs <publishing-and-using-codeql-packs>`."

Running ``codeql pack init``
----------------------------
You can create CodeQL packs are by running the following command from the checkout root of your project:

::

  codeql pack init <scope>/<pack>

You must specify:

- ``<scope>``: the name of the GitHub organization that you will publish to.
- ``<pack>``: the name for the pack that you are creating.

The ``codeql pack init`` command creates the directory structure and configuration files for a CodeQL pack. By default, the command creates a query pack. If you want to create a library pack, you must edit the ``qlpack.yml`` file to explicitly declare the file as a library pack by including the ``library:true`` property.

Modifying an existing QL pack to create a CodeQL pack
-----------------------------------------------------
If you already have a ``qlpack.yml`` file, you can edit it manually to be a CodeQL pack.

#. Edit the name so that it matches the format ``<scope>/<name>``, where ``<scope>`` is the name of the GitHub organization that you will publish to.
#. In the ``qlpack.yml`` file, include a version property with a semver identifier, as well as an optional dependencies block.

Adding and installing dependencies to a CodeQL pack
---------------------------------------------------
You can add dependencies on CodeQL packs using the command ``codeql pack add``. You can specify the scope, name, and version.

::

  codeql pack add <scope>/<name>@x.x.x <scope>/<other-name>

The version number is optional. If you leave off the version number, the latest version will be added.

This command updates the ``qlpack.yml`` file with the requested dependencies and downloads them into the package cache. Please note that this command will reformat the file and remove all comments.

You can also manually edit the ``qlpack.yml`` file to include dependencies and install the dependencies with the command:

::

  codeql pack install

This command downloads all dependencies to the shared cache on the local disk.

.. pull-quote::

   Note

   Running the ``codeql pack add`` and ``codeql pack install`` commands will generate or update the ``qlpack.lock.yml`` file. This file should be checked-in to version control. ``qlpack.lock.yml`` contains the precise version numbers used by the pack.
