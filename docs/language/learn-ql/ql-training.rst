TEST training and variant analysis examples
#############################################

Variant analysis using TEST
=============================

`Variant analysis <https://semmle.com/variant-analysis>`__ is the process of using a known vulnerability as a seed to find similar problems in your code. Security engineers typically perform variant analysis to identify possible vulnerabilities and to ensure that these threats are properly fixed across multiple code bases.

`TEST <https://semmle.com/ql>`__ is the query language used by Semmle's `variant analysis <https://semmle.com/variant-analysis>`__ engine, and it is also the technology that underpins LGTM, Semmle's community driven security analysis platform. Together, TEST and LGTM provide continuous monitoring and scalable variant analysis for your projects, even if you don’t have your own team of dedicated security engineers. You can read more about using TEST and LGTM in variant analysis in the `Semmle blog <https://blog.semmle.com/tags/variant-analysis>`__.

TEST is easy to learn, and exploring code using it is the most efficient way to perform variant analysis. 

Learning TEST for variant analysis
================================

Start learning how to use TEST in variant analysis for a specific language by looking at the topics below. Each topic links to a short presentation on the language, libraries, or an example variant discovered using TEST.

.. |arrow-l| unicode:: U+2190

.. |arrow-r| unicode:: U+2192

.. |info| unicode:: U+24D8

When you have selected a presentation, use |arrow-r| and |arrow-l| to navigate between slides.
Press **p** to view the additional notes on slides that have an information icon |info| in the top right corner, and press **f** to enter full-screen mode.

The presentations contain a number of examples.
We recommend that you download `QL for Eclipse <https://help.semmle.com/ql-for-eclipse/Content/WebHelp/home-page.html>`__ and import the example snapshot for each presentation so that you can find the bugs mentioned in the slides. 


.. pull-quote:: 

   Information

   The presentations listed below are used in TEST and variant analysis training sessions run by Semmle engineers. 
   Therefore, be aware that the slides are designed to be presented by an instructor. 
   If you are using the slides without an instructor, please use the additional notes to help guide you through the examples. 

TEST and variant analysis for C/C++
-------------------------------------

- `Introduction to variant analysis: TEST for C/C++ <../ql-training/cpp/intro-ql-cpp.html>`__–an introduction to variant analysis and TEST for C/C++ programmers.
- `Example: Bad overflow guard <../ql-training/cpp/bad-overflow-guard.html>`__–an example of iterative query development to find bad overflow guards in a C++ project.
- `Program representation: TEST for C/C++ <../ql-training/cpp/program-representation-cpp.html>`__–information on how TEST represents C/C++ programs. 
- `Introduction to local data flow <../ql-training/cpp/data-flow-cpp.html>`__–an introduction to analyzing local data flow in C/C++ using TEST, including an example demonstrating how to develop a query to find a real CVE.
- `Exercise: snprintf overflow <../ql-training/cpp/snprintf.html>`__–an example demonstrating how to develop a data flow query.
- `Introduction to global data flow <../ql-training/cpp/global-data-flow-cpp.html>`__–an introduction to analyzing global data flow in C/C++ using TEST.
- `Analyzing control flow: TEST for C/C++  <../ql-training/cpp/control-flow-cpp.html>`__–an introduction to analyzing control flow in C/C++ using TEST.

TEST and variant analysis for Java
------------------------------------

- `Introduction to variant analysis: TEST for Java <../ql-training/java/intro-ql-java.html>`__–an introduction to variant analysis and TEST for Java programmers.
- `Example: Query injection <../ql-training/java/query-injection-java.html>`__–an example of iterative query development to find unsanitized SPARQL injections in a Java project.
- `Program representation: TEST for Java <../ql-training/java/program-representation-java.html>`__–information on how TEST represents Java programs. 
- `Introduction to local data flow <../ql-training/java/data-flow-java.html>`__–an introduction to analyzing local data flow in Java using TEST, including an example demonstrating how to develop a query to find a real CVE.
- `Exercise: Apache Struts <../ql-training/java/apache-struts-java.html>`__–an example demonstrating how to develop a data flow query.
- `Introduction to global data flow <../ql-training/java/global-data-flow-java.html>`__–an introduction to analyzing global data flow in Java using QL.

More resources
--------------

- If you are completely new to TEST, look at our introductory topics in :ref:`Getting started <getting-started>`.
- To find more detailed information about how to write queries to analyze specific languages, visit the links in :ref:`Writing queries <writing-ql-queries>`.
- To read more about how TEST has been used in Semmle's security research, and to read about new developments, visit the `Semmle blog <https://blog.semmle.com>`__. 
- Find more examples of queries written by Semmle's own security researchers in the `Semmle Demos repository <https://github.com/semmle/demos>`__ on GitHub.
