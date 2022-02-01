:tocdepth: 1

.. _working-with-codeql-packs-in-visual-studio-code:

Working with CodeQL packs in Visual Studio Code
===============================================

.. include:: ../reusables/beta-note-package-management.rst

You can view CodeQL packs and write and edit queries for them in Visual Studio Code. 

About CodeQL packs
------------------
CodeQL packs are used to create, share, depend on, and run CodeQL queries and libraries. You can publish your own CodeQL packs and download packs created by others. For more information, see ":ref:`About CodeQL packs <about-codeql-packs>`."

Using standard CodeQL packs in Visual Studio Code
--------------------------------------------------------------
To install dependencies for a CodeQL pack in your Visual Studio Code workspace, run the **CodeQL: Install Pack Dependencies** command from the Command Palette and select the packs you want to install dependencies for.

You can write and run query packs that depend on the CodeQL standard libraries, without needing to check out the standard libraries in your workspace. Instead, you can install only the dependencies required by the query packs you want to use.

Creating and editing CodeQL packs in Visual Studio Code
-------------------------------------------------------
To create a new CodeQL pack, you will need to use the CodeQL CLI from a terminal, which you can do within Visual Studio Code or outside of it with the ``codeql pack init`` command. Once you create an empty pack, you can edit the ``qlpack.yml`` file or run the ``codeql pack add`` command to add dependencies or change the name or version. For more information, see ":ref:`Creating and working with CodeQL packs <creating-and-working-with-codeql-packs>`."

You can create or edit queries in a CodeQL pack in Visual Studio Code as you would with any CodeQL query, using the standard code editing features such as autocomplete suggestions to find elements to use from the pack's dependencies. 

You can then use the CodeQL CLI to publish your pack to share with others. For more information, see ":ref:`Publishing and using CodeQL packs <publishing-and-using-codeql-packs>`."

Viewing CodeQL packs and their dependencies in Visual Studio Code
-----------------------------------------------------------------
To download a CodeQL pack that someone else has created, run the **CodeQL: Download Packs** command from the Command Palette.
You can download all the core CodeQL query packs, or enter the full name of a specific pack to download. For example, to download the core queries for analyzing Java, enter ``codeql/java-queries``.

Whether you have downloaded a CodeQL pack or created your own, you can open the ``qlpack.yml`` file in the root of a CodeQL pack directory in Visual Studio Code and view the dependencies section to see what libraries the pack depends on.

If you want to understand a query in a CodeQL pack better, you can open the query file and view the code, using the IntelliSense code editing features of Visual Studio Code. For example, if you hover over an element from a library depended on by the pack, Visual Studio Code will resolve it so you can see documentation about the element. 

To view the full definition of an element of a query, you can right-click and choose **Go to Definition**. If the library pack is present within the same Visual Studio Code workspace, this will take you to the definition within the workspace. Otherwise it will take you to the definition within your package cache, the shared location where downloaded dependencies are stored, which is in your home directory by default.
