QL training and variant analysis examples
#########################################

Introduction to variant analysis with QL
========================================

`Variant analysis <https://semmle.com/variant-analysis>`__ is the process of using a known vulnerability as a seed to find similar problems in your code. Security engineers typically perform variant analysis to identify possible vulnerabilities and to ensure these threats are properly fixed across multiple code bases.

`QL <https://semmle.com/ql>`__ is Semmle's variant analysis engine, and it is also the technology that underpins LGTM, Semmle's community driven security analysis platform. Together, QL and LGTM provide continuous monitoring and scalable variant analysis for your projects, even if you don’t have your own team of dedicated security engineers. You can read more about using QL and LGTM in variant analysis in the `Semmle blog <https://blog.semmle.com/tags/variant-analysis>`__.

Getting started with QL for variant analysis
============================================

The QL language is easy to learn, and exploring code using QL is the most efficient way to perform variant analysis. 

Start learning how to use QL in variant analysis for a specific language by looking at the topics below. Each topic provides links to short presentations on the QL language, QL libraries, and interesting vulnerabilities found using QL.

.. |arrow-l| unicode:: U+2190

.. |arrow-r| unicode:: U+2192

.. pull-quote:: 

   Information

   These presentations are used in QL language and variant analysis training sessions run by Semmle engineers. Therefore, be aware the slides are designed to be presented by an instructor.

   Use |arrow-l| and |arrow-r| to navigate between slides, press **p** to view additional notes for each slide (where available), and press **f** to enter full-screen mode.

QL and variant analysis for C/C++
=================================

- `Introduction to variant analysis: QL for C/C++ <../ql-training-rst/cpp/intro-ql-cpp.html>`__–an introduction to variant analysis and QL for C/C++ programmers.
- `Example: Bad overflow guard <../ql-training-rst/cpp/bad-overflow-guard.html>`__–
- `Program representation: QL for C/C++ <../ql-training-rst/cpp/program-representation-cpp.html>`__– 
- `Introduction to local data flow <../ql-training-rst/cpp/local-data-flow-cpp.html>`__–
- `Exercise: snprintf overflow <../ql-training-rst/cpp/snprintf.html>`__–
- `Introduction to global data flow <../ql-training-rst/cpp/global-data-flow-cpp.html>`__–
- `Analyzing control flow: QL for C/C++  <../ql-training-rst/cpp/control-flow-cpp.html>`__–

QL and variant analysis for Java
================================

- `Introduction to variant analysis: QL for Java <../ql-training-rst/java/intro-ql-java.html>`__–an introduction to variant analysis and QL for Java programmers.
- `Example: Query injection <../ql-training-rst/java/query-injection.html>`__–
- `Program representation: QL for Java <../ql-training-rst/java/program-representation-java.html>`__– 
- `Introduction to local data flow <../ql-training-rst/java/local-data-flow-java.html>`__–
- `Exercise: Apache Struts <../ql-training-rst/java/apache-struts-java.html>`__–
- `Introduction to global data flow <../ql-training-rst/java/global-data-flow-java.html>`__–

Other resources
===============

There is also `extensive documentation <https://help.semmle.com/QL/learn-ql>`__ available to help you learn QL. You can use the `interactive query console <https://lgtm.com/query>`__ on LGTM.com or the `QL for Eclipse plugin <https://lgtm.com/help/lgtm/running-queries-ide>`__ to try out your own queries on any of the open source projects that are currently on LGTM.

To read more about how QL queries have been used in Semmle's security research, and to read about new QL developments, visit the `Semmle blog <https://blog.semmle.com>`__. You can find examples of the queries written by Semmle's own security resesarchers in the `Semmle Demos repository <https://github.com/semmle/demos>`__ on GitHub.