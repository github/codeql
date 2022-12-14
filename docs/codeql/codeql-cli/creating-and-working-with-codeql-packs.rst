.. _creating-and-working-with-codeql-packs:

Creating and working with CodeQL packs
======================================

You can use CodeQL packs to create, share, depend on, and run CodeQL queries and libraries.

.. include:: ../reusables/beta-note-package-management.rst

About CodeQL packs and the CodeQL CLI
-------------------------------------

With CodeQL packs and the package management commands in the CodeQL CLI, you can publish your custom queries and integrate them into your codebase analysis.

There are two types of CodeQL packs: query packs and library packs.

* Query packs are designed to be run. When a query pack is published, the bundle includes all the transitive dependencies and a compilation cache. This ensures consistent and efficient execution of the queries in the pack.
* Library packs are designed to be used by query packs (or other library packs) and do not contain queries themselves. The libraries are not compiled and there is no compilation cache included when the pack is published.

You can use the ``pack`` command in the CodeQL CLI to create CodeQL packs, add dependencies to packs, and install or update dependencies. You can also publish and download CodeQL packs using the ``pack`` command. For more information, see ":doc:`Publishing and using CodeQL packs <publishing-and-using-codeql-packs>`."

Creating a CodeQL pack
----------------------
You can create a CodeQL pack by running the following command from the checkout root of your project:

::

  codeql pack init <scope>/<pack>

You must specify:

- ``<scope>``: the name of the GitHub organization or user account that you will publish to.
- ``<pack>``: the name for the pack that you are creating.

The ``codeql pack init`` command creates the directory structure and configuration files for a CodeQL pack. By default, the command creates a query pack. If you want to create a library pack, you must edit the ``qlpack.yml`` file to explicitly declare the file as a library pack by including the ``library:true`` property.

Modifying an existing legacy QL pack to create a CodeQL pack
------------------------------------------------------------

If you already have a ``qlpack.yml`` file, you can edit it manually to convert it into a CodeQL pack.

#. Edit the ``name`` property so that it matches the format ``<scope>/<name>``, where ``<scope>`` is the name of the GitHub organization or user account that you will publish to.
#. In the ``qlpack.yml`` file, include a ``version`` property with a semver identifier, as well as an optional ``dependencies`` block.
#. Migrate the list of dependencies in ``libraryPathDependencies`` to the ``dependencies`` block. Specify the version range for each dependency. If the range is unimportant, or you are unsure of compatibility, you can specify ``"*"``, which indicates that any version is acceptable and will default to the latest version when you run ``codeql pack install``.

For more information about the properties, see ":ref:`About CodeQL packs <about-codeql-packs>`."

.. _adding-and-installing-dependencies:

Adding and installing dependencies to a CodeQL pack
---------------------------------------------------
You can add dependencies on CodeQL packs using the command ``codeql pack add``. You must specify the scope, name, and (optionally) a compatible version range.

::

  codeql pack add <scope>/<name>@x.x.x <scope>/<other-name>

If you don't specify a version range, the latest version will be added. Otherwise, the latest version that satisfies the requested range will be added.

This command updates the ``qlpack.yml`` file with the requested dependencies and downloads them into the package cache. Please note that this command will reformat the file and remove all comments.

You can also manually edit the ``qlpack.yml`` file to include dependencies and install the dependencies with the command:

::

  codeql pack install

This command downloads all dependencies to the shared cache on the local disk.

.. pull-quote::

   Note

   Running the ``codeql pack add`` and ``codeql pack install`` commands will generate or update the ``codeql-pack.lock.yml`` file. This file should be checked-in to version control. The ``codeql-pack.lock.yml`` file contains the precise version numbers used by the pack.
   For more information, see ":ref:`About codeql-pack.lock.yml files <about-codeql-pack-lock>`."

.. pull-quote::

   Note

   By default ``codeql pack install`` will install dependencies from the Container registry on GitHub.com.
   You can install dependencies from a GitHub Enterprise Server Container registry by creating a ``qlconfig.yml`` file.
   For more information, see ":doc:`Publishing and using CodeQL packs <publishing-and-using-codeql-packs>`."
