.. _about-codeql-workspaces:

About CodeQL Workspaces
=======================

.. include:: ../reusables/beta-note-package-management.rst

CodeQL workspaces are used to group multiple CodeQL packs together. CodeQL packs in the same workspace are automatically available as source dependencies for each other when running any CodeQL command that resolves queries. This makes it easier to develope and maintain multiple, related CodeQL packs. A typical use case for a CodeQL workspace is for developing one or more CodeQL library packs and one or more query packs that depends on it in them in the same location.

The main benefit of a CodeQl workspace is that it is easier to develop and maintain multiple CodeQL packs. When a CodeQL workspace is used, all CodeQL packs in the workspace are available as source dependencies for each other when running any CodeQL command that resolves queries. This makes it easier to develope and maintain multiple, related CodeQL packs.

In most cases, the CodeQL workspace and all CodeQL packs contained in it should be stored in the same git repository so the development environment is more easily sharable.

The ``codeql-workspae.yml`` file
--------------------------------

A CodeQL workspace is defined by a ``codeql-workspace.yml`` yaml file. This file contains a ``provide`` block, and optionally an ``ignore`` block. The ``provide`` block contains a list of glob patterns that define the CodeQL packs that are available in the workspace. The ``ignore`` block contains a list of glob patterns that define CodeQL packs that are not available in the workspace. Each entry in the ``provide`` or ``ignore`` section must map to a path to a ``qlpack.yml`` file. All glob patterns are relative to the directory containing the workspace file. See `@actions/glob <https://github.com/actions/toolkit/tree/main/packages/glob#patterns>` for a list of patterns accepted in this file.

For example, the following ``codeql-workspace.yml`` file defines a workspace that contains all CodeQl packs recursively found in the ``codeql-packs`` directory, except for the packs in the ``experimental`` directory:

.. code-block:: yaml

    provide:
      - "*/codeql-packs/**/qlpack.yml"
    ignore:
      - "*/codeql-packs/**/experimental/**/qlpack.yml"

To verify that you have the correct ``codeql-workspace.yml`` file, run ``codeql pack ls`` command in the same directory as your workspace. The result of the command is a list of all CodeQL packs in the workspace.

CodeQL workspaces and query resolution
--------------------------------------

All CodeQL packs in a workspace are available as source dependencies for each other when running any CodeQL command that resolves queries or packs. For example, when ``codeql pack install`` is run in a pack directory in a workspace, any dependency found in the workspace will not be downloaded to the package cache, nor will it be added to the resulting ``codeql-pack.lock.yml`` file. See `:ref:Adding and Installing Dependencies <adding-and-installing-dependencies>` for more information.

Similarly, publishing a CodeQL query pack to the GitHub container registry using  ``codeql pack publish`` will always use dependencies found in the workspace instead of using dependencies found in the local package cache.

This ensures that any local change to a query library in a dependency in the same workspace will be automatically reflected in the published query pack.

Example
~~~~~~~

Consider the following ``codeql-workspace.yml`` file:

.. code-block:: yaml

    provide:
      - "**/qlpack.yml"

And the following CodeQL library pack ``qlpack.yml`` file in the workspace:

.. code-block:: yaml

    name: my-company/my-library
    library: true
    version: 1.0.0

And the following CodeQL query pack ``qlpack.yml`` file in the workspace:

.. code-block:: yaml

    name: my-company/my-queries
    version: 1.0.0
    dependencies:
      my-company/my-library: "*"
      codeql/cpp-all: ~0.2.0

Notice that ``"*"`` is specified as the version constraint for the library pack. Because the library pack is a source dependency, the version constraint is not needed since the library pack's content is always resolved from inside of the workspace. Any version constraint will be ignored in this case, but it is recommended to use ``"*"`` for source dependencies to avoid confusion.

When ``codeql pack install`` is executed from the query pack directory, an appropriate version of ``codeql/cpp-all`` will be downloaded to the local package cache. Also, a ``codeql-pack.lock.yml`` file will be created that contains the resolved version of ``codeql/cpp-all``, but no entry for ``my-company/my-library`` since it is resolved from source. The ``codeql-pack.lock.yml`` file will look something like this:

.. code-block:: yaml

   dependencies:
     codeql/cpp-all:
       version: 0.2.2

When ``codeql pack publish`` is executed from the query pack directory, the ``codeql/cpp-all`` dependency from the package cache and the ``my-company/my-library`` from the workspace will be bundled with ``my-company/my-queries`` and published to the GitHub container registry.
