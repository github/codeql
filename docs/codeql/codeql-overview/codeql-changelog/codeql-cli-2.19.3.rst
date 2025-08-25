.. _codeql-cli-2.19.3:

==========================
CodeQL 2.19.3 (2024-11-07)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.19.3 runs a total of 427 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE).

CodeQL CLI
----------

Bug Fixes
~~~~~~~~~

*   Fixed a bug where using :code:`codeql database import` to combine multiple non-empty databases may produce a corrupted database. (The bug does not affect using
    :code:`codeql database finalize --additional-dbs` to combine multiple databases.)
    
*   Fixed a bug where uses of a :code:`QlBuiltins::ExtensionId` variable that was not bound to a value could be incorrectly accepted in some cases. In many cases,
    this would result in a crash.
    
*   CodeQL would sometimes refuse to run with more than around 1,500 GB of RAM available, complaining that having so much memory was "unrealistic". The amount of memory CodeQL is able to make any meaningful use of still tops out at about that value, but it will now gracefully accept that so large computers do in fact exist.
    
*   Fixed a bug in command-line parsing where a misspelled option could sometimes be misinterpreted as, e.g., the name of a query to run. Now every command-line argument that begins with a dash is assumed to be intended as an option
    (unless it comes after the :code:`--` separator), and an appropriate error is emitted if that is not a recognized one.
    
    The build command in :code:`codeql database trace-command` is exempted from this for historical reasons, but we strongly recommend putting a :code:`--` before the entire build command there, in case a future :code:`codeql` version starts recognizing options that you intended to be part of the build command.

Miscellaneous
~~~~~~~~~~~~~

*   The CodeQL Bundle is now available as an artifact that is compressed using
    \ `Zstandard <https://en.wikipedia.org/wiki/Zstd>`__. This artifact is smaller and faster to decompress than the original, gzip-compressed bundle. The CodeQL bundle is a tar archive containing tools, scripts, and various CodeQL-specific files.
    
    If you are currently using the CodeQL Bundle, you may want to consider switching to the Zstandard variant of the bundle. You can download the new form of the CodeQL Bundle from the
    \ `codeql-action releases page <https://github.com/github/codeql-action/releases/tag/codeql-bundle-v2.19.3>`__ by selecting the appropriate bundle with the :code:`.zst` extension. The gzip-compressed bundles will continue to be available for backwards compatibility.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Remove results from the :code:`cpp/wrong-type-format-argument` ("Wrong type of arguments to formatting function") query if the argument is the return value of an implicitly declared function.

C#
""

*   C#: The method :code:`string.ReplaceLineEndings(string)` is now considered a sanitizer for the :code:`cs/log-forging` query.

Python
""""""

*   Improved modelling for the :code:`pycurl` framework.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The generated .NET 8 runtime models have been updated.

Java/Kotlin
"""""""""""

*   Java: The generated JDK 17 models have been updated.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The function call target resolution algorithm has been improved to resolve more calls through function pointers. As a result, dataflow queries may have more results.

Golang
""""""

*   The AST viewer now shows type parameter declarations in the correct place in the AST.

Java/Kotlin
"""""""""""

*   Java :code:`build-mode=none` extraction now packages the Maven plugin used to examine project dependencies. This means that dependency identification is more likely to succeed, and therefore analysis quality may rise, in scenarios where Maven Central is not reachable.

Python
""""""

*   Added partial support for the :code:`copy.replace` method, `added <https://docs.python.org/3.13/library/copy.html#copy.replace>`__ in Python 3.13.
*   Added support for type parameter defaults, as specified in `PEP-696 <https://peps.python.org/pep-0696/>`__.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Added a new predicate :code:`DataFlow::getARuntimeTarget` for getting a function that may be invoked by a :code:`Call` expression. Unlike :code:`Call.getTarget` this new predicate may also resolve function pointers.
*   Added the predicate :code:`mayBeFromImplicitlyDeclaredFunction()` to the :code:`Call` class to represent calls that may be the return value of an implicitly declared C function.
*   Added the predicate :code:`getAnExplicitDeclarationEntry()` to the :code:`Function` class to get a :code:`FunctionDeclarationEntry` that is not implicit.
*   Added classes :code:`RequiresExpr`, :code:`SimpleRequirementExpr`, :code:`TypeRequirementExpr`, :code:`CompoundRequirementExpr`, and :code:`NestedRequirementExpr` to represent C++20 requires expressions and the simple, type, compound, and nested requirements that can occur in :code:`requires` expressions.

JavaScript/TypeScript
"""""""""""""""""""""

*   Added support for custom threat-models, which can be used in most of our taint-tracking queries, see our `documentation <https://docs.github.com/en/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models>`__ for more details.
