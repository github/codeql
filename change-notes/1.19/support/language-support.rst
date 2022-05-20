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

    .. [1] The best results are achieved with COBOL code that stays close to the ANSI 85 standard.  
    .. [2] Java 11 refers to the language features used. Builds that execute on Java 6 or higher can be analyzed.
    .. [3] JSX and Flow code, YAML, JSON, and HTML files may also be analyzed with JavaScript files. 
    .. [4] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default for LGTM.   
