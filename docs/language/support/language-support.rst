Languages and compilers
#######################

CodeQL and LGTM version |version| support analysis of the following languages compiled by the following compilers.
(CodeQL was previously known as QL.)

Note that where there are several versions or dialects of a language, the supported variants are listed.
If your code requires a particular version of a compiler, check that this version is included below. 
Customers with any questions should contact their usual Semmle contact with any questions. 
If you're not a customer yet, contact us at info@semmle.com 
with any questions you have about language and compiler support.

.. csv-table::
     :file: versions-compilers.csv
     :header-rows: 1
     :widths: auto
     :stub-columns: 1

.. container:: footnote-group

    .. [1] Support for the clang-cl compiler is preliminary.
    .. [2] Support for the Arm Compiler (armcc) is preliminary.
    .. [3] In addition, support is included for the preview features of C# 8.0 and .NET Core 3.0.
    .. [4] The best results are achieved with COBOL code that stays close to the ANSI 85 standard.  
    .. [5] Builds that execute on Java 6 to 12 can be analyzed. The analysis understands Java 12 language features.
    .. [6] ECJ is supported when the build invokes it via the Maven Compiler plugin or the Takari Lifecycle plugin.
    .. [7] JSX and Flow code, YAML, JSON, HTML, and XML files may also be analyzed with JavaScript files. 
    .. [8] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default for LGTM.   
