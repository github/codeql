.. csv-table::
   :header-rows: 1
   :widths: auto
   :stub-columns: 1

   Language,Variants,Compilers,Extensions
   C/C++,"C89, C99, C11, C18, C++98, C++03, C++11, C++14, C++17","Clang (and clang-cl [1]_) extensions (up to Clang 9.0),

   GNU extensions (up to GCC 9.2),

   Microsoft extensions (up to VS 2019),

   Arm Compiler 5 [2]_","``.cpp``, ``.c++``, ``.cxx``, ``.hpp``, ``.hh``, ``.h++``, ``.hxx``, ``.c``, ``.cc``, ``.h``"
   C#,C# up to 8.0,"Microsoft Visual Studio up to 2019 with .NET up to 4.8,

   .NET Core up to 3.1","``.sln``, ``.csproj``, ``.cs``, ``.cshtml``, ``.xaml``"
   Go (aka Golang), "Go up to 1.15", "Go 1.11 or more recent", ``.go``
   Java,"Java 6 to 14 [3]_","javac (OpenJDK and Oracle JDK),

   Eclipse compiler for Java (ECJ) [4]_",``.java``
   JavaScript,ECMAScript 2019 or lower,Not applicable,"``.js``, ``.jsx``, ``.mjs``, ``.es``, ``.es6``, ``.htm``, ``.html``, ``.xhm``, ``.xhtml``, ``.vue``, ``.json``, ``.yaml``, ``.yml``, ``.raml``, ``.xml`` [5]_"
   Python,"2.7, 3.5, 3.6, 3.7, 3.8",Not applicable,``.py``
   TypeScript [6]_,"2.6-3.7",Standard TypeScript compiler,"``.ts``, ``.tsx``"

.. container:: footnote-group

    .. [1] Support for the clang-cl compiler is preliminary.
    .. [2] Support for the Arm Compiler (armcc) is preliminary.
    .. [3] Builds that execute on Java 6 to 14 can be analyzed. The analysis understands Java 14 standard language features.
    .. [4] ECJ is supported when the build invokes it via the Maven Compiler plugin or the Takari Lifecycle plugin.
    .. [5] JSX and Flow code, YAML, JSON, HTML, and XML files may also be analyzed with JavaScript files. 
    .. [6] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default for LGTM.   
