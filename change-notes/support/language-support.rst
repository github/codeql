Languages and compilers
#######################

QL and LGTM version |version| support analysis of the following languages compiled by the following compilers.

Note that where there are several versions or dialects of a language, the supported variants are listed.

.. csv-table::
     :file: versions-compilers.csv
     :header-rows: 1
     :widths: auto
     :stub-columns: 1

.. container:: footnote-group

    .. [1] Support for the Arm Compiler (armcc) is preliminary.
    .. [2] In addition, support is included for the preview features of C# 8.0 and .NET Core 3.0.
    .. [3] The best results are achieved with COBOL code that stays close to the ANSI 85 standard.  
    .. [4] Builds that execute on Java 6 to 12 can be analyzed. The analysis understands Java 12 language features.
    .. [5] JSX and Flow code, YAML, JSON, HTML, and XML files may also be analyzed with JavaScript files. 
    .. [6] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default for LGTM.   
