:tocdepth: 1

.. _working-with-codeql-packs-in-visual-studio-code:

Working with CodeQL packs in Visual Studio Code
===============================================

.. include:: ../reusables/vs-code-deprecation-note.rst

.. include:: ../reusables/beta-note-package-management.rst

You can view, write, and edit all types of CodeQL packs in Visual Studio Code using the CodeQL extension. 

About CodeQL packs
------------------
You use CodeQL packs to share your expertise in query writing, CodeQL library development, and modeling dependencies with other users. The CodeQL package management system ensures that when you publish a CodeQL pack it is ready to use, without any compilation. Anything the CodeQL pack depends on is explicitly defined within the pack. You can publish your own CodeQL packs and download packs created by others. For more information, see "`About CodeQL packs <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/about-codeql-packs>`__."

There are three types of CodeQL packs, each with a specific purpose.

- Query packs are designed to be run. When a query pack is published, the bundle includes all the transitive dependencies and pre-compiled representations of each query, in addition to the query sources. This ensures consistent and efficient execution of the queries in the pack.
- Model packs are used to model dependencies that are not supported by the standard CodeQL libraries. When you add a model pack to your analysis, all relevant queries also recognize the sources, sinks and flow steps of the dependencies defined in the pack.
- Library packs are designed to be used by query packs (or other library packs) and do not contain queries themselves. The libraries are not compiled separately.

Using the CodeQL packs shipped with the CLI in Visual Studio Code
-----------------------------------------------------------------
To install dependencies for a CodeQL pack in your Visual Studio Code workspace, run the **CodeQL: Install Pack Dependencies** command from the Command Palette and select the packs you want to install dependencies for.

You can write and run query packs that depend on the CodeQL standard libraries, without needing to check out the standard libraries in your workspace. Instead, you can install only the dependencies required by the query packs you want to use.

Working with CodeQL query packs
-------------------------------

One of the main benefits of working with a CodeQL query pack is that all dependencies are resolved, not just those defined within the query and standard libraries.

Creating and editing CodeQL query packs 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To create a new query pack, you will need to use the CodeQL CLI from a terminal, which you can do within Visual Studio Code or outside of it with the ``codeql pack init`` command. Once you create an empty pack, you can edit the ``qlpack.yml`` file or run the ``codeql pack add`` command to add dependencies or change the name or version. For detailed information, see "`Creating and working with CodeQL packs <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-and-working-with-codeql-packs>`__."

You can create or edit queries in a CodeQL pack in Visual Studio Code as you would with any CodeQL query, using the standard code editing features such as autocomplete suggestions to find elements to use from the pack's dependencies. 

You can then use the CodeQL CLI to publish your pack to share with others. For detailed information, see "`Publishing and using CodeQL packs <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/publishing-and-using-codeql-packs>`__."

Viewing CodeQL query packs and their dependencies
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To download a query pack that someone else has created, run the **CodeQL: Download Packs** command from the Command Palette.
You can download all the core query packs, or enter the full name of a specific pack to download. For example, to download the core queries for analyzing Java and Kotlin, enter ``codeql/java-queries``.

Whether you have downloaded a CodeQL pack or created your own, you can open the ``qlpack.yml`` file in the root of a CodeQL pack directory in Visual Studio Code and view the dependencies section to see what libraries the pack depends on.

If you want to understand a query in a CodeQL pack better, you can open the query file and view the code, using the IntelliSense code editing features of Visual Studio Code. For example, if you hover over an element from a library depended on by the pack, Visual Studio Code will resolve it so you can see documentation about the element. 

To view the full definition of an element of a query, you can right-click and choose **Go to Definition**. If the library pack is present within the same Visual Studio Code workspace, this will take you to the definition within the workspace. Otherwise it will take you to the definition within your package cache, the shared location where downloaded dependencies are stored, which is in your home directory by default.

Working with CodeQL model packs
-------------------------------

The CodeQL extension for Visual Studio Code includes a dedicated editor for creating and editing model packs. For information on using the model editor, see ":ref:`Using the CodeQL model editor <using-the-codeql-model-editor>`."
