.. csv-table::
   :header-rows: 1
   :widths: auto
   :stub-columns: 1

   Language,Variants,Compilers,Extensions
   C/C++,"C89, C99, C11, C18, C++98, C++03, C++11, C++14, C++17, C++20 [1]_","Clang (and clang-cl [2]_) extensions (up to Clang 12.0),

   GNU extensions (up to GCC 11.1),

   Microsoft extensions (supported versions [3]_ up to VS 2019),

   Arm Compiler 5 [4]_","``.cpp``, ``.c++``, ``.cxx``, ``.hpp``, ``.hh``, ``.h++``, ``.hxx``, ``.c``, ``.cc``, ``.h``"
   C#,C# up to 10.0,"Microsoft Visual Studio up to 2019 with .NET up to 4.8,

   .NET Core up to 3.1

   .NET 5, .NET 6","``.sln``, ``.csproj``, ``.cs``, ``.cshtml``, ``.xaml``"
   Go (aka Golang), "Go up to 1.18", "Go 1.11 or more recent", ``.go``
   Java,"Java 7 to 18 [5]_","javac (OpenJDK and Oracle JDK),

   Eclipse compiler for Java (ECJ) [6]_",``.java``
   Kotlin [7]_,"Kotlin 1.5.0 to 1.7.21","kotlinc",``.kt``
   JavaScript,ECMAScript 2022 or lower,Not applicable,"``.js``, ``.jsx``, ``.mjs``, ``.es``, ``.es6``, ``.htm``, ``.html``, ``.xhtm``, ``.xhtml``, ``.vue``, ``.hbs``, ``.ejs``, ``.njk``, ``.json``, ``.yaml``, ``.yml``, ``.raml``, ``.xml`` [8]_"
   Python [9]_,"2.7, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10",Not applicable,``.py``
   Ruby [10]_,"up to 3.1",Not applicable,"``.rb``, ``.erb``, ``.gemspec``, ``Gemfile``"
   TypeScript [11]_,"2.6-4.8",Standard TypeScript compiler,"``.ts``, ``.tsx``, ``.mts``, ``.cts``"

.. container:: footnote-group

    .. [1] C++20 support is currently in beta. Supported for GCC on Linux only. Modules are *not* supported.
    .. [2] Support for the clang-cl compiler is preliminary.
    .. [3] See the `Visual Studio Product Lifecycle <https://learn.microsoft.com/en-us/visualstudio/productinfo/vs-servicing#older-versions-of-visual-studio>`__.
    .. [4] Support for the Arm Compiler (armcc) is preliminary.
    .. [5] Builds that execute on Java 7 to 19 can be analyzed. The analysis understands Java 19 standard language features.
    .. [6] ECJ is supported when the build invokes it via the Maven Compiler plugin or the Takari Lifecycle plugin.
    .. [7] Kotlin support is currently in beta.
    .. [8] JSX and Flow code, YAML, JSON, HTML, and XML files may also be analyzed with JavaScript files.
    .. [9] The extractor requires Python 3 to run. To analyze Python 2.7 you should install both versions of Python.
    .. [10] Requires glibc 2.17.
    .. [11] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default for LGTM.
