.. _codeql-cli-2.18.2:

==========================
CodeQL 2.18.2 (2024-08-13)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.18.2 runs a total of 423 security queries when configured with the Default suite (covering 164 CWE). The Extended suite enables an additional 128 queries (covering 34 more CWE). 3 security queries have been added with this release.

CodeQL CLI
----------

Deprecations
~~~~~~~~~~~~

*   Swift analysis on Ubuntu is no longer supported. Please migrate to macOS if this affects you.

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 21.0.3.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Fixed false positives in the :code:`cpp/memory-may-not-be-freed` ("Memory may not be freed") query involving class methods that returned an allocated field of that class being misidentified as allocators.
*   The :code:`cpp/incorrectly-checked-scanf` ("Incorrect return-value check for a 'scanf'-like function") query now produces fewer false positive results.
*   The :code:`cpp/incorrect-allocation-error-handling` ("Incorrect allocation-error handling") query no longer produces occasional false positive results inside template instantiations.
*   The :code:`cpp/suspicious-allocation-size` ("Not enough memory allocated for array of pointer type") query no longer produces false positives on "variable size" :code:`struct`\ s.

Java/Kotlin
"""""""""""

*   Variables names containing the string "tokenizer" (case-insensitively) are no longer sources for the :code:`java/sensitive-log` query. They normally relate to things like :code:`java.util.StringTokenizer`, which are not sensitive information. This should fix some false positive alerts.
*   The query "Unused classes and interfaces" (:code:`java/unused-reference-type`) now recognizes that if a method of a class has an annotation then it may be accessed reflectively. This should remove false positive alerts, especially for JUnit 4-style tests annotated with :code:`@test`.
*   Alerts about exposing :code:`exception.getMessage()` in servlet responses are now split out of :code:`java/stack-trace-exposure` into its own query :code:`java/error-message-exposure`.
*   Added the extensible abstract class :code:`SensitiveLoggerSource`. Now this class can be extended to add more sources to the :code:`java/sensitive-log` query or for customizations overrides.

Python
""""""

*   Added models of :code:`streamlit` PyPI package.

Swift
"""""

*   The :code:`swift/constant-salt` ("Use of constant salts") query now considers string concatenation and interpolation as a barrier. As a result, there will be fewer false positive results from this query involving constructed strings.
*   The :code:`swift/constant-salt` ("Use of constant salts") query message now contains a link to the source node.

New Queries
~~~~~~~~~~~

Python
""""""

*   The :code:`py/cookie-injection` query, originally contributed to the experimental query pack by @jorgectf, has been promoted to the main query pack. This query finds instances of cookies being constructed from user input.

Ruby
""""

*   Added a new query, :code:`rb/weak-sensitive-data-hashing`, to detect cases where sensitive data is hashed using a weak cryptographic hashing algorithm.

Query Metadata Changes
~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The precision of :code:`cpp/unsigned-difference-expression-compared-zero` ("Unsigned difference expression compared to zero") has been increased to :code:`high`. As a result, it will be run by default as part of the Code Scanning suite.

Language Libraries
------------------

Breaking Changes
~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The Java and Kotlin extractors no longer support the :code:`SOURCE_ARCHIVE` and :code:`TRAP_FOLDER` legacy environment variable.

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   We previously considered reverse DNS resolutions (IP address -> domain name) as sources of untrusted data, since compromised/malicious DNS servers could potentially return malicious responses to arbitrary requests. We have now removed this source from the default set of untrusted sources and made a new threat model kind for them, called "reverse-dns". You can optionally include other threat models as appropriate when using the CodeQL CLI and in GitHub code scanning. For more information, see `Analyzing your code with CodeQL queries <https://docs.github.com/code-security/codeql-cli/getting-started-with-the-codeql-cli/analyzing-your-code-with-codeql-queries#including-model-packs-to-add-potential-sources-of-tainted-data%3E>`__ and `Customizing your advanced setup for code scanning <https://docs.github.com/code-security/code-scanning/creating-an-advanced-setup-for-code-scanning/customizing-your-advanced-setup-for-code-scanning#extending-codeql-coverage-with-threat-models>`__.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The controlling expression of a :code:`constexpr if` is now always recognized as an unevaluated expression.
*   Improved performance of alias analysis of large function bodies. In rare cases, alerts that depend on alias analysis of large function bodies may be affected.
*   A :code:`UsingEnumDeclarationEntry` class has been added for C++ :code:`using enum` declarations. As part of this, synthesized :code:`UsingDeclarationEntry`\ s are no longer emitted for individual enumerators of the referenced enumeration.

Java/Kotlin
"""""""""""

*   Added flow through some methods of the class :code:`java.net.URL` by ensuring that the fields of a URL are tainted.
*   Added path-injection sinks for :code:`org.apache.tools.ant.taskdefs.Property.setFile` and :code:`org.apache.tools.ant.taskdefs.Property.setResource`.
*   Adds models for request handlers using the :code:`org.lastaflute.web` web framework.

Python
""""""

*   Added support for :code:`DictionaryElement[<key>]` and :code:`DictionaryElementAny` when Customizing Library Models for :code:`sourceModel` (see https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-python/)

Swift
"""""

*   The model for :code:`FileManager` no longer considers methods that return paths on the file system as taint sources. This is because these sources have been found to produce results of low value.
*   An error in the model for :code:`URL.withUnsafeFileSystemRepresentation(_:)` has been corrected. This may result in new data flow paths being found during analysis.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   A :code:`getTemplateClass` predicate was added to the :code:`DeductionGuide` class to get the class template for which the deduction guide is a guide.
*   An :code:`isExplicit` predicate was added to the :code:`Function` class that determines whether the function was declared as explicit.
*   A :code:`getExplicitExpr` predicate was added to the :code:`Function` class that yields the constant boolean expression (if any) that conditionally determines whether the function is explicit.
*   A :code:`isDestroyingDeleteDeallocation` predicate was added to the :code:`NewOrNewArrayExpr` and :code:`DeleteOrDeleteArrayExpr` classes to indicate whether the deallocation function is a destroying delete.

Java/Kotlin
"""""""""""

*   Java support for :code:`build-mode: none` is now out of beta, and generally available.
