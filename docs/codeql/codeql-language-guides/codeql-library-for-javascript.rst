.. _codeql-library-for-javascript:

CodeQL library for JavaScript
=============================

When you're analyzing a JavaScript program, you can make use of the large collection of classes in the CodeQL library for JavaScript.

Overview
--------

There is an extensive CodeQL library for analyzing JavaScript code. The classes in this library present the data from a CodeQL database in an object-oriented form and provide abstractions and predicates to help you with common analysis tasks.

The library is implemented as a set of QL modules, that is, files with the extension ``.qll``. The module ``javascript.qll`` imports most other standard library modules, so you can include the complete library by beginning your query with:

.. code-block:: ql

   import javascript

The rest of this tutorial briefly summarizes the most important classes and predicates provided by this library, including references to the `detailed API documentation <https://codeql.github.com/codeql-standard-libraries/javascript/>`__ where applicable.

Introducing the library
-----------------------

The CodeQL library for JavaScript presents information about JavaScript source code at different levels:

-  **Textual** — classes that represent source code as unstructured text files
-  **Lexical** — classes that represent source code as a series of tokens and comments
-  **Syntactic** — classes that represent source code as an abstract syntax tree
-  **Name binding** — classes that represent scopes and variables
-  **Control flow** — classes that represent the flow of control during execution
-  **Data flow** — classes that you can use to reason about data flow in JavaScript source code
-  **Type inference** — classes that you can use to approximate types for JavaScript expressions and variables
-  **Call graph** — classes that represent the caller-callee relationship between functions
-  **Inter-procedural data flow** — classes that you can use to define inter-procedural data flow and taint tracking analyses
-  **Frameworks** — classes that represent source code entities that have a special meaning to JavaScript tools and frameworks

Note that representations above the textual level (for example the lexical representation or the flow graphs) are only available for JavaScript code that does not contain fatal syntax errors. For code with such errors, the only information available is at the textual level, as well as information about the errors themselves.

Additionally, there is library support for working with HTML documents, JSON, and YAML data, JSDoc comments, and regular expressions.

Textual level
~~~~~~~~~~~~~

At its most basic level, a JavaScript code base can simply be viewed as a collection of files organized into folders, where each file is composed of zero or more lines of text.

Note that the textual content of a program is not included in the CodeQL database unless you specifically request it during extraction.

Files and folders
^^^^^^^^^^^^^^^^^

In the CodeQL libraries, files are represented as entities of class `File <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$File.html>`__, and folders as entities of class `Folder <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$Folder.html>`__, both of which are subclasses of class `Container <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$Container.html>`__.

Class `Container <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$Container.html>`__ provides the following member predicates:

-  ``Container.getParentContainer()`` returns the parent folder of the file or folder.
-  ``Container.getAFile()`` returns a file within the folder.
-  ``Container.getAFolder()`` returns a folder nested within the folder.

Note that while ``getAFile`` and ``getAFolder`` are declared on class `Container <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$Container.html>`__, they currently only have results for `Folder <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$Folder.html>`__\ s.

Both files and folders have paths, which can be accessed by the predicate ``Container.getAbsolutePath()``. For example, if ``f`` represents a file with the path ``/home/user/project/src/index.js``, then ``f.getAbsolutePath()`` evaluates to the string ``"/home/user/project/src/index.js"``, while ``f.getParentContainer().getAbsolutePath()`` returns ``"/home/user/project/src"``.

These paths are absolute file system paths. If you want to obtain the path of a file relative to the source location in the CodeQL database, use ``Container.getRelativePath()`` instead. Note, however, that a database may contain files that are not located underneath the source location; for such files, ``getRelativePath()`` will not return anything.

The following member predicates of class `Container <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$Container.html>`__ provide more information about the name of a file or folder:

-  ``Container.getBaseName()`` returns the base name of a file or folder, not including its parent folder, but including its extension. In the above example, ``f.getBaseName()`` would return the string ``"index.js"``.
-  ``Container.getStem()`` is similar to ``Container.getBaseName()``, but it does *not* include the file extension; so ``f.getStem()`` returns ``"index"``.
-  ``Container.getExtension()`` returns the file extension, not including the dot; so ``f.getExtension()`` returns ``"js"``.

For example, the following query computes, for each folder, the number of JavaScript files (that is, files with extension ``js``) contained in the folder:

.. code-block:: ql

   import javascript

   from Folder d
   select d.getRelativePath(), count(File f | f = d.getAFile() and f.getExtension() = "js")

When you run the query on most projects, the results include folders that contain files with a ``js`` extension and folders that don't.

Locations
^^^^^^^^^

Most entities in a CodeQL database have an associated source location. Locations are identified by five pieces of information: a file, a start line, a start column, an end line, and an end column. Line and column counts are 1-based (so the first character of a file is at line 1, column 1), and the end position is inclusive.

All entities associated with a source location belong to the class `Locatable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Locations.qll/type.Locations$Locatable.html>`__. The location itself is modeled by the class `Location <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Locations.qll/type.Locations$Location.html>`__ and can be accessed through the member predicate ``Locatable.getLocation()``. The `Location <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Locations.qll/type.Locations$Location.html>`__ class provides the following member predicates:

-  ``Location.getFile()``, ``Location.getStartLine()``, ``Location.getStartColumn()``, ``Location.getEndLine()``, ``Location.getEndColumn()`` return detailed information about the location.
-  ``Location.getNumLines()`` returns the number of (whole or partial) lines covered by the location.
-  ``Location.startsBefore(Location)`` and ``Location.endsAfter(Location)`` determine whether one location starts before or ends after another location.
-  ``Location.contains(Location)`` indicates whether one location completely contains another location; ``l1.contains(l2)`` holds if, and only if, ``l1.startsBefore(l2)`` and ``l1.endsAfter(l2)``.

Lines
^^^^^

Lines of text in files are represented by the class `Line <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Lines.qll/type.Lines$Line.html>`__. This class offers the following member predicates:

-  ``Line.getText()`` returns the text of the line, excluding any terminating newline characters.
-  ``Line.getTerminator()`` returns the terminator character(s) of the line. The last line in a file may not have any terminator characters, in which case this predicate does not return anything; otherwise it returns either the two-character string ``"\r\n"`` (carriage-return followed by newline), or one of the one-character strings ``"\n"`` (newline), ``"\r"`` (carriage-return), ``"\u2028"`` (Unicode character LINE SEPARATOR), ``"\u2029"`` (Unicode character PARAGRAPH SEPARATOR).

Note that, as mentioned above, the textual representation of the program is not included in the CodeQL database by default.

Lexical level
~~~~~~~~~~~~~

A slightly more structured view of a JavaScript program is provided by the classes `Token <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$Token.html>`__ and `Comment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$Comment.html>`__, which represent tokens and comments, respectively.

Tokens
^^^^^^

The most important member predicates of class `Token <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$Token.html>`__ are as follows:

-  ``Token.getValue()`` returns the source text of the token.
-  ``Token.getIndex()`` returns the index of the token within its enclosing script.
-  ``Token.getNextToken()`` and ``Token.getPreviousToken()`` navigate between tokens.

The `Token <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$Token.html>`__ class has nine subclasses, each representing a particular kind of token:

-  `EOFToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$EOFToken.html>`__: a marker token representing the end of a script
-  `NullLiteralToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$NullLiteralToken.html>`__, `BooleanLiteralToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$BooleanLiteralToken.html>`__, `NumericLiteralToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$NumericLiteralToken.html>`__, `StringLiteralToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$StringLiteralToken.html>`__ and `RegularExpressionToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$RegularExpressionToken.html>`__: different kinds of literals
-  `IdentifierToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$IdentifierToken.html>`__ and `KeywordToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$KeywordToken.html>`__: identifiers and keywords (including reserved words) respectively
-  `PunctuatorToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$PunctuatorToken.html>`__: operators and other punctuation symbols

As an example of a query operating entirely on the lexical level, consider the following query, which finds consecutive comma tokens arising from an omitted element in an array expression:

.. code-block:: ql

   import javascript

   class CommaToken extends PunctuatorToken {
       CommaToken() {
           getValue() = ","
       }
   }

   from CommaToken comma
   where comma.getNextToken() instanceof CommaToken
   select comma, "Omitted array elements are bad style."

If the query returns no results, this pattern isn't used in the projects that you analyzed.

You can use predicate ``Locatable.getFirstToken()`` and ``Locatable.getLastToken()`` to access the first and last token (if any) belonging to an element with a source location.

Comments
^^^^^^^^

The class `Comment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$Comment.html>`__ and its subclasses represent the different kinds of comments that can occur in JavaScript programs:

-  `Comment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$Comment.html>`__: any comment

   -  `LineComment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$LineComment.html>`__: a single-line comment terminated by an end-of-line character

      -  `SlashSlashComment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$SlashSlashComment.html>`__: a plain JavaScript single-line comment starting with ``//``
      -  `HtmlLineComment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$HtmlLineComment.html>`__: a (non-standard) HTML comment

         -  `HtmlCommentStart <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$HtmlCommentStart.html>`__: an HTML comment starting with ``<!--``

         -  `HtmlCommentEnd <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$HtmlCommentEnd.html>`__: an HTML comment ending with ``-->``

   -  `BlockComment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$BlockComment.html>`__: a block comment potentially spanning multiple lines

      -  `SlashStarComment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$SlashStarComment.html>`__: a plain JavaScript block comment surrounded with ``/*...*/``
      -  `DocComment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$DocComment.html>`__: a documentation block comment surrounded with ``/**...*/``

The most important member predicates are as follows:

-  ``Comment.getText()`` returns the source text of the comment, not including delimiters.
-  ``Comment.getLine(i)`` returns the ``i``\ th line of text within the comment (0-based).
-  ``Comment.getNumLines()`` returns the number of lines in the comment.
-  ``Comment.getNextToken()`` returns the token immediately following a comment. Note that such a token always exists: if a comment appears at the end of a file, its following token is an `EOFToken <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Tokens.qll/type.Tokens$EOFToken.html>`__.

As an example of a query using only lexical information, consider the following query for finding HTML comments, which are not a standard ECMAScript feature and should be avoided:

.. code-block:: ql

   import javascript

   from HtmlLineComment c
   select c, "Do not use HTML comments."

Syntactic level
~~~~~~~~~~~~~~~

The majority of classes in the JavaScript library is concerned with representing a JavaScript program as a collection of `abstract syntax trees <https://en.wikipedia.org/wiki/Abstract_syntax_tree>`__ (ASTs).

The class `ASTNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$ASTNode.html>`__ contains all entities representing nodes in the abstract syntax trees and defines generic tree traversal predicates:

-  ``ASTNode.getChild(i)``: returns the ``i``\ th child of this AST node.
-  ``ASTNode.getAChild()``: returns any child of this AST node.
-  ``ASTNode.getParent()``: returns the parent node of this AST node, if any.

.. pull-quote::

   Note

   These predicates should only be used to perform generic AST traversal. To access children of specific AST node types, the specialized predicates introduced below should be used instead. In particular, queries should not rely on the numeric indices of child nodes relative to their parent nodes: these are considered an implementation detail that may change between versions of the library.

Top-levels
^^^^^^^^^^

From a syntactic point of view, each JavaScript program is composed of one or more top-level code blocks (or *top-levels* for short), which are blocks of JavaScript code that do not belong to a larger code block. Top-levels are represented by the class `TopLevel <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$TopLevel.html>`__ and its subclasses:

-  `TopLevel <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$TopLevel.html>`__

   -  `Script <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$Script.html>`__: a stand-alone file or HTML ``<script>`` element

      -  `ExternalScript <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$ExternalScript.html>`__: a stand-alone JavaScript file
      -  `InlineScript <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$InlineScript.html>`__: code embedded inline in an HTML ``<script>`` tag

   -  `CodeInAttribute <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$CodeInAttribute.html>`__: a code block originating from an HTML attribute value

      -  `EventHandlerCode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$EventHandlerCode.html>`__: code from an event handler attribute such as ``onload``
      -  `JavaScriptURL <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$JavaScriptURL.html>`__: code from a URL with the ``javascript:`` scheme

   -  `Externs <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$Externs.html>`__: a JavaScript file containing `externs <https://developers.google.com/closure/compiler/docs/externs-and-exports>`__ definitions

Every `TopLevel <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$TopLevel.html>`__ class is contained in a `File <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$File.html>`__ class, but a single `File <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$File.html>`__ may contain more than one `TopLevel <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$TopLevel.html>`__. To go from a ``TopLevel tl`` to its `File <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$File.html>`__, use ``tl.getFile()``; conversely, for a ``File f``, predicate ``f.getATopLevel()`` returns a top-level contained in ``f``. For every AST node, predicate ``ASTNode.getTopLevel()`` can be used to find the top-level it belongs to.

The `TopLevel <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$TopLevel.html>`__ class additionally provides the following member predicates:

-  ``TopLevel.getNumberOfLines()`` returns the total number of lines (including code, comments and whitespace) in the top-level.
-  ``TopLevel.getNumberOfLinesOfCode()`` returns the number of lines of code, that is, lines that contain at least one token.
-  ``TopLevel.getNumberOfLinesOfComments()`` returns the number of lines containing or belonging to a comment.
-  ``TopLevel.isMinified()`` determines whether the top-level contains minified code, using a heuristic based on the average number of statements per line.

.. pull-quote::

   Note

   By default, GitHub code scanning filters out alerts in minified top-levels, since they are often hard to interpret. When you write your own queries in Visual Studio Code, this filtering is *not* done automatically, so you may want to explicitly add a condition of the form ``and not e.getTopLevel().isMinified()`` or similar to your query to exclude results in minified code.

Statements and expressions
^^^^^^^^^^^^^^^^^^^^^^^^^^

The most important subclasses of `ASTNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$ASTNode.html>`__ besides `TopLevel <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$TopLevel.html>`__ are `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__ and `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__, which, together with their subclasses, represent statements and expressions, respectively. This section briefly discusses some of the more important classes and predicates. For a full reference of all the subclasses of `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__ and `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__ and their API, see
`Stmt.qll <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/module.Stmt.html>`__ and `Expr.qll <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/module.Expr.html>`__.

-  `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__: use ``Stmt.getContainer()`` to access the innermost function or top-level in which the statement is contained.

   -  `ControlStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ControlStmt.html>`__: a statement that controls the execution of other statements, that is, a conditional, loop, ``try`` or ``with`` statement; use ``ControlStmt.getAControlledStmt()`` to access the statements that it controls.

      -  `IfStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$IfStmt.html>`__: an ``if`` statement; use ``IfStmt.getCondition()``, ``IfStmt.getThen()`` and ``IfStmt.getElse()`` to access its condition expression, "then" branch and "else" branch, respectively.
      -  `LoopStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$LoopStmt.html>`__: a loop; use ``Loop.getBody()`` and ``Loop.getTest()`` to access its body and its test expression, respectively.

         -  `WhileStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$WhileStmt.html>`__, `DoWhileStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$DoWhileStmt.html>`__: a "while" or "do-while" loop, respectively.
         -  `ForStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ForStmt.html>`__: a "for" statement; use ``ForStmt.getInit()`` and ``ForStmt.getUpdate()`` to access the init and update expressions, respectively.
         -  `EnhancedForLoop <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$EnhancedForLoop.html>`__: a "for-in" or "for-of" loop; use ``EnhancedForLoop.getIterator()`` to access the loop iterator (which may be a expression or variable declaration), and ``EnhancedForLoop.getIterationDomain()`` to access the expression being iterated over.

            -  `ForInStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ForInStmt.html>`__, `ForOfStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ForOfStmt.html>`__: a "for-in" or "for-of" loop, respectively.

      -  `WithStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$WithStmt.html>`__: a "with" statement; use ``WithStmt.getExpr()`` and ``WithStmt.getBody()`` to access the controlling expression and the body of the with statement, respectively.
      -  `SwitchStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$SwitchStmt.html>`__: a switch statement; use ``SwitchStmt.getExpr()`` to access the expression on which the statement switches; use ``SwitchStmt.getCase(int)`` and ``SwitchStmt.getACase()`` to access individual switch cases; each case is modeled by an entity of class `Case <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Case.html>`__, whose member predicates ``Case.getExpr()`` and ``Case.getBodyStmt(int)`` provide access to the expression checked by the switch case (which is undefined for ``default``), and its body.
      -  `TryStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$TryStmt.html>`__: a "try" statement; use ``TryStmt.getBody()``, ``TryStmt.getCatchClause()`` and ``TryStmt.getFinally`` to access its body, "catch" clause and "finally" block, respectively.

   -  `BlockStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$BlockStmt.html>`__: a block of statements; use ``BlockStmt.getStmt(int)`` to access the individual statements in the block.
   -  `ExprStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ExprStmt.html>`__: an expression statement; use ``ExprStmt.getExpr()`` to access the expression itself.
   -  `JumpStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$JumpStmt.html>`__: a statement that disrupts structured control flow, that is, one of ``break``, ``continue``, ``return`` and ``throw``; use predicate ``JumpStmt.getTarget()`` to determine the target of the jump, which is either a statement or (for ``return`` and uncaught ``throw`` statements) the enclosing function.

      -  `BreakStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$BreakStmt.html>`__: a "break" statement; use ``BreakStmt.getLabel()`` to access its (optional) target label.
      -  `ContinueStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ContinueStmt.html>`__: a "continue" statement; use ``ContinueStmt.getLabel()`` to access its (optional) target label.
      -  `ReturnStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ReturnStmt.html>`__: a "return" statement; use ``ReturnStmt.getExpr()`` to access its (optional) result expression.
      -  `ThrowStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ThrowStmt.html>`__: a "throw" statement; use ``ThrowStmt.getExpr()`` to access its thrown expression.

   -  `FunctionDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$FunctionDeclStmt.html>`__: a function declaration statement; see below for available member predicates.
   -  `ClassDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ClassDeclStmt.html>`__: a class declaration statement; see below for available member predicates.
   -  `DeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$DeclStmt.html>`__: a declaration statement containing one or more declarators which can be accessed by predicate ``DeclStmt.getDeclarator(int)``.

      -  `VarDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$VarDeclStmt.html>`__, `ConstDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ConstDeclStmt.html>`__, `LetStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$LetStmt.html>`__: a ``var``, ``const`` or ``let`` declaration statement.

-  `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__: use ``Expr.getEnclosingStmt()`` to obtain the innermost statement to which this expression belongs; ``Expr.isPure()`` determines whether the expression is side-effect-free.

   -  `Identifier <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Identifier.html>`__: an identifier; use ``Identifier.getName()`` to obtain its name.
   -  `Literal <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Literal.html>`__: a literal value; use ``Literal.getValue()`` to obtain a string representation of its value, and ``Literal.getRawValue()`` to obtain its raw source text (including surrounding quotes for string literals).

      -  `NullLiteral <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$NullLiteral.html>`__, `BooleanLiteral <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$BooleanLiteral.html>`__, `NumberLiteral <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$NumberLiteral.html>`__, `StringLiteral <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$StringLiteral.html>`__, `RegExpLiteral <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$RegExpLiteral.html>`__: different kinds of literals.

   -  `ThisExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ThisExpr.html>`__: a "this" expression.
   -  `SuperExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$SuperExpr.html>`__: a "super" expression.
   -  `ArrayExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ArrayExpr.html>`__: an array expression; use ``ArrayExpr.getElement(i)`` to obtain the ``i``\ th element expression, and ``ArrayExpr.elementIsOmitted(i)`` to check whether the ``i``\ th element is omitted.
   -  `ObjectExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ObjectExpr.html>`__: an object expression; use ``ObjectExpr.getProperty(i)`` to obtain the ``i``\ th property in the object expression; properties are modeled by class `Property <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Property.html>`__, which is described in more detail below.
   -  `FunctionExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$FunctionExpr.html>`__: a function expression; see below for available member predicates.
   -  `ArrowFunctionExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ArrowFunctionExpr.html>`__: an ECMAScript 2015-style arrow function expression; see below for available member predicates.
   -  `ClassExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ClassExpr.html>`__: a class expression; see below for available member predicates.
   -  `ParExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ParExpr.html>`__: a parenthesized expression; use ``ParExpr.getExpression()`` to obtain the operand expression; for any expression, ``Expr.stripParens()`` can be used to recursively strip off any parentheses
   -  `SeqExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$SeqExpr.html>`__: a sequence of two or more expressions connected by the comma operator; use ``SeqExpr.getOperand(i)`` to obtain the ``i``\ th sub-expression.
   -  `ConditionalExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ConditionalExpr.html>`__: a ternary conditional expression; member predicates ``ConditionalExpr.getCondition()``, ``ConditionalExpr.getConsequent()`` and ``ConditionalExpr.getAlternate()`` provide access to the condition expression, the "then" expression and the "else" expression, respectively.
   -  `InvokeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$InvokeExpr.html>`__: a function call or a "new" expression; use ``InvokeExpr.getCallee()`` to obtain the expression specifying the function to be called, and ``InvokeExpr.getArgument(i)`` to obtain the ``i``\ th argument expression.

      -  `CallExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$CallExpr.html>`__: a function call.
      -  `NewExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$NewExpr.html>`__: a "new" expression.
      -  `MethodCallExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$MethodCallExpr.html>`__: a function call whose callee expression is a property access; use ``MethodCallExpr.getReceiver`` to access the receiver expression of the method call, and ``MethodCallExpr.getMethodName()`` to get the method name (if it can be determined statically).

   -  `PropAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PropAccess.html>`__: a property access, that is, either a "dot" expression of the form ``e.f`` or an index expression of the form ``e[p]``; use ``PropAccess.getBase()`` to obtain the base expression on which the property is accessed (``e`` in the example), and ``PropAccess.getPropertyName()`` to determine the name of the accessed property; if the name cannot be statically determined, ``getPropertyName()`` does not return any value.

      -  `DotExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$DotExpr.html>`__: a "dot" expression.
      -  `IndexExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$IndexExpr.html>`__: an index expression (also known as computed property access).

   -  `UnaryExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$UnaryExpr.html>`__: a unary expression; use ``UnaryExpr.getOperand()`` to obtain the operand expression.

      -  `NegExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$NegExpr.html>`__ ("-"), `PlusExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PlusExpr.html>`__ ("+"), `LogNotExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$LogNotExpr.html>`__ ("!"), `BitNotExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$BitNotExpr.html>`__ ("~"), `TypeofExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$TypeofExpr.html>`__, `VoidExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$VoidExpr.html>`__, `DeleteExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$DeleteExpr.html>`__, `SpreadElement <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$SpreadElement.html>`__ ("..."): various types of unary expressions.

   -  `BinaryExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$BinaryExpr.html>`__: a binary expression; use ``BinaryExpr.getLeftOperand()`` and ``BinaryExpr.getRightOperand()`` to access the operand expressions.

      -  `Comparison <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Comparison.html>`__: any comparison expression.

         -  `EqualityTest <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$EqualityTest.html>`__: any equality or inequality test.

            -  `EqExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$EqExpr.html>`__ ("=="), `NEqExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$NEqExpr.html>`__ ("!="): non-strict equality and inequality tests.
            -  `StrictEqExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$StrictEqExpr.html>`__ ("==="), `StrictNEqExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$StrictNEqExpr.html>`__ ("!=="): strict equality and inequality tests.

         -  `LTExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$LTExpr.html>`__ ("<"), `LEExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$LEExpr.html>`__ ("<="), `GTExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$GTExpr.html>`__ (">"), `GEExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$GEExpr.html>`__ (">="): numeric comparisons.

      -  `LShiftExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$LShiftExpr.html>`__ ("<<"), `RShiftExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$RShiftExpr.html>`__ (">>"), `URShiftExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$URShiftExpr.html>`__ (">>>"): shift operators.
      -  `AddExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AddExpr.html>`__ ("+"), `SubExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$SubExpr.html>`__ ("-"), `MulExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$MulExpr.html>`__ ("*"), `DivExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$DivExpr.html>`__ ("/"), `ModExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ModExpr.html>`__ ("%"), `ExpExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ExpExpr.html>`__ ("**"): arithmetic operators.
      -  `BitOrExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$BitOrExpr.html>`__ ("|"), `XOrExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$XOrExpr.html>`__ ("^"), `BitAndExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$BitAndExpr.html>`__ ("&"): bitwise operators.
      -  `InExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$InExpr.html>`__: an ``in`` test.
      -  `InstanceofExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$InstanceofExpr.html>`__: an ``instanceof`` test.
      -  `LogAndExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$LogAndExpr.html>`__ ("&&"), `LogOrExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$LogOrExpr.html>`__ ("||"): short-circuiting logical operators.

   -  `Assignment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Assignment.html>`__: assignment expressions, either simple or compound; use ``Assignment.getLhs()`` and ``Assignment.getRhs()`` to access the left- and right-hand side, respectively.

      -  `AssignExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignExpr.html>`__: a simple assignment expression.
      -  `CompoundAssignExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$CompoundAssignExpr.html>`__: a compound assignment expression.

         -  `AssignAddExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignAddExpr.html>`__, `AssignSubExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignSubExpr.html>`__, `AssignMulExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignMulExpr.html>`__, `AssignDivExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignDivExpr.html>`__, `AssignModExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignModExpr.html>`__, `AssignLShiftExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignLShiftExpr.html>`__, `AssignRShiftExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignRShiftExpr.html>`__,
            `AssignURShiftExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignURShiftExpr.html>`__, `AssignOrExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignOrExpr.html>`__, `AssignXOrExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignXOrExpr.html>`__, `AssignAndExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignAndExpr.html>`__, `AssignExpExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AssignExpExpr.html>`__: different kinds of compound assignment expressions.

   -  `UpdateExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$UpdateExpr.html>`__: an increment or decrement expression; use ``UpdateExpr.getOperand()`` to obtain the operand expression.

      -  `PreIncExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PreIncExpr.html>`__, `PostIncExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PostIncExpr.html>`__: an increment expression.
      -  `PreDecExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PreDecExpr.html>`__, `PostDecExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PostDecExpr.html>`__: a decrement expression.

   -  `YieldExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$YieldExpr.html>`__: a "yield" expression; use ``YieldExpr.getOperand()`` to access the (optional) operand expression; use ``YieldExpr.isDelegating()`` to check whether this is a delegating ``yield*``.
   -  `TemplateLiteral <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Templates.qll/type.Templates$TemplateLiteral.html>`__: an ECMAScript 2015 template literal; ``TemplateLiteral.getElement(i)`` returns the ``i``\ th element of the template, which may either be an interpolated expression or a constant template element.
   -  `TaggedTemplateExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Templates.qll/type.Templates$TaggedTemplateExpr.html>`__: an ECMAScript 2015 tagged template literal; use ``TaggedTemplateExpr.getTag()`` to access the tagging expression, and ``TaggedTemplateExpr.getTemplate()`` to access the template literal being tagged.
   -  `TemplateElement <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Templates.qll/type.Templates$TemplateElement.html>`__: a constant template element; as for literals, use ``TemplateElement.getValue()`` to obtain the value of the element, and ``TemplateElement.getRawValue()`` for its raw value
   -  `AwaitExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$AwaitExpr.html>`__: an "await" expression; use ``AwaitExpr.getOperand()`` to access the operand expression.

`Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__ and `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__ share a common superclass `ExprOrStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$ExprOrStmt.html>`__ which is useful for queries that should operate either on statements or on expressions, but not on any other AST nodes.

As an example of how to use expression AST nodes, here is a query that finds expressions of the form ``e + f >> g``; such expressions should be rewritten as ``(e + f) >> g`` to clarify operator precedence:

.. code-block:: ql

   import javascript

   from ShiftExpr shift, AddExpr add
   where add = shift.getAnOperand()
   select add, "This expression should be bracketed to clarify precedence rules."

Functions
^^^^^^^^^

JavaScript provides several ways of defining functions: in ECMAScript 5, there are function declaration statements and function expressions, and ECMAScript 2015 adds arrow function expressions. These different syntactic forms are represented by the classes `FunctionDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$FunctionDeclStmt.html>`__ (a subclass of `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__), `FunctionExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$FunctionExpr.html>`__ (a subclass of `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__) and `ArrowFunctionExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ArrowFunctionExpr.html>`__ (also a subclass of
`Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__), respectively. All three are subclasses of `Function <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Functions.qll/type.Functions$Function.html>`__, which provides common member predicates for accessing function parameters or the function body:

-  ``Function.getId()`` returns the `Identifier <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Identifier.html>`__ naming the function, which may not be defined for function expressions.
-  ``Function.getParameter(i)`` and ``Function.getAParameter()`` access the ``i``\ th parameter or any parameter, respectively; parameters are modeled by the class `Parameter <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Parameter.html>`__, which is a subclass of `BindingPattern <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$BindingPattern.html>`__ (see below).
-  ``Function.getBody()`` returns the body of the function, which is usually a `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__, but may be an `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__ for arrow function expressions and legacy `expression closures <https://developer.mozilla.org/en-US/docs/Archive/Web/JavaScript/Expression_closures>`__.

As an example, here is a query that finds all expression closures:

.. code-block:: ql

   import javascript

   from FunctionExpr fe
   where fe.getBody() instanceof Expr
   select fe, "Use arrow expressions instead of expression closures."

As another example, this query finds functions that have two parameters that bind the same variable:

.. code-block:: ql

   import javascript

   from Function fun, Parameter p, Parameter q, int i, int j
   where p = fun.getParameter(i) and
       q = fun.getParameter(j) and
       i < j and
       p.getAVariable() = q.getAVariable()
   select fun, "This function has two parameters that bind the same variable."

Classes
^^^^^^^

Classes can be defined either by class declaration statements, represented by the CodeQL class `ClassDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ClassDeclStmt.html>`__ (which is a subclass of `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__), or by class expressions, represented by the CodeQL class `ClassExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ClassExpr.html>`__ (which is a subclass of `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__). Both of these classes are also subclasses of `ClassDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ClassDefinition.html>`__, which provides common member predicates for accessing the name of a class, its superclass, and its body:

-  ``ClassDefinition.getIdentifier()`` returns the `Identifier <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Identifier.html>`__ naming the function, which may not be defined for class expressions.
-  ``ClassDefinition.getSuperClass()`` returns the `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__ specifying the superclass, which may not be defined.
-  ``ClassDefinition.getMember(n)`` returns the definition of member ``n`` of this class.
-  ``ClassDefinition.getMethod(n)`` restricts ``ClassDefinition.getMember(n)`` to methods (as opposed to fields).
-  ``ClassDefinition.getField(n)`` restricts ``ClassDefinition.getMember(n)`` to fields (as opposed to methods).
-  ``ClassDefinition.getConstructor()`` gets the constructor of this class, possibly a synthetic default constructor.

Note that class fields are not a standard language feature yet, so details of their representation may change.

Method definitions are represented by the class `MethodDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$MethodDefinition.html>`__, which (like its counterpart `FieldDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$FieldDefinition.html>`__ for fields) is a subclass of `MemberDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$MemberDefinition.html>`__. That class provides the following important member predicates:

-  ``MemberDefinition.isStatic()``: holds if this is a static member.
-  ``MemberDefinition.isComputed()``: holds if the name of this member is computed at runtime.
-  ``MemberDefinition.getName()``: gets the name of this member if it can be determined statically.
-  ``MemberDefinition.getInit()``: gets the initializer of this field; for methods, the initializer is a function expressions, for fields it may be an arbitrary expression, and may be undefined.

There are three classes for modeling special methods: `ConstructorDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ConstructorDefinition.html>`__ models constructors, while `GetterMethodDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$GetterMethodDefinition.html>`__ and `SetterMethodDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$SetterMethodDefinition.html>`__ model getter and setter methods, respectively.

Declarations and binding patterns
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Variables are declared by declaration statements (class `DeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$DeclStmt.html>`__), which come in three flavors: ``var`` statements (represented by class `VarDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$VarDeclStmt.html>`__), ``const`` statements (represented by class `ConstDeclStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$ConstDeclStmt.html>`__), and ``let`` statements (represented by class `LetStmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$LetStmt.html>`__). Every declaration statement has one or more declarators, represented by class `VariableDeclarator <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VariableDeclarator.html>`__.

Each declarator consists of a binding pattern, returned by predicate ``VariableDeclarator.getBindingPattern()``, and an optional initializing expression, returned by ``VariableDeclarator.getInit()``.

Often, the binding pattern is a simple identifier, as in ``var x = 42``. In ECMAScript 2015 and later, however, it can also be a more complex destructuring pattern, as in ``var [x, y] = arr``.

The various kinds of binding patterns are represented by class `BindingPattern <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$BindingPattern.html>`__ and its subclasses:

-  `VarRef <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarRef.html>`__: a simple identifier in an l-value position, for example the ``x`` in ``var x`` or in ``x = 42``
-  `Parameter <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Parameter.html>`__: a function or catch clause parameter
-  `ArrayPattern <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$ArrayPattern.html>`__: an array pattern, for example, the left-hand side of ``[x, y] = arr``
-  `ObjectPattern <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$ObjectPattern.html>`__: an object pattern, for example, the left-hand side of ``{x, y: z} = o``

Here is an example of a query to find declaration statements that declare the same variable more than once, excluding results in minified code:

.. code-block:: ql

   import javascript

   from DeclStmt ds, VariableDeclarator d1, VariableDeclarator d2, Variable v, int i, int j
   where d1 = ds.getDecl(i) and
       d2 = ds.getDecl(j) and
       i < j and
       v = d1.getBindingPattern().getAVariable() and
       v = d2.getBindingPattern().getAVariable() and
       not ds.getTopLevel().isMinified()
   select ds, "Variable " + v.getName() + " is declared both $@ and $@.", d1, "here", d2, "here"

This is not a common problem, so you may not find any results in your own projects.

   Notice the use of ``not ... isMinified()`` here and in the next few queries. This excludes any results found in minified code. If you delete ``and not ds.getTopLevel().isMinified()`` and re-run the query, two results in minified code in the *meteor/meteor* project are reported.

Properties
^^^^^^^^^^

Properties in object literals are represented by class `Property <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Property.html>`__, which is also a subclass of `ASTNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$ASTNode.html>`__, but neither of `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__ nor of `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__.

Class `Property <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Property.html>`__ has two subclasses `ValueProperty <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$ValueProperty.html>`__ and `PropertyAccessor <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PropertyAccessor.html>`__, which represent, respectively, normal value properties and getter/setter properties. Class `PropertyAccessor <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PropertyAccessor.html>`__, in turn, has two subclasses `PropertyGetter <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PropertyGetter.html>`__ and `PropertySetter <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PropertySetter.html>`__ representing getters and setters, respectively.

The predicates ``Property.getName()`` and ``Property.getInit()`` provide access to the defined property's name and its initial value. For `PropertyAccessor <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$PropertyAccessor.html>`__ and its subclasses, ``getInit()`` is overloaded to return the getter/setter function.

As an example of a query involving properties, consider the following query that flags object expressions containing two identically named properties, excluding results in minified code:

.. code-block:: ql

   import javascript

   from ObjectExpr oe, Property p1, Property p2, int i, int j
   where p1 = oe.getProperty(i) and
       p2 = oe.getProperty(j) and
       i < j and
       p1.getName() = p2.getName() and
       not oe.getTopLevel().isMinified()
   select oe, "Property " + p1.getName() + " is defined both $@ and $@.", p1, "here", p2, "here"

Modules
^^^^^^^

The JavaScript library has support for working with ECMAScript 2015 modules, as well as legacy CommonJS modules (still commonly employed by Node.js code bases) and AMD-style modules. The classes `ES2015Module <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/ES2015Modules.qll/type.ES2015Modules$ES2015Module.html>`__, `NodeModule <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NodeJS.qll/type.NodeJS$NodeModule.html>`__, and `AMDModule <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AMD.qll/type.AMD$AmdModule.html>`__ represent these three types of modules, and all three extend the common superclass `Module <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Modules.qll/type.Modules$Module.html>`__.

The most important member predicates defined by `Module <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Modules.qll/type.Modules$Module.html>`__ are:

-  ``Module.getName()``: gets the name of the module, which is just the stem (that is, the basename without extension) of the enclosing file.
-  ``Module.getAnImportedModule()``: gets another module that is imported (through ``import`` or ``require``) by this module.
-  ``Module.getAnExportedSymbol()``: gets the name of a symbol that this module exports.

Moreover, there is a class `Import <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Modules.qll/type.Modules$Import.html>`__ that models both ECMAScript 2015-style ``import`` declarations and CommonJS/AMD-style ``require`` calls; its member predicate ``Import.getImportedModule`` provides access to the module the import refers to, if it can be determined statically.

Name binding
~~~~~~~~~~~~

Name binding is modeled in the JavaScript libraries using four concepts: *scopes*, *variables*, *variable declarations*, and *variable accesses*, represented by the classes `Scope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Scope.html>`__, `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__, `VarDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarDecl.html>`__ and `VarAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarAccess.html>`__, respectively.

Scopes
^^^^^^

In ECMAScript 5, there are three kinds of scopes: the global scope (one per program), function scopes (one per function), and catch clause scopes (one per ``catch`` clause). These three kinds of scopes are represented by the classes `GlobalScope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$GlobalScope.html>`__, `FunctionScope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$FunctionScope.html>`__ and `CatchScope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$CatchScope.html>`__. ECMAScript 2015 adds block scopes for ``let``-bound variables, which are also represented by class `Scope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Scope.html>`__, class expression scopes (`ClassExprScope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Classes.qll/type.Classes$ClassExprScope.html>`__),
and module scopes (`ModuleScope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$ModuleScope.html>`__).

Class `Scope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Scope.html>`__ provides the following API:

-  ``Scope.getScopeElement()`` returns the AST node inducing this scope; undefined for `GlobalScope <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$GlobalScope.html>`__.
-  ``Scope.getOuterScope()`` returns the lexically enclosing scope of this scope.
-  ``Scope.getAnInnerScope()`` returns a scope lexically nested inside this scope.
-  ``Scope.getVariable(name)``, ``Scope.getAVariable()`` return a variable declared (implicitly or explicitly) in this scope.

Variables
^^^^^^^^^

The `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__ class models all variables in a JavaScript program, including global variables, local variables, and parameters (both of functions and ``catch`` clauses), whether explicitly declared or not.

It is important not to confuse variables and their declarations: local variables may have more than one declaration, while global variables and the implicitly declared local ``arguments`` variable need not have a declaration at all.

Variable declarations and accesses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Variables may be declared by variable declarators, by function declaration statements and expressions, by class declaration statements or expressions, or by parameters of functions and ``catch`` clauses. While these declarations differ in their syntactic form, in each case there is an identifier naming the declared variable. We consider that identifier to be the declaration proper, and assign it the class `VarDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarDecl.html>`__. Identifiers that reference a variable, on the other hand, are given the class `VarAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarAccess.html>`__.

The most important predicates involving variables, their declarations, and their accesses are as follows:

-  ``Variable.getName()``, ``VarDecl.getName()``, ``VarAccess.getName()`` return the name of the variable.
-  ``Variable.getScope()`` returns the scope to which the variable belongs.
-  ``Variable.isGlobal()``, ``Variable.isLocal()``, ``Variable.isParameter()`` determine whether the variable is a global variable, a local variable, or a parameter variable, respectively.
-  ``Variable.getAnAccess()`` maps a `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__ to all `VarAccess <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarAccess.html>`__\ es that refer to it.
-  ``Variable.getADeclaration()`` maps a `Variable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$Variable.html>`__ to all `VarDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Variables.qll/type.Variables$VarDecl.html>`__\ s that declare it (of which there may be none, one, or more than one).
-  ``Variable.isCaptured()`` determines whether the variable is ever accessed in a scope that is lexically nested within the scope where it is declared.

As an example, consider the following query which finds distinct function declarations that declare the same variable, that is, two conflicting function declarations within the same scope (again excluding minified code):

.. code-block:: ql

   import javascript

   from FunctionDeclStmt f, FunctionDeclStmt g
   where f != g and f.getVariable() = g.getVariable() and
       not f.getTopLevel().isMinified() and
       not g.getTopLevel().isMinified()
   select f, g

Some projects declare conflicting functions of the same name and rely on platform-specific behavior to disambiguate the two declarations.

Control flow
~~~~~~~~~~~~

A different program representation in terms of intraprocedural control flow graphs (CFGs) is provided by the classes in library `CFG.qll <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/module.CFG.html>`__.

Class `ControlFlowNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowNode.html>`__ represents a single node in the control flow graph, which is either an expression, a statement, or a synthetic control flow node. Note that `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__ and `Stmt <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Stmt.qll/type.Stmt$Stmt.html>`__ do not inherit from `ControlFlowNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowNode.html>`__ at the CodeQL level, although their entity types are compatible, so you can explicitly cast from one to the other if you need to map between the AST-based and the CFG-based program representations.

There are two kinds of synthetic control flow nodes: entry nodes (class `ControlFlowEntryNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowEntryNode.html>`__), which represent the beginning of a top-level or function, and exit nodes (class `ControlFlowExitNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowExitNode.html>`__), which represent their end. They do not correspond to any AST nodes, but simply serve as the unique entry point and exit point of a control flow graph. Entry and exit nodes can be accessed through the predicates ``StmtContainer.getEntry()`` and ``StmtContainer.getExit()``.

Most, but not all, top-levels and functions have another distinguished CFG node, the *start node*. This is the CFG node at which execution begins. Unlike the entry node, which is a synthetic construct, the start node corresponds to an actual program element: for top-levels, it is the first CFG node of the first statement; for functions, it is the CFG node corresponding to their first parameter or, if there are no parameters, the first CFG node of the body. Empty top-levels do not have a start node.

For most purposes, using start nodes is preferable to using entry nodes.

The structure of the control flow graph is reflected in the member predicates of `ControlFlowNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowNode.html>`__:

-  ``ControlFlowNode.getASuccessor()`` returns a `ControlFlowNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowNode.html>`__ that is a successor of this `ControlFlowNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowNode.html>`__ in the control flow graph.
-  ``ControlFlowNode.getAPredecessor()`` is the inverse of ``getASuccessor()``.
-  ``ControlFlowNode.isBranch()`` determines whether this node has more than one successor.
-  ``ControlFlowNode.isJoin()`` determines whether this node has more than one predecessor.
-  ``ControlFlowNode.isStart()`` determines whether this node is a start node.

Many control-flow-based analyses are phrased in terms of `basic blocks <https://en.wikipedia.org/wiki/Basic_block>`__ rather than single control flow nodes, where a basic block is a maximal sequence of control flow nodes without branches or joins. The class `BasicBlock <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/BasicBlocks.qll/type.BasicBlocks$BasicBlock.html>`__ from `BasicBlocks.qll <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/BasicBlocks.qll/module.BasicBlocks.html>`__ represents all such basic blocks. Similar to `ControlFlowNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/CFG.qll/type.CFG$ControlFlowNode.html>`__, it provides member predicates ``getASuccessor()`` and ``getAPredecessor()`` to navigate the control flow graph at the level of basic blocks, and member predicates ``getANode()``, ``getNode(int)``, ``getFirstNode()`` and ``getLastNode()`` to access individual control flow nodes within a basic block. The predicate
``Function.getEntryBB()`` returns the entry basic block in a function, that is, the basic block containing the function's entry node. Similarly, ``Function.getStartBB()`` provides access to the start basic block, which contains the function's start node. As for CFG nodes, ``getStartBB()`` should normally be preferred over ``getEntryBB()``.

As an example of an analysis using basic blocks, ``BasicBlock.isLiveAtEntry(v, u)`` determines whether variable ``v`` is `live <https://en.wikipedia.org/wiki/Live_variable_analysis>`__ at the entry of the given basic block, and if so binds ``u`` to a use of ``v`` that refers to its value at the entry. We can use it to find global variables that are used in a function where they are not live (that is, every read of the variable is preceded by a write), suggesting that the variable was meant to be declared as a local variable instead:

.. code-block:: ql

   import javascript

   from Function f, GlobalVariable gv
   where gv.getAnAccess().getEnclosingFunction() = f and
       not f.getStartBB().isLiveAtEntry(gv, _)
   select f, "This function uses " + gv + " like a local variable."

Many projects have some variables which look as if they were intended to be local.

Data flow
~~~~~~~~~

Definitions and uses
^^^^^^^^^^^^^^^^^^^^

Library `DefUse.qll <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/DefUse.qll/module.DefUse.html>`__ provides classes and predicates to determine `def-use <https://en.wikipedia.org/wiki/Use-define_chain>`__ relationships between definitions and uses of variables.

Classes `VarDef <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/DefUse.qll/type.DefUse$VarDef.html>`__ and `VarUse <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/DefUse.qll/type.DefUse$VarUse.html>`__ contain all expressions that define and use a variable, respectively. For the former, you can use predicate ``VarDef.getAVariable()`` to find out which variables are defined by a given variable definition (recall that destructuring assignments in ECMAScript 2015 define several variables at the same time). Similarly, predicate ``VarUse.getVariable()`` returns the (single) variable being accessed by a variable use.

The def-use information itself is provided by predicate ``VarUse.getADef()``, that connects a use of a variable to a definition of the same variable, where the definition may reach the use.

As an example, the following query finds definitions of local variables that are not used anywhere; that is, the variable is either not referenced at all after the definition, or its value is overwritten:

.. code-block:: ql

   import javascript

   from VarDef def, LocalVariable v
   where v = def.getAVariable() and
       not exists (VarUse use | def = use.getADef())
   select def, "Dead store of local variable."

SSA
^^^

A more fine-grained representation of a program's data flow based on `Static Simple Assignment Form (SSA) <https://en.wikipedia.org/wiki/Static_single_assignment_form>`__ is provided by the library ``semmle.javascript.SSA``.

In SSA form, each use of a local variable has exactly one (SSA) definition that reaches it. SSA definitions are represented by class `SsaDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/SSA.qll/type.SSA$SsaDefinition.html>`__. They are not AST nodes, since not every SSA definition corresponds to an explicit element in the source code.

Altogether, there are five kinds of SSA definitions:

#. Explicit definitions (`SsaExplicitDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/SSA.qll/type.SSA$SsaExplicitDefinition.html>`__): these simply wrap a `VarDef <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/DefUse.qll/type.DefUse$VarDef.html>`__, that is, a definition like ``x = 1`` appearing explicitly in the source code.
#. Implicit initializations (`SsaImplicitInit <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/SSA.qll/type.SSA$SsaImplicitInit.html>`__): these represent the implicit initialization of local variables with ``undefined`` at the beginning of their scope.
#. Phi nodes (`SsaPhiNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/SSA.qll/type.SSA$SsaPhiNode.html>`__): these are pseudo-definitions that merge two or more SSA definitions where necessary; see the Wikipedia page linked to above for an explanation.
#. Variable captures (`SsaVariableCapture <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/SSA.qll/type.SSA$SsaVariableCapture.html>`__): these are pseudo-definitions appearing at places in the code where the value of a captured variable may change without there being an explicit assignment, for example due to a function call.
#. Refinement nodes (`SsaRefinementNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/SSA.qll/type.SSA$SsaRefinementNode.html>`__): these are pseudo-definitions appearing at places in the code where something becomes known about a variable; for example, a conditional ``if (x === null)`` induces a refinement node at the beginning of its "then" branch recording the fact that ``x`` is known to be ``null`` there. (In the literature, these are sometimes known as "pi nodes.")

Data flow nodes
^^^^^^^^^^^^^^^

Moving beyond just variable definitions and uses, library ``semmle.javascript.dataflow.DataFlow`` provides a representation of the program as a data flow graph. Its nodes are values of class `DataFlow::Node <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/DataFlow.qll/type.DataFlow$DataFlow$Node.html>`__, which has two subclasses ``ValueNode`` and ``SsaDefinitionNode``. Nodes of the former kind wrap an expression or a statement that is considered to produce a value (specifically, a function or class declaration statement, or a TypeScript namespace or enum declaration). Nodes of the latter kind wrap SSA definitions.

You can use the predicate ``DataFlow::valueNode`` to convert an expression, function or class into its corresponding ``ValueNode``, and similarly ``DataFlow::ssaDefinitionNode`` to map an SSA definition to its corresponding ``SsaDefinitionNode``.

There is also an auxiliary predicate ``DataFlow::parameterNode`` that maps a parameter to its corresponding data flow node. (This is really just a convenience wrapper around ``DataFlow::ssaDefinitionNode``, since parameters are also considered to be SSA definitions.)

Going in the other direction, there is a predicate ``ValueNode.getAstNode()`` for mapping from ``ValueNode``\ s to ``ASTNode``\ s, and ``SsaDefinitionNode.getSsaVariable()`` for mapping from ``SsaDefinitionNode``\ s to ``SsaVariable``\ s. There is also a utility predicate ``Node.asExpr()`` that gets the underlying expression for a ``ValueNode``, and is undefined for all nodes that do not correspond to an expression. (Note in particular that this predicate is not defined for ``ValueNode``\ s wrapping function or class declaration statements!)

You can use the predicate ``DataFlow::Node.getAPredecessor()`` to find other data flow nodes from which values may flow into this node, and ``getASuccessor`` for the other direction.

For example, here is a query that finds all invocations of a method called ``send`` on a value that comes from a parameter named ``res``, indicating that it is perhaps sending an HTTP response:

.. code-block:: ql

   import javascript

   from SimpleParameter res, DataFlow::Node resNode, MethodCallExpr send
   where res.getName() = "res" and
         resNode = DataFlow::parameterNode(res) and
         resNode.getASuccessor+() = DataFlow::valueNode(send.getReceiver()) and
         send.getMethodName() = "send"
   select send

Note that the data flow modeling in this library is intraprocedural, that is, flow across function calls and returns is *not* modeled. Likewise, flow through object properties and global variables is not modeled.

Type inference
~~~~~~~~~~~~~~

The library ``semmle.javascript.dataflow.TypeInference`` implements a simple type inference for JavaScript based on intraprocedural, heap-insensitive flow analysis. Basically, the inference algorithm approximates the possible concrete runtime values of variables and expressions as sets of abstract values (represented by the class `AbstractValue <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/AbstractValues.qll/type.AbstractValues$AbstractValue.html>`__), each of which stands for a set of concrete values.

For example, there is an abstract value representing all non-zero numbers, and another representing all non-empty strings except for those that can be converted to a number. Both of these abstract values are fairly coarse approximations that represent very large sets of concrete values.

Other abstract values are more precise, to the point where they represent single concrete values: for example, there is an abstract value representing the concrete ``null`` value, and another representing the number zero.

There is a special group of abstract values called *indefinite* abstract values that represent all concrete values. The analysis uses these to handle expressions for which it cannot infer a more precise value, such as function parameters (as mentioned above, the analysis is intraprocedural and hence does not model argument passing) or property reads (the analysis does not model property values either).

Each indefinite abstract value is associated with a string value describing the cause of imprecision. In the above examples, the indefinite value for the parameter would have cause ``"call"``, while the indefinite value for the property would have cause ``"heap"``.

To check whether an abstract value is indefinite, you can use the ``isIndefinite`` member predicate. Its single argument describes the cause of imprecision.

Each abstract value has one or more associated types (CodeQL class `InferredType <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/InferredTypes.qll/type.InferredTypes$InferredType.html>`__ corresponding roughly to the type tags computed by the ``typeof`` operator. The types are ``null``, ``undefined``, ``boolean``, ``number``, ``string``, ``function``, ``class``, ``date`` and ``object``.

To access the results of the type inference, use class `DataFlow::AnalyzedNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/TypeInference.qll/type.TypeInference$AnalyzedNode.html>`__: any `DataFlow::Node <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/DataFlow.qll/type.DataFlow$DataFlow$Node.html>`__ can be cast to this class, and additionally there is a convenience predicate ``Expr::analyze`` that maps expressions directly to their corresponding ``AnalyzedNode``\ s.

Once you have an ``AnalyzedNode``, you can use predicate ``AnalyzedNode.getAValue()`` to access the abstract values inferred for it, and ``getAType()`` to get the inferred types.

For example, here is a query that looks for ``null`` checks on expressions that cannot, in fact, be null:

.. code-block:: ql

   import javascript

   from StrictEqualityTest eq, DataFlow::AnalyzedNode nd, NullLiteral null
   where eq.hasOperands(nd.asExpr(), null) and
         not nd.getAValue().isIndefinite(_) and
         not nd.getAValue() instanceof AbstractNull
   select eq, "Spurious null check."

To paraphrase, the query looks for equality tests ``eq`` where one operand is a ``null`` literal and the other some expression that we convert to an ``AnalyzedNode``. If the type inference results for that node are precise (that is, none of the inferred values is indefinite) and (the abstract representation of) ``null`` is not among them, we flag ``eq``.

You can add custom type inference rules by defining new subclasses of ``DataFlow::AnalyzedNode`` and overriding ``getAValue``. You can also introduce new abstract values by extending the abstract class ``CustomAbstractValueTag``, which is a subclass of ``string``: each string belonging to that class induces a corresponding abstract value of type ``CustomAbstractValue``. You can use the predicate ``CustomAbstractValue.getTag()`` to map from the abstract value to its tag. By implementing the abstract predicates of class ``CustomAbstractValueTag`` you can define the semantics of your custom abstract values, such as what primitive value they coerce to and what type they have.

Call graph
~~~~~~~~~~

The JavaScript library implements a simple `call graph <https://en.wikipedia.org/wiki/Call_graph>`__ construction algorithm to statically approximate the possible call targets of function calls and ``new`` expressions. Due to the dynamically typed nature of JavaScript and its support for higher-order functions and reflective language features, building static call graphs is quite difficult. Simple call graph algorithms tend to be incomplete, that is, they often fail to resolve all possible call targets. More sophisticated algorithms can suffer from the opposite problem of imprecision, that is, they may infer many spurious call targets.

The call graph is represented by the member predicate ``getACallee()`` of class `DataFlow::InvokeNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/Nodes.qll/type.Nodes$InvokeNode.html>`__, which computes possible callees of the given invocation, that is, functions that may at runtime be invoked by this expression.

Furthermore, there are three member predicates that indicate the quality of the callee information for this invocation:

-  ``DataFlow::InvokeNode.isImprecise()``: holds for invocations where the call graph builder might infer spurious call targets.
-  ``DataFlow::InvokeNode.isIncomplete()``: holds for invocations where the call graph builder might fail to infer possible call targets.
-  ``DataFlow::InvokeNode.isUncertain()``: holds if either ``isImprecise()`` or ``isIncomplete()`` holds.

As an example of a call-graph-based query, here is a query to find invocations for which the call graph builder could not find any callees, despite the analysis being complete for this invocation:

.. code-block:: ql

   import javascript

   from DataFlow::InvokeNode invk
   where not invk.isIncomplete() and
         not exists(invk.getACallee())
   select invk, "Unable to find a callee for this invocation."

Inter-procedural data flow
~~~~~~~~~~~~~~~~~~~~~~~~~~

The data flow graph-based analyses described so far are all intraprocedural: they do not take flow from function arguments to parameters or from a ``return`` to the function's caller into account. The data flow library also provides a framework for constructing custom inter-procedural analyses.

We distinguish here between data flow proper, and *taint tracking*: the latter not only considers value-preserving flow (such as from variable definitions to uses), but also cases where one value influences ("taints") another without determining it entirely. For example, in the assignment ``s2 = s1.substring(i)``, the value of ``s1`` influences the value of ``s2``, because ``s2`` is assigned a substring of ``s1``. In general, ``s2`` will not be assigned ``s1`` itself, so there is no data flow from ``s1`` to ``s2``, but ``s1`` still taints ``s2``.

It is a common pattern that we wish to specify data flow or taint analysis in terms of its *sources* (where flow starts), *sinks* (where it should be tracked), and *barriers* (also called *sanitizers*) where flow is interrupted. Sanitizers they are very common in security analyses: for example, an analysis that tracks the flow of untrusted user input into, say, a SQL query has to keep track of code that validates the input, thereby making it safe to use. Such a validation step is an example of a sanitizer.

A module implementing the signature `DataFlow::ConfigSig` may specify a data flow or taint analysis by implementing the following predicates:

-  ``isSource(DataFlow::Node nd)`` selects all nodes ``nd`` from where flow tracking starts.
-  ``isSink(DataFlow::Node nd)`` selects all nodes ``nd`` to which the flow is tracked.
-  ``isBarrier(DataFlow::Node nd)`` selects all nodes ``nd`` that act as a barrier/sanitizer for data flow.
-  ``isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg)`` allows specifying custom additional flow steps for this analysis.

Such a module can be passed to ``DataFlow::Global<...>``. This will produce a module with a ``flow`` predicate that performs the actual flow tracking, starting at a source and looking for flow to a sink that does not pass through a barrier node.

For example, suppose that we are developing an analysis to find hard-coded passwords. We might write a simple query that looks for string constants flowing into variables named ``"password"``.

.. code-block:: ql

   import javascript

   module PasswordConfig implements DataFlow::ConfigSig {
       predicate isSource(DataFlow::Node nd) { nd.asExpr() instanceof StringLiteral }

       predicate isSink(DataFlow::Node nd) { passwordVarAssign(_, nd) }
   }

   predicate passwordVarAssign(Variable v, DataFlow::Node nd) {
       v.getAnAssignedExpr() = nd.asExpr() and
       v.getName().toLowerCase() = "password"
   }

   module PasswordFlow = DataFlow::Global<PasswordConfig>;

Now we can rephrase our query to use ``PasswordFlow::flow``:

.. code-block:: ql

   from DataFlow::Node source, DataFlow::Node sink, Variable v
   where PasswordFlow::flow(_, sink) and passwordVarAssign(v, sink)
   select sink, "Password variable " + v + " is assigned a constant string."

Syntax errors
~~~~~~~~~~~~~

JavaScript code that contains syntax errors cannot usually be analyzed. For such code, the lexical and syntactic representations are not available, and hence no name binding information, call graph or control and data flow. All that is available in this case is a value of class `JSParseError <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Errors.qll/type.Errors$JSParseError.html>`__ representing the syntax error. It provides information about the syntax error location (`JSParseError <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Errors.qll/type.Errors$JSParseError.html>`__ is a subclass of `Locatable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Locations.qll/type.Locations$Locatable.html>`__) and the error message through predicate ``JSParseError.getMessage``.

Note that for some very simple syntax errors the parser can recover and continue parsing. If this happens, lexical and syntactic information is available in addition to the `JSParseError <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Errors.qll/type.Errors$JSParseError.html>`__ values representing the (recoverable) syntax errors encountered during parsing.

Frameworks
~~~~~~~~~~

AngularJS
^^^^^^^^^

The ``semmle.javascript.frameworks.AngularJS`` library provides support for working with `AngularJS (Angular 1.x) <https://angularjs.org/>`__ code. Its most important classes are:

-  `AngularJS::AngularModule <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/frameworks/AngularJS/AngularJSCore.qll/type.AngularJSCore$AngularModule.html>`__: an Angular module
-  `AngularJS::DirectiveDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/frameworks/AngularJS/ServiceDefinitions.qll/type.ServiceDefinitions$DirectiveDefinition.html>`__, `AngularJS::FactoryRecipeDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/frameworks/AngularJS/ServiceDefinitions.qll/type.ServiceDefinitions$FactoryRecipeDefinition.html>`__, `AngularJS::FilterDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/frameworks/AngularJS/ServiceDefinitions.qll/type.ServiceDefinitions$FilterDefinition.html>`__, `AngularJS::ControllerDefinition <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/frameworks/AngularJS/ServiceDefinitions.qll/type.ServiceDefinitions$ControllerDefinition.html>`__: a definition of a directive, service, filter or controller, respectively
-  `AngularJS::InjectableFunction <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/frameworks/AngularJS/DependencyInjections.qll/type.DependencyInjections$InjectableFunction.html>`__: a function that is subject to dependency injection

HTTP framework libraries
^^^^^^^^^^^^^^^^^^^^^^^^

The library ``semmle.javacript.frameworks.HTTP`` provides classes modeling common concepts from various HTTP frameworks.

Currently supported frameworks are `Express <https://expressjs.com/>`__, the standard Node.js ``http`` and ``https`` modules, `Connect <https://github.com/senchalabs/connect>`__, `Koa <https://koajs.com>`__, `Hapi <https://hapi.dev/>`__ and `Restify <http://restify.com/>`__.

The most important classes include (all in module ``HTTP``):

-  ``ServerDefinition``: an expression that creates a new HTTP server.
-  ``RouteHandler``: a callback for handling an HTTP request.
-  ``RequestExpr``: an expression that may contain an HTTP request object.
-  ``ResponseExpr``: an expression that may contain an HTTP response object.
-  ``HeaderDefinition``: an expression that sets one or more HTTP response headers.
-  ``CookieDefinition``: an expression that sets a cookie in an HTTP response.
-  ``RequestInputAccess``: an expression that accesses user-controlled request data.

For each framework library, there is a corresponding CodeQL library (for example ``semmle.javacript.frameworks.Express``) that instantiates the above classes for that framework and adds framework-specific classes.

Node.js
^^^^^^^

The ``semmle.javascript.NodeJS`` library provides support for working with `Node.js <http://nodejs.org/>`__ modules through the following classes:

-  `NodeModule <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NodeJS.qll/type.NodeJS$NodeModule.html>`__: a top-level that defines a Node.js module; see the section on `Modules <#modules>`__ for more information.
-  `Require <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NodeJS.qll/type.NodeJS$Require.html>`__: a call to the special ``require`` function that imports a module.

As an example of the use of these classes, here is a query that counts for every module how many other modules it imports:

.. code-block:: ql

   import javascript

   from NodeModule m
   select m, count(m.getAnImportedModule())

When you analyze a project, for each module you can see how many other modules it imports.

NPM
^^^

The ``semmle.javascript.NPM`` library provides support for working with `NPM <https://www.npmjs.com/>`__ packages through the following classes:

-  `PackageJSON <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NPM.qll/type.NPM$PackageJSON.html>`__: a ``package.json`` file describing an NPM package; various getter predicates are available for accessing detailed information about the package, which are described in the `online API documentation <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NPM.qll/module.NPM.html>`__.
-  `BugTrackerInfo <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NPM.qll/type.NPM$BugTrackerInfo.html>`__, `ContributorInfo <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NPM.qll/type.NPM$ContributorInfo.html>`__, `RepositoryInfo <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NPM.qll/type.NPM$RepositoryInfo.html>`__: these classes model parts of the ``package.json`` file providing information on bug tracking systems, contributors and repositories.
-  `PackageDependencies <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NPM.qll/type.NPM$PackageDependencies.html>`__: models the dependencies of an NPM package; the predicate ``PackageDependencies.getADependency(pkg, v)`` binds ``pkg`` to the name and ``v`` to the version of a package required by a ``package.json`` file.
-  `NPMPackage <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/NPM.qll/type.NPM$NPMPackage.html>`__: a subclass of `Folder <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Files.qll/type.Files$Folder.html>`__ that models an NPM package; important member predicates include:

   -  ``NPMPackage.getPackageName()`` returns the name of this package.
   -  ``NPMPackage.getPackageJSON()`` returns the ``package.json`` file for this package.
   -  ``NPMPackage.getNodeModulesFolder()`` returns the ``node_modules`` folder for this package.
   -  ``NPMPackage.getAModule()`` returns a Node.js module belonging to this package (not including modules in the ``node_modules`` folder).

As an example of the use of these classes, here is a query that identifies unused dependencies, that is, module dependencies that are listed in the ``package.json`` file, but which are not imported by any ``require`` call:

.. code-block:: ql

   import javascript

   from NPMPackage pkg, PackageDependencies deps, string name
   where deps = pkg.getPackageJSON().getDependencies() and
   deps.getADependency(name, _) and
   not exists (Require req | req.getTopLevel() = pkg.getAModule() | name = req.getImportedPath().getValue())
   select deps, "Unused dependency '" + name + "'."

React
^^^^^

The ``semmle.javascript.frameworks.React`` library provides support for working with `React <https://reactjs.org/>`__ code through the `ReactComponent <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/frameworks/React.qll/type.React$ReactComponent.html>`__ class, which models a React component defined either in the functional style or the class-based style (both ECMAScript 2015 classes and old-style ``React.createClass`` classes are supported).

Databases
^^^^^^^^^

The class ``SQL::SqlString`` represents an expression that is interpreted as a SQL command. Currently, we model SQL commands issued through the following npm packages:
`mysql <https://www.npmjs.com/package/mysql>`__, `pg <https://www.npmjs.com/package/pg>`__, `pg-pool <https://www.npmjs.com/package/pg-pool>`__, `sqlite3 <https://www.npmjs.com/package/sqlite3>`__, `mssql <https://www.npmjs.com/package/mssql>`__ and `sequelize <https://www.npmjs.com/package/sequelize>`__.

Similarly, the class ``NoSQL::Query`` represents an expression that is interpreted as a NoSQL query by the ``mongodb`` or ``mongoose`` package.

Finally, the class ``DatabaseAccess`` contains all data flow nodes that perform a database access using any of the packages above.

For example, here is a query to find SQL queries that use string concatenation (instead of a templating-based solution, which is usually safer):

.. code-block:: ql

   import javascript

   from SQL::SqlString ss
   where ss instanceof AddExpr
   select ss, "Use templating instead of string concatenation."

Miscellaneous
~~~~~~~~~~~~~

Externs
^^^^^^^

The ``semmle.javascript.Externs`` library provides support for working with `externs <https://developers.google.com/closure/compiler/docs/api-tutorial3>`__ through the following classes:

-  `ExternalDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalDecl.html>`__: common superclass modeling all different kinds of externs declarations; it defines two member predicates:

   -  ``ExternalDecl.getQualifiedName()`` returns the fully qualified name of the declared entity.
   -  ``ExternalDecl.getName()`` returns the unqualified name of the declared entity.

-  `ExternalTypedef <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalTypedef.html>`__: a subclass of `ExternalDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalDecl.html>`__ representing type declarations; unlike other externs declarations, such declarations do not declare a function or object that is present at runtime, but simply introduce an alias for a type.
-  `ExternalVarDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalVarDecl.html>`__: a subclass of `ExternalDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalDecl.html>`__ representing a variable or function declaration; it defines two member predicates:

   -  ``ExternalVarDecl.getInit()`` returns the initializer associated with this declaration, if any; this can either be a `Function <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Functions.qll/type.Functions$Function.html>`__ or an `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__.
   -  ``ExternalVarDecl.getDocumentation()`` returns the JSDoc comment associated with this declaration.

Variables and functions declared in an externs file are either globals (represented by class `ExternalGlobalDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalGlobalDecl.html>`__), or members (represented by class `ExternalMemberDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalMemberDecl.html>`__).

Members are further subdivided into static members (class `ExternalStaticMemberDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalStaticMemberDecl.html>`__) and instance members (class `ExternalInstanceMemberDecl <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/type.Externs$ExternalInstanceMemberDecl.html>`__).

For more details on these and other classes representing externs, see `the API documentation <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Externs.qll/module.Externs.html>`__.

HTML
^^^^

The ``semmle.javascript.HTML`` library provides support for working with HTML documents. They are represented as a tree of ``HTML::Element`` nodes, each of which may have zero or more attributes represented by class ``HTML::Attribute``.

Similar to the abstract syntax tree representation, ``HTML::Element`` has member predicates ``getChild(i)`` and ``getParent()`` to navigate from an element to its ``i``\ th child element and its parent element, respectively. Use predicate ``HTML::Element.getAttribute(i)`` to get the ``i``\ th attribute of the element, and ``HTML::Element.getAttributeByName(n)`` to get the attribute with name ``n``.

For ``HTML::Attribute``, predicates ``getName()`` and ``getValue()`` provide access to the attribute's name and value, respectively.

Both ``HTML::Element`` and ``HTML::Attribute`` have a predicate ``getRoot()`` that gets the root ``HTML::Element`` of the document to which they belong.

JSDoc
^^^^^

The ``semmle.javascript.JSDoc`` library provides support for working with `JSDoc comments <https://jsdoc.app/>`__. Documentation comments are parsed into an abstract syntax tree representation closely following the format employed by the `Doctrine <https://github.com/eslint/doctrine>`__ JSDoc parser.

A JSDoc comment as a whole is represented by an entity of class `JSDoc <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSDoc.qll/type.JSDoc$JSDoc.html>`__, while individual tags are represented by class `JSDocTag <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSDoc.qll/type.JSDoc$JSDocTag.html>`__. Important member predicates of these two classes include:

-  ``JSDoc.getDescription()`` returns the descriptive header of the JSDoc comment, if any.
-  ``JSDoc.getComment()`` maps the `JSDoc <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSDoc.qll/type.JSDoc$JSDoc.html>`__ entity to its underlying `Comment <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Comments.qll/type.Comments$Comment.html>`__ entity.
-  ``JSDocTag.getATag()`` returns a tag in this JSDoc comment.
-  ``JSDocTag.getTitle()`` returns the title of his tag; for instance, an ``@param`` tag has title ``"param"``.
-  ``JSDocTag.getName()`` returns the name of the parameter or variable documented by this tag.
-  ``JSDocTag.getType()`` returns the type of the parameter or variable documented by this tag.
-  ``JSDocTag.getDescription()`` returns the description associated with this tag.

Types in JSDoc comments are represented by the class `JSDocTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSDoc.qll/type.JSDoc$JSDocTypeExpr.html>`__ and its subclasses, which again represent type expressions as abstract syntax trees. Examples of type expressions are `JSDocAnyTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSDoc.qll/type.JSDoc$JSDocAnyTypeExpr.html>`__, representing the "any" type ``*``, or `JSDocNullTypeExpr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSDoc.qll/type.JSDoc$JSDocNullTypeExpr.html>`__, representing the null type.

As an example, here is a query that finds ``@param`` tags that do not specify the name of the documented parameter:

.. code-block:: ql

   import javascript

   from JSDocTag t
   where t.getTitle() = "param" and
   not exists(t.getName())
   select t, "@param tag is missing name."

For full details on these and other classes representing JSDoc comments and type expressions, see `the API documentation <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSDoc.qll/module.JSDoc.html>`__.

JSX
^^^

The ``semmle.javascript.JSX`` library provides support for working with `JSX code <https://reactjs.org/docs/jsx-in-depth.html>`__.

Similar to the representation of HTML documents, JSX fragments are modeled as a tree of `JSXElement <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSX.qll/type.JSX$JSXElement.html>`__\ s, each of which may have zero or more `JSXAttribute <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSX.qll/type.JSX$JSXAttribute.html>`__\ s.

However, unlike HTML, JSX is interleaved with JavaScript, hence `JSXElement <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSX.qll/type.JSX$JSXElement.html>`__ is a subclass of `Expr <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Expr.qll/type.Expr$Expr.html>`__. Like ``HTML::Element``, it has predicates ``getAttribute(i)`` and ``getAttributeByName(n)`` to look up attributes of a JSX element. Its body elements can be accessed by predicate ``getABodyElement()``; note that the results of this predicate are arbitrary expressions, which may either be further `JSXElement <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSX.qll/type.JSX$JSXElement.html>`__\ s, or other expressions that are interpolated into the body of the outer element.

`JSXAttribute <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSX.qll/type.JSX$JSXAttribute.html>`__, again not unlike ``HTML::Attribute``, has predicates ``getName()`` and ``getValue()`` to access the attribute name and value.

JSON
^^^^

The ``semmle.javascript.JSON`` library provides support for working with `JSON <http://json.org/>`__ files that were processed by the JavaScript extractor when building the CodeQL database.

JSON files are modeled as trees of JSON values. Each JSON value is represented by an entity of class `JSONValue <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONValue.html>`__, which provides the following member predicates:

-  ``JSONValue.getParent()`` returns the JSON object or array in which this value occurs.
-  ``JSONValue.getChild(i)`` returns the ``i``\ th child of this JSON object or array.

Note that `JSONValue <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONValue.html>`__ is a subclass of `Locatable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Locations.qll/type.Locations$Locatable.html>`__, so the usual member predicates of `Locatable <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Locations.qll/type.Locations$Locatable.html>`__ can be used to determine the file in which a JSON value appears, and its location within that file.

Class `JSONValue <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONValue.html>`__ has the following subclasses:

-  `JSONPrimitiveValue <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONPrimitiveValue.html>`__: a JSON-encoded primitive value; use ``JSONPrimitiveValue.getValue()`` to obtain a string representation of the value.

   -  `JSONNull <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONNull.html>`__, `JSONBoolean <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONBoolean.html>`__, `JSONNumber <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONNumber.html>`__, `JSONString <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONString.html>`__: subclasses of `JSONPrimitiveValue <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONPrimitiveValue.html>`__ representing the various kinds of primitive values.

-  `JSONArray <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONArray.html>`__: a JSON-encoded array; use ``JSONArray.getElementValue(i)`` to access the ``i``\ th element of the array.
-  `JSONObject <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/JSON.qll/type.JSON$JSONObject.html>`__: a JSON-encoded object; use ``JSONObject.getValue(n)`` to access the value of property ``n`` of the object.

Regular expressions
^^^^^^^^^^^^^^^^^^^

The ``semmle.javascript.Regexp`` library provides support for working with regular expression literals. The syntactic structure of regular expression literals is represented as an abstract syntax tree of regular expression terms, modeled by the class `RegExpTerm <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Regexp.qll/type.Regexp$RegExpTerm.html>`__. Similar to `ASTNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/AST.qll/type.AST$ASTNode.html>`__, class `RegExpTerm <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Regexp.qll/type.Regexp$RegExpTerm.html>`__ provides member predicates ``getParent()`` and ``getChild(i)`` to navigate the structure of the syntax tree.

Various subclasses of `RegExpTerm <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Regexp.qll/type.Regexp$RegExpTerm.html>`__ model different kinds of regular expression constructs and operators; see `the API documentation <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/Regexp.qll/module.Regexp.html>`__ for details.

YAML
^^^^

The ``semmle.javascript.YAML`` library provides support for working with `YAML <https://yaml.org/>`__ files that were processed by the JavaScript extractor when building the CodeQL database.

YAML files are modeled as trees of YAML nodes. Each YAML node is represented by an entity of class `YAMLNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLNode.html>`__, which provides, among others, the following member predicates:

-  ``YAMLNode.getParentNode()`` returns the YAML collection in which this node is syntactically nested.
-  ``YAMLNode.getChildNode(i)`` returns the ``i``\ th child node of this node, ``YAMLNode.getAChildNode()`` returns any child node of this node.
-  ``YAMLNode.getTag()`` returns the tag of this YAML node.
-  ``YAMLNode.getAnchor()`` returns the anchor associated with this YAML node, if any.
-  ``YAMLNode.eval()`` returns the `YAMLValue <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLValue.html>`__ this YAML node evaluates to after resolving aliases and includes.

The various kinds of scalar values available in YAML are represented by classes `YAMLInteger <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLInteger.html>`__, `YAMLFloat <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLFloat.html>`__, `YAMLTimestamp <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLTimestamp.html>`__, `YAMLBool <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLBool.html>`__, `YAMLNull <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLNull.html>`__ and `YAMLString <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLString.html>`__. Their common superclass is `YAMLScalar <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLScalar.html>`__, which has a member predicate ``getValue()`` to obtain the value of a scalar as a
string.

`YAMLMapping <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLMapping.html>`__ and `YAMLSequence <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLSequence.html>`__ represent mappings and sequences, respectively, and are subclasses of `YAMLCollection <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLCollection.html>`__.

Alias nodes are represented by class `YAMLAliasNode <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLAliasNode.html>`__, while `YAMLMergeKey <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLMergeKey.html>`__ and `YAMLInclude <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/YAML.qll/type.YAML$YAMLInclude.html>`__ represent merge keys and ``!include`` directives, respectively.

Predicate ``YAMLMapping.maps(key, value)`` models the key-value relation represented by a mapping, taking merge keys into account.

Further reading
---------------

.. include:: ../reusables/javascript-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
