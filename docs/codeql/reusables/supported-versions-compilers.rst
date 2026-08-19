.. csv-table::
   :header-rows: 1
   :widths: auto
   :stub-columns: 1

   Language,Variants,Compilers,Extensions
   C/C++,"C89, C99, C11, C17, C23, C++98, C++03, C++11, C++14, C++17, C++20, C++23 [1]_ [2]_ [3]_","Clang (including clang-cl and armclang) extensions (up to Clang 21),

   GNU extensions (up to GCC 15),

   Microsoft extensions (up to VS 2022),

   Arm Compiler 5 [4]_","``.cpp``, ``.c++``, ``.cxx``, ``.hpp``, ``.hh``, ``.h++``, ``.hxx``, ``.c``, ``.cc``, ``.h``"
   C#,C# up to 14,"Microsoft Visual Studio up to 2019 with .NET up to 4.8,

   .NET Core up to 3.1

   .NET 5, .NET 6, .NET 7, .NET 8, .NET 9, .NET 10","``.sln``, ``.slnx``, ``.csproj``, ``.cs``, ``.cshtml``, ``.xaml``"
   GitHub Actions,"Not applicable",Not applicable,"``.github/workflows/*.yml``, ``.github/workflows/*.yaml``, ``**/action.yml``, ``**/action.yaml``"
   Go (aka Golang), "Go up to 1.26", "Go 1.11 or more recent", ``.go``
   Java,"Java 7 to 26 [5]_","javac (OpenJDK and Oracle JDK),

   Eclipse compiler for Java (ECJ) [6]_",``.java``
   Kotlin,"Kotlin 1.8.0 to 2.4.1\ *x*","kotlinc",``.kt``
   JavaScript,ECMAScript 2022 or lower,Not applicable,"``.js``, ``.jsx``, ``.mjs``, ``.es``, ``.es6``, ``.htm``, ``.html``, ``.xhtm``, ``.xhtml``, ``.vue``, ``.hbs``, ``.ejs``, ``.njk``, ``.json``, ``.yaml``, ``.yml``, ``.raml``, ``.xml`` [7]_"
   Python [8]_,"2.7, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 3.11, 3.12, 3.13, 3.14",Not applicable,``.py``
   Ruby,"up to 3.3",Not applicable,"``.rb``, ``.erb``, ``.gemspec``, ``Gemfile``"
   Rust [9]_,"Rust editions 2021 and 2024","Rust compiler","``.rs``, ``Cargo.toml``"
   Swift [10]_ [11]_,"Swift 5.4-6.3","Swift compiler","``.swift``"
   TypeScript [12]_,"2.6-7.0",Standard TypeScript compiler,"``.ts``, ``.tsx``, ``.mts``, ``.cts``"

.. container:: footnote-group

    .. [1] C++20 modules are *not* supported.
    .. [2] C23 and C++23 support is currently in beta.
    .. [3] Objective-C, Objective-C++, C++/CLI, and C++/CX are not supported.
    .. [4] Support for the Arm Compiler (armcc) is preliminary.
    .. [5] Builds that execute on Java 7 to 26 can be analyzed. The analysis understands standard language features in Java 8 to 26; "preview" and "incubator" features are not supported. Source code using Java language versions older than Java 8 are analyzed as Java 8 code.
    .. [6] ECJ is supported when the build invokes it via the Maven Compiler plugin or the Takari Lifecycle plugin.
    .. [7] JSX and Flow code, YAML, JSON, HTML, and XML files may also be analyzed with JavaScript files.
    .. [8] The extractor requires Python 3 to run. To analyze Python 2.7 you should install both versions of Python.
    .. [9] Requires ``rustup`` and ``cargo`` to be installed. Features from nightly toolchains are not supported.
    .. [10] Support for the analysis of Swift requires macOS.
    .. [11] Embedded Swift is not supported.
    .. [12] TypeScript analysis is performed by running the JavaScript extractor with TypeScript enabled. This is the default.
