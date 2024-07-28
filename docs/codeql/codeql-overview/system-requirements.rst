:tocdepth: 1

.. _system-requirements:

System requirements
-------------------

System requirements for running the latest version of CodeQL.

Supported platforms
#######################

.. include:: ../reusables/supported-platforms.rst

Additional software requirements
################################

To generate a CodeQL database for a compiled language, you must ensure that the system can successfully build and compile your code, independently of CodeQL.

In addition, CodeQL extraction has the following requirements.

For extraction of compiled languages (C/C++, C#, Go, Java) and Ruby on Linux:

- ``glibc`` version 2.17 or greater must be installed.
- ``musl-c``-based Linux distributions, such as Alpine Linux, are not supported.

For extraction of compiled languages on Windows:

- The ``PowerShell.exe`` executable must be available on the ``PATH``.

For TypeScript extraction on all platforms:

- Node.js 14 or higher must be installed and available on the ``PATH`` as ``node``.

For Python extraction:

- On Linux and macOS, Python 3 must be installed and available on the ``PATH`` as ``python3`` or ``python``.
- For Python 2 extraction on Linux and macOS, we also recommend having Python 2 installed and available on the ``PATH`` as ``python2``.
- On Windows, the Python launcher must be installed and available on the ``PATH`` as ``py.exe``.

For Ruby extraction:

- On Windows, the ``msvcp140.dll`` must be installed and available on the system. This can be installed by downloading the appropriate Microsoft Visual C++ Redistributable for Visual Studio.

For Java extraction:

- There must be a ``java`` or ``java.exe`` executable available on the ``PATH``, and the ``JAVA_HOME`` environment variable must point to the corresponding JDK's home directory.
- If you need to analyse projects using varying JDK versions, it may be useful to supply alternate JDK versions using environment variables of the form ``JAVA_HOME_$VERSION_$PLATFORM``, following the example of `the GitHub Actions runner images <https://github.com/actions/runner-images/blob/main/images/ubuntu/Ubuntu2404-Readme.md#java>`__. An Apache Maven `toolchains.xml file <https://maven.apache.org/guides/mini/guide-using-toolchains.html#using-toolchains-in-your-project>`__ can also be used for the same purpose.
- Having a ``mvn`` or ``mvn.exe`` executable available on the ``PATH`` is recommended if your project uses Apache Maven and does not use the ``mvnw`` wrapper script.
- Having a ``gradle`` or ``gradle.exe`` executable available on the ``PATH`` is recommended if your project uses Gradle and does not use the ``gradlew`` wrapper script.
