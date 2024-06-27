:tocdepth: 1

.. _exploring-the-structure-of-your-source-code:

Exploring the structure of your source code
=================================================

.. include:: ../reusables/vs-code-deprecation-note.rst

You can use the AST viewer to display the abstract syntax tree of a CodeQL database.

About the abstract syntax tree
-------------------------------

The abstract syntax tree (AST) of a program represents the program's syntactic structure. Nodes on the AST represent elements such as statements and expressions.
A CodeQL database encodes these program elements and the relationships between them through a :ref:`database schema <codeql-database-schema>`.

CodeQL for Visual Studio Code contains an AST viewer. The viewer consists of a graph visualization view that lets you explore the AST of a file in a CodeQL database. This helps you see which CodeQL classes correspond to which parts of your source files.

Viewing the abstract syntax tree of a source file
--------------------------------------------------

1. Open the CodeQL Databases view and right-click the database that you want to explore. Click **Add Database Source to Workspace**.

   .. image:: ../images/codeql-for-visual-studio-code/add-database-source-to-workspace.png
      :width: 350
      :alt: Add database source to workspace

2. Navigate to a CodeQL database's source file in the File Explorer.

   .. image:: ../images/codeql-for-visual-studio-code/open-source-file.png
      :width: 350
      :alt: Open a source file

3. Run **CodeQL: View AST** from the Command Palette. This runs a CodeQL query (usually called ``printAST.ql``) over the active file, which may take a few seconds.
   
   .. pull-quote:: Note

      If you don't have an appropriate ``printAST.ql`` query in your workspace, the **CodeQL: View AST** command won't work. To fix this, you can update your copy of the `CodeQL <https://github.com/github/codeql>`__ repository from ``main``. If you do this, you may need to upgrade your databases. Also, query caches may be discarded and your next query runs could be slower.

4. Once the query has run, the AST viewer displays the structure of the source file.
5. To see the nested structure, click the arrows and expand the nodes.

   .. image:: ../images/codeql-for-visual-studio-code/explore-ast.png
      :alt: Explore the AST

You can click a node in the AST viewer to jump to it in the source code. Conversely, if you click a section of the source code, the AST viewer displays the corresponding node.
