.. csv-table::
   :header-rows: 1
   :widths: auto
   :stub-columns: 1

   Language,Variants,Compilers,Extensions
   C/C++,"C89, C99, C11, C17, C++98, C++03, C++11, C++14, C++17, C++20 [1]_ [2]_","Clang (including clang-cl [3]_ and armclang) extensions (up to Clang 17.0),

   GNU extensions (up to GCC 13.2),

   Microsoft extensions (up to VS 2022),

   Arm Compiler 5 [4]_","``.cpp``, ``.c++``, ``.cxx``, ``.hpp``, ``.hh``, ``.h++``, ``.hxx``, ``.c``, ``.cc``, ``.h``"
   C#,C# up to 12,"Microsoft Visual Studio up to 2019 with .NET up to 4.8,

   .NET Core up to 3.1

   .NET 5, .NET 6, .NET 7, .NET 8","``.sln``, ``.csproj``, ``.cs``, ``.cshtml``, ``.xaml``"
   Go (aka Golang), "Go up to 1.22", "Go 1.11 or more recent", ``.go``
   Java,"Java 7 to 22 [5]_","javac (OpenJDK and Oracle JDK),

   Eclipse compiler for Java (ECJ) [6]_",``.java``
   Kotlin [7]_,"Kotlin 1.5.0 to 2.0.0\ *x*","kotlinc",``.kt``
   JavaScript,ECMAScript 2022 or lower,Not applicable,"``.js``, ``.jsx``, ``.mjs``, ``.es``, ``.es6``, ``.htm``, ``.html``, ``.xhtm``, ``.xhtml``, ``.vue``, ``.hbs``, ``.ejs``, ``.njk``, ``.json``, ``.yaml``, ``.yml``, ``.raml``, ``.xml`` [8]_"
   Python [9]_,"2.7, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 3.11, 3.12",Not applicable,``.py``
   Ruby [10]_,"up to 3.3",Not applicable,"``.rb``, ``.erb``, ``.gemspec``, ``Gemfile``"
   Swift [11]_,"Swift 5.4-5.10","Swift compiler","``.swift``"
   TypeScript [12]_,"2.6-5.5",Standard TypeScript compiler,"``.ts``, ``.tsx``, ``.mts``, ``.cts``"

.. container:: footnote-group

    .. [1] C++20 support is currently in beta. Modules are *not* supported.
    .. [2] Objective-C, Objective-C++, C++/CLI, and C++/CX are not supported.
    .. [3] Support for the clang-cl compiler is preliminary.
    .. [4] Support for the Arm Compiler (armcc) is preliminary.
    .. [5] Builds that execute on Java 7 to 22 can be analyzed. The analysis understands Java 22 standard language features.
    .. [6] ECJ is supported when the build invokes it via the Maven Compiler plugin or the Takari Lifecycle plugin.
    .. [7] Kotlin support is currently in beta.
    .. [8] JSX and Flow code, YAML, JSON, HTML, and XML files may also be analyzed with JavaScript files.
    .. [9] The extractor requires Python 3 to run. To analyze Python 2.7 you should install both versions of Python.
    .. [10] Requires glibc 2.17.
    .. [11] Swift support is currently in beta. Support for the analysis of Swift requires macOS or Linux.
    .. [12] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default.
