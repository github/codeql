.. _codeql-cli-2.17.5:

==========================
CodeQL 2.17.5 (2024-06-12)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/code-scanning/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.17.5 runs a total of 414 security queries when configured with the Default suite (covering 161 CWE). The Extended suite enables an additional 131 queries (covering 35 more CWE).

CodeQL CLI
----------

Breaking Changes
~~~~~~~~~~~~~~~~

*   All the commands that output SARIF will output a minified version to reduce the size.
    The :code:`codeql database analyze`, :code:`codeql database interpret-results`, :code:`codeql generate query-help`, and :code:`codeql bqrs interpret` commands support the option :code:`--no-sarif-minify` to output a pretty printed SARIF file.
    
*   A number of breaking changes have been made to the :code:`semmle-extractor-options` functionality available for C and C++ CodeQL tests.

    *   The Arm, Intel, and CodeWarrior compilers are no longer supported and the
        :code:`--armcc`, :code:`--intel`, :code:`--codewarrior` flags are now ignored, as are all the flags that only applied to those compilers.
    *   The :code:`--threads` and :code:`-main-file-name` options, which did not have any effect on tests, are now ignored. Any specification of these options as part of
        :code:`semmle-extractor-options` should be removed.
    *   Support for :code:`--linker`, all flags that would only invoke the preprocessor,
        and the :code:`/clr` flag have been removed, as those flags would never produce any usable test output.
    *   Support for the :code:`--include_path_environment` flag has been removed. All include paths should directly be specified as part of :code:`semmle-extractor-options`.
    *   Microsoft C/C++ compiler response files specified via :code:`@some_file_name` are now ignored. Instead, all options should directly be specified as part of
        :code:`semmle-extractor-options`.
    *   Support for Microsoft :code:`#import` preprocessor directive has been removed, as support depends on the availability of the Microsoft C/C++ compiler, and availability cannot be guaranteed on all platforms while executing tests.
    *   Support for the Microsoft :code:`/EHa`, :code:`/EHs`, :code:`/GX`, :code:`/GZ`, :code:`/Tc`, :code:`/Tp`, and :code:`/Zl` flags, and all :code:`/RTC` flags have been removed. Any specification of these options as part of :code:`semmle-extractor-options` should be removed.
    *   Support for the Apple-specific :code:`-F` and :code:`-iframework` flags has been removed.
        The :code:`-F` flag can still be used by replacing :code:`-F <directory>` by
        :code:`--edg -F --edg <directory>`. Any occurrence of :code:`-iframework <arg>` should be replaced by :code:`--edg --sys_framework --edg <arg>`.
    *   Support for the :code:`/TC`, :code:`/TP`, and :code:`-x` flags has been removed. Please ensure all C, respectively C++, source files have a :code:`.c`, respectively :code:`.cpp`,
        extension.
    *   The :code:`--build_error_dir`, :code:`-db`, :code:`--edg_base_dir`, :code:`--error_limit`,
        :code:`--src_archive`, :code:`--trapfolder`, and :code:`--variadic_macros` flags are now ignored.
    
    The above changes do not affect the creation of databases through the CodeQL CLI,
    or when calling the C/C++ extractor directly with the :code:`--mimic` or :code:`--linker` flags.
    Similar functionality continues to be supported in those scenarios, except for CodeWarrior and the :code:`--edg_base_dir`, :code:`--include_path_environment`, :code:`/Tc`, and :code:`/Tp` flags, which were never supported.

Improvements
~~~~~~~~~~~~

*   :code:`codeql generate log-summary` now reports completed pipeline runs that are part of an incomplete recursive predicate.

Miscellaneous
~~~~~~~~~~~~~

*   The OWASP Java HTML Sanitizer library used by the CodeQL CLI for internal documentation generation commands has been updated to version
    \ `20240325.1 <https://github.com/OWASP/java-html-sanitizer/releases/tag/release-20240325.1>`__.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   The :code:`cpp/dangerous-function-overflow` no longer produces a false positive alert when the :code:`gets` function does not have exactly one parameter.

C#
""

*   .NET 8 Runtime models have been updated based on the newest version of the model generator. Furthermore, the database sources have been changed slightly to reduce result multiplicity.

Java/Kotlin
"""""""""""

*   The query :code:`java/spring-disabled-csrf-protection` detects disabling CSRF via :code:`ServerHttpSecurity$CsrfSpec::disable`.
*   Added more :code:`java.io.File`\ -related sinks to the path injection query.

Python
""""""

*   Added models for :code:`opml` library.

Language Libraries
------------------

Major Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Java/Kotlin
"""""""""""

*   The precision of virtual dispatch has been improved. This increases precision in general for all data flow queries.

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   A partial model for the :code:`Boost.Asio` network library has been added. This includes sources, sinks and summaries for certain functions in :code:`Boost.Asio`, such as :code:`read_until` and :code:`write`.

Java/Kotlin
"""""""""""

*   Support for Eclipse Compiler for Java (ecj) has been fixed to work with (a) runs that don't pass :code:`-noExit` and (b) runs that use post-Java-9 command-line arguments.

New Features
~~~~~~~~~~~~

C/C++
"""""

*   Data models can now be added with data extensions. In this way source, sink and summary models can be added in extension :code:`.model.yml` files, rather than by writing classes in QL code. New models should be added in the :code:`lib/ext` folder.

Golang
""""""

*   When writing models-as-data models, the receiver is now referred to as :code:`Argument[receiver]` rather than :code:`Argument[-1]`.
*   Neutral models are now supported. They have no effect except that a manual neutral summary model will stop a generated summary model from having any effect.
