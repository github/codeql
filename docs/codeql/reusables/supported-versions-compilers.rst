.. csv-table::
   :header-rows: 1
   :widths: auto
   :stub-columns: 1

   Language,Variants,Compilers,Extensions
   C/C++,"C89, C99, C11, C17, C23, C++98, C++03, C++11, C++14, C++17, C++20, C++23 [1]_ [2]_ [3]_","Clang (including clang-cl [4]_ and armclang) extensions (up to Clang 19.1.0),

   GNU extensions (up to GCC 15.0),

   Microsoft extensions (up to VS 2022),

   Arm Compiler 5 [5]_","``.cpp``, ``.c++``, ``.cxx``, ``.hpp``, ``.hh``, ``.h++``, ``.hxx``, ``.c``, ``.cc``, ``.h``"
   C#,C# up to 13,"Microsoft Visual Studio up to 2019 with .NET up to 4.8,

   .NET Core up to 3.1

   .NET 5, .NET 6, .NET 7, .NET 8, .NET 9","``.sln``, ``.csproj``, ``.cs``, ``.cshtml``, ``.xaml``"
   GitHub Actions,"Not applicable",Not applicable,"``.github/workflows/*.yml``, ``.github/workflows/*.yaml``, ``**/action.yml``, ``**/action.yaml``"
   Go (aka Golang), "Go up to 1.24", "Go 1.11 or more recent", ``.go``
   Java,"Java 7 to 24 [6]_","javac (OpenJDK and Oracle JDK),

   Eclipse compiler for Java (ECJ) [7]_",``.java``
   Kotlin,"Kotlin 1.6.0 to 2.2.0\ *x*","kotlinc",``.kt``
   JavaScript,ECMAScript 2022 or lower,Not applicable,"``.js``, ``.jsx``, ``.mjs``, ``.es``, ``.es6``, ``.htm``, ``.html``, ``.xhtm``, ``.xhtml``, ``.vue``, ``.hbs``, ``.ejs``, ``.njk``, ``.json``, ``.yaml``, ``.yml``, ``.raml``, ``.xml`` [8]_"
   Python [9]_,"2.7, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 3.11, 3.12, 3.13",Not applicable,``.py``
   Ruby [10]_,"up to 3.3",Not applicable,"``.rb``, ``.erb``, ``.gemspec``, ``Gemfile``"
   Swift [11]_,"Swift 5.4-6.1","Swift compiler","``.swift``"
   TypeScript [12]_,"2.6-5.8",Standard TypeScript compiler,"``.ts``, ``.tsx``, ``.mts``, ``.cts``"

.. container:: footnote-group

    .. [1] C++20 modules are *not* supported.
    .. [2] C23 and C++23 support is currently in beta.
    .. [3] Objective-C, Objective-C++, C++/CLI, and C++/CX are not supported.
    .. [4] Support for the clang-cl compiler is preliminary.
    .. [5] Support for the Arm Compiler (armcc) is preliminary.
    .. [6] Builds that execute on Java 7 to 24 can be analyzed. The analysis understands standard language features in Java 8 to 24; "preview" and "incubator" features are not supported. Source code using Java language versions older than Java 8 are analyzed as Java 8 code.
    .. [7] ECJ is supported when the build invokes it via the Maven Compiler plugin or the Takari Lifecycle plugin.
    .. [8] JSX and Flow code, YAML, JSON, HTML, and XML files may also be analyzed with JavaScript files.
    .. [9] The extractor requires Python 3 to run. To analyze Python 2.7 you should install both versions of Python.
    .. [10] Requires glibc 2.17.
    .. [11] Support for the analysis of Swift requires macOS.
    .. [12] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default.
