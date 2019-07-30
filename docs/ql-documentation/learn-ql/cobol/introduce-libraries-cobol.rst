Introducing the QL libraries for COBOL
======================================

Overview
--------

There is an extensive QL library for analyzing COBOL code. The classes in this library present the data from a snapshot database in an object-oriented form and provide abstractions and predicates to help you with common analysis tasks.

The library is implemented as a set of QL modules–that is, files with the extension ``.qll``. The module ``cobol.qll`` imports most other standard library modules, so you can include the complete library by beginning your query with:

.. code-block:: ql

   import cobol

The rest of this tutorial briefly summarizes the most important QL classes and predicates provided by this library, including references to the `detailed API documentation <https://help.semmle.com/qldoc/cobol/>`__ where applicable.

Introducing the library
-----------------------

The QL COBOL library presents information about COBOL source code at different levels:

-  **Textual** — classes that represent source code as unstructured text files
-  **Lexical** — classes that represent comments and other tokens of interest
-  **Syntactic** — classes that represent source code as an abstract syntax tree
-  **Name binding** — classes that represent data entries and data references
-  **Control flow** — classes that represent the flow of control during execution
-  **Frameworks** — classes that represent interactions via CICS and SQL

Note that representations above the textual level (for example the lexical representation or the flow graphs) are only available for COBOL code that does not contain fatal syntax errors. For code with such errors, the only information available is at the textual level, as well as information about the errors themselves.

Textual level
~~~~~~~~~~~~~

At its most basic level, a COBOL code base can simply be viewed as a collection of files organized into folders.

Files and folders
^^^^^^^^^^^^^^^^^

In QL, files are represented as entities of class `File <https://help.semmle.com/qldoc/cobol/semmle/cobol/Files.qll/type.Files$File.html>`__, and folders as entities of class `Folder <https://help.semmle.com/qldoc/cobol/semmle/cobol/Files.qll/type.Files$Folder.html>`__, both of which are subclasses of class `Container <https://help.semmle.com/qldoc/cobol/semmle/cobol/Files.qll/type.Files$Container.html>`__.

Class `Container <https://help.semmle.com/qldoc/cobol/semmle/cobol/Files.qll/type.Files$Container.html>`__ provides the following member predicates:

-  ``Container.getParentContainer()`` returns the parent folder of the file or folder.
-  ``Container.getAFile()`` returns a file within the folder.
-  ``Container.getAFolder()`` returns a folder nested within the folder.

Note that while ``getAFile`` and ``getAFolder`` are declared on class `Container <https://help.semmle.com/qldoc/cobol/semmle/cobol/Files.qll/type.Files$Container.html>`__, they currently only have results for `Folder <https://help.semmle.com/qldoc/cobol/semmle/cobol/Files.qll/type.Files$Folder.html>`__\ s.

Both files and folders have paths, which can be accessed by the predicate ``Container.getAbsolutePath()``. For example, if ``f`` represents a file with the path ``/home/user/project/src/main.cbl``, then ``f.getAbsolutePath()`` evaluates to the string ``"/home/user/project/src/main.cbl"``, while ``f.getParentContainer().getAbsolutePath()`` returns ``"/home/user/project/src"``.

These paths are absolute file system paths. If you want to obtain the path of a file relative to the snapshot source location, use ``Container.getRelativePath()`` instead. Note, however, that a snapshot may contain files that are not located underneath the snapshot source location; for such files, ``getRelativePath()`` will not return anything.

The following member predicates of class `Container <https://help.semmle.com/qldoc/cobol/semmle/cobol/Files.qll/type.Files$Container.html>`__ provide more information about the name of a file or folder:

-  ``Container.getBaseName()`` returns the base name of a file or folder, not including its parent folder, but including its extension. In the above example, ``f.getBaseName()`` would return the string ``"main.cbl"``.
-  ``Container.getStem()`` is similar to ``Container.getBaseName()``, but it does *not* include the file extension; so ``f.getStem()`` returns ``"main"``.
-  ``Container.getExtension()`` returns the file extension, not including the dot; so ``f.getExtension()`` returns ``"cbl"``.

For example, the following query computes, for each folder, the number of COBOL files (that is, files with extension ``cbl``) contained in the folder:

.. code-block:: ql

   import cobol

   from Folder d
   select d.getRelativePath(), count(File f | f = d.getAFile() and f.getExtension() = "cbl")

Locations
^^^^^^^^^

Most entities in a snapshot database have an associated source location. Locations are identified by four pieces of information: a file, a start line, a start column, an end line, and an end column. Line and column counts are 1-based (so the first character of a file is at line 1, column 1), and the end position is inclusive.

All entities associated with a source location belong to the QL class `Locatable <https://help.semmle.com/qldoc/cobol/semmle/cobol/Location.qll/type.Location$Locatable.html>`__. The location itself is modeled by the QL class `Location <https://help.semmle.com/qldoc/cobol/semmle/cobol/Location.qll/type.Location$Location.html>`__ and can be accessed through the member predicate ``Locatable.getLocation()``. The `Location <https://help.semmle.com/qldoc/cobol/semmle/cobol/Location.qll/type.Location$Location.html>`__ class provides the following member predicates:

-  ``Location.getFile()``, ``Location.getStartLine()``, ``Location.getStartColumn()``, ``Location.getEndLine()``, ``Location.getEndColumn()`` return detailed information about the location.
-  ``Location.getNumLines()`` returns the number of (whole or partial) lines covered by the location.
-  ``Location.startsBefore(Location)`` and ``Location.endsAfter(Location)`` determine whether one location starts before or ends after another location.
-  ``Location.contains(Location)`` indicates whether one location completely contains another location; ``l1.contains(l2)`` holds if, and only if, ``l1.startsBefore(l2)`` and ``l1.endsAfter(l2)``.

Lexical level
~~~~~~~~~~~~~

At this level we represent comments through the `Comment <https://help.semmle.com/qldoc/cobol/semmle/cobol/Comments.qll/type.Comments$Comment.html>`__ class. We do not currently retain any tokens other than scope terminators (for example ``END-IF``), which are represented by the `ScopeTerminator <https://help.semmle.com/qldoc/cobol/semmle/cobol/Stmts.qll/type.Stmts$ScopeTerminator.html>`__ class.

Comments
^^^^^^^^

The class `Comment <https://help.semmle.com/qldoc/cobol/semmle/cobol/Comments.qll/type.Comments$Comment.html>`__ represents the comments that occur in COBOL programs:

The most important member predicates are as follows:

-  ``Comment.getText()`` returns the source text of the comment, not including delimiters.
-  ``Comment.getScope()`` returns the location of the source code to which the comment is bound.

Scope terminators
^^^^^^^^^^^^^^^^^

The class `ScopeTerminator <https://help.semmle.com/qldoc/cobol/semmle/cobol/Stmts.qll/type.Stmts$ScopeTerminator.html>`__ represents the scope terminators that occur in COBOL programs:

The most important member predicates are as follows:

-  ``ScopeTerminator.getStmt()`` returns the statement whose scope this terminator is closing.

Syntactic level
~~~~~~~~~~~~~~~

The majority of classes in the QL COBOL library is concerned with representing a COBOL program as a collection of `abstract syntax trees <http://en.wikipedia.org/wiki/Abstract_syntax_tree>`__ (ASTs).

The QL class `ASTNode <https://help.semmle.com/qldoc/cobol/semmle/cobol/AstNode.qll/type.AstNode$AstNode.html>`__ contains all entities representing nodes in the abstract syntax trees and defines generic tree traversal predicates:

-  ``ASTNode.getParent()``: returns the parent node of this AST node, if any.

Please note that the QL libraries for COBOL do not currently represent all possible parts of a COBOL program. Due to the complexity of the language, and its many dialects, this is an ongoing task. We prioritize elements that are of interest to queries, and expand this selection over time. Please check the `detailed API documentation <https://help.semmle.com/qldoc/cobol/>`__ to see what is currently available.

The main structure of any COBOL program is represented by the `Unit <https://help.semmle.com/qldoc/cobol/semmle/cobol/Units.qll/type.Units$Unit.html>`__ class and its subclasses. For example, each program definition has a `ProgramDefinition <https://help.semmle.com/qldoc/cobol/semmle/cobol/Units.qll/type.Units$ProgramDefinition.html>`__ counterpart. For each ``PROCEDURE DIVISION`` in the program, there will be a `ProcedureDivision <https://help.semmle.com/qldoc/cobol/semmle/cobol/AST_extended.qll/type.AST_extended$ProcedureDivision.html>`__ class.

All data definitions are made accessible through the `DescriptionEntry <https://help.semmle.com/qldoc/cobol/semmle/cobol/DataEntries.qll/type.DataEntries$DescriptionEntry.html>`__ class and its subclasses. In particular, you can use `DataDescriptionEntry <https://help.semmle.com/qldoc/cobol/semmle/cobol/DataEntries.qll/type.DataEntries$DataDescriptionEntry.html>`__ to find the typical data entries defined in a ``WORKING-STORAGE SECTION``.

References to data items are modeled through the `DataReference <https://help.semmle.com/qldoc/cobol/semmle/cobol/References.qll/type.References$DataReference.html>`__ class. You can use ``DataReference.getTarget()`` to resolve the reference to the matching data item.

Individual statements are represented by the class `Stmt <https://help.semmle.com/qldoc/cobol/semmle/cobol/Stmts.qll/type.Stmts$Stmt.html>`__ and its subclasses. The name of the specific type starts with the statement's verb. For example, ``OPEN`` statements are covered by the class `Open <https://help.semmle.com/qldoc/cobol/semmle/cobol/Stmts.qll/type.Stmts$Open.html>`__. Unknown statement types are covered by the 
`OtherStmt <https://help.semmle.com/qldoc/cobol/semmle/cobol/AST_extended.qll/type.AST_extended$OtherStmt.html>`__ class.

Control flow
~~~~~~~~~~~~

You can represent a program in terms of its control flow graph (CFG) using the ``AstNode.getASuccessor`` predicate. You can use this predicate to find possible successors to any statement, sentence, or unit in a procedure division.

Parse errors
~~~~~~~~~~~~~

COBOL code that contains breaking syntax errors cannot usually be analyzed. All that is available in this case is a value of class `Error <https://help.semmle.com/qldoc/cobol/semmle/cobol/Errors.qll/type.Errors$Error.html>`__ representing the parse error. It provides information about the syntax error location and the error message through predicates ``Error.getLocation`` and ``Error.getMessage`` respectively.

Frameworks
~~~~~~~~~~

CICS
^^^^

Calls to the CICS system through ``EXEC CICS`` are represented by the class `CICS <https://help.semmle.com/qldoc/cobol/semmle/cobol/AST_extended.qll/type.AST_extended$Cics.html>`__.

SQL
^^^

Calls to the SQL system through ``EXEC SQL`` are represented by the class
`SqlStmt <https://help.semmle.com/qldoc/cobol/semmle/cobol/Sql.qll/type.Sql$SqlStmt.html>`__ and its subclasses.

What next?
----------

-  Find out more about QL in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ and `QL language specification <https://help.semmle.com/QL/ql-spec/language.html>`__.
-  Learn more about the query console in `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.
