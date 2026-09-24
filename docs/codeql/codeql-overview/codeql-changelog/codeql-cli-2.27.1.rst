.. _codeql-cli-2.27.1:

==========================
CodeQL 2.27.1 (2026-09-22)
==========================

.. contents:: Contents
   :depth: 2
   :local:
   :backlinks: none

This is an overview of changes in the CodeQL CLI and relevant CodeQL query and library packs. For additional updates on changes to the CodeQL code scanning experience, check out the `code scanning section on the GitHub blog <https://github.blog/tag/code-scanning/>`__, `relevant GitHub Changelog updates <https://github.blog/changelog/label/application-security/>`__, `changes in the CodeQL extension for Visual Studio Code <https://marketplace.visualstudio.com/items/GitHub.vscode-codeql/changelog>`__, and the `CodeQL Action changelog <https://github.com/github/codeql-action/blob/main/CHANGELOG.md>`__.

Security Coverage
-----------------

CodeQL 2.27.1 runs a total of 498 security queries when configured with the Default suite (covering 170 CWE). The Extended suite enables an additional 131 queries (covering 32 more CWE).

CodeQL CLI
----------

Miscellaneous
~~~~~~~~~~~~~

*   The build of Eclipse Temurin OpenJDK that is used to run the CodeQL CLI has been updated to version 25.0.4.1.
    
    New Java releases may not be completely backwards compatible. For example,
    Java 25 has a known issue that affects symlink resolution on mapped drives on Windows (JDK-8355342). Users impacted by such regressions can run CodeQL with an alternative JDK using the CODEQL_JAVA_HOME environment variable.

Query Packs
-----------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C#
""

*   The :code:`cs/linq/missed-*` queries no longer suggest rewrites that would capture :code:`in`, :code:`out`, or :code:`ref` parameters in a lambda, fixing false-positive results for transformations that would not compile.
*   The :code:`cs/web/missing-token-validation` query now recognizes an ASP.NET Core :code:`AutoValidateAntiforgeryTokenAttribute` registered as a global MVC filter through :code:`AddControllersWithViews` (and friends), avoiding false-positive results for covered actions.

GitHub Actions
""""""""""""""

*   The :code:`actions/unpinned-tag` query no longer reports action references pinned by a structurally valid :code:`.github/workflows/actions.lock` entry for the enclosing workflow.
*   The :code:`actions/unpinned-tag` query no longer reports :code:`$/` self repository references (e.g. :code:`uses: $/path/to/action`), which resolve to the same repository at the running commit and are therefore inherently pinned, just like :code:`./` self workspace (local) references.

New Queries
~~~~~~~~~~~

C/C++
"""""

*   Added a new query, :code:`cpp/ambiguous-assignment-of-comparison`, to detect potentially ambiguous expressions where a comparison result is assigned to a variable and the assignment is used as a truth value.

C#
""

*   Added a new query, :code:`cs/linq/missed-firstordefault`, that detects :code:`foreach` loops that can be expressed more clearly using LINQ's :code:`FirstOrDefault` method.

Language Libraries
------------------

Minor Analysis Improvements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

C/C++
"""""

*   Added taint flow models for the :code:`boost::asio::ip::basic_resolver::resolve` function.
*   Added flow summaries for the BDE :code:`BloombergLP::bdlbb::Blob` segmented byte buffer.
*   Added flow summaries for the Protocol Buffers :code:`google::protobuf::MessageLite` C++ API.

C#
""

*   Private NuGet registries for which the "Replaces base" option is enabled in the organization-level private registry configuration now replace default NuGet feeds whenever dependencies are downloaded, including when default NuGet feeds are configured explicitly for a project.

Golang
""""""

*   Added or improved data flow models for the following Go standard-library APIs introduced or updated in Go 1.27:

    *   :code:`bytes.CutLast`, :code:`database/sql.ConvertAssign`, :code:`database/sql/driver.RowsColumnScanner.ScanColumn`, :code:`net/url.URL.Clone`, :code:`net/url.Values.Clone` and :code:`strings.CutLast`.
    *   The new :code:`encoding/json/jsontext` package.
    
*   Added more data flow models for the :code:`strings` package: :code:`strings.Clone`, :code:`Cut`, :code:`CutPrefix`, :code:`CutSuffix`, :code:`Fields`, :code:`FieldsFunc`, and :code:`Join`\ ; :code:`strings.Builder.String`, :code:`Builder.WriteByte`, and :code:`Builder.WriteRune`\ ; :code:`strings.Reader.ReadByte` and :code:`Reader.ReadRune`\ ; and :code:`strings.Replacer.Replace` and :code:`Replacer.WriteString`.

Java/Kotlin
"""""""""""

*   Support for Kotlin 2.4.20 has been added.
*   Fixed an issue where :code:`Foo::class.java` arguments were dropped during extraction under the Kotlin K2 compiler, which could cause false positives in queries such as :code:`java/android/implicit-pendingintents`.

JavaScript/TypeScript
"""""""""""""""""""""

*   Fastify servers reached through a chainable configuration method, such as :code:`fastify().withTypeProvider<T>()` or :code:`fastify().setValidatorCompiler(...)`, are now recognized as the same server instance. Routes registered on such an instance are now attributed to their server, which may add results for queries such as :code:`js/missing-rate-limiting` where routes were previously not recognized at all, and remove false positives where a globally registered plugin guards them.

Rust
""""

*   Fix path resolution for :code:`m::{self}` paths where :code:`m` is a trait.
*   Added data-flow models for :code:`core::fmt::Write`. This may improve detection of vulnerabilities where tainted data is written to a formatted output buffer.
*   The Rust extractor has been upgraded to use :code:`rust-analyzer` version 0.0.347. As a result, the AST exposed by the Rust libraries has changed: new :code:`DerefPat`, :code:`ImplRestriction`, :code:`IncludeBytesExpr`, :code:`MutRestriction`, :code:`NotNull`, :code:`PatternTypeRepr`, and :code:`VisibilityInner` classes have been added; the :code:`FormatArgsArgName` class has been removed in favour of :code:`FormatArgsArg.getName()`, which now returns a :code:`Name`\ ; :code:`Visibility.getPath()` has been moved onto the new :code:`VisibilityInner` class, reachable via :code:`Visibility.getVisibilityInner()`\ ; and :code:`attrs` have been added to the inline assembly nodes, :code:`getMutRestriction()` to :code:`StructField` and :code:`TupleField`, and :code:`getImplRestriction()` to :code:`Trait`.
