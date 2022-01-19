CodeQL training and variant analysis examples
=============================================

CodeQL and variant analysis
---------------------------

Variant analysis is the process of using a known vulnerability as a seed to find similar problems in your code. Security engineers typically perform variant analysis to identify possible vulnerabilities and to ensure that these threats are properly fixed across multiple code bases.

CodeQL is the code analysis engine that underpins LGTM, the community driven security analysis platform. Together, CodeQL and LGTM provide continuous monitoring and scalable variant analysis for your projects, even if you don’t have your own team of dedicated security engineers. You can read more about using CodeQL and LGTM in variant analysis on the `Security Lab research page <https://securitylab.github.com/research>`__.

CodeQL is easy to learn, and exploring code using CodeQL is the most efficient way to perform variant analysis. 

Learning CodeQL for variant analysis
------------------------------------

Start learning how to use CodeQL in variant analysis for a specific language by looking at the topics below. Each topic links to a short presentation on CodeQL, its libraries, or an example variant discovered using CodeQL.

.. |arrow-l| unicode:: U+2190

.. |arrow-r| unicode:: U+2192

.. |info| unicode:: U+24D8

When you have selected a presentation, use |arrow-r| and |arrow-l| to navigate between slides.
Press **p** to view the additional notes on slides that have an information icon |info| in the top right corner, and press **f** to enter full-screen mode.

The presentations contain a number of query examples.
We recommend that you download `CodeQL for Visual Studio Code <https://codeql.github.com/docs/codeql-for-visual-studio-code/>`__ and add the example database for each presentation so that you can find the bugs mentioned in the slides. 


.. pull-quote:: 

   Information

   The presentations listed below are used in CodeQL and variant analysis training sessions run by GitHub engineers. 
   Therefore, be aware that the slides are designed to be presented by an instructor. 
   If you are using the slides without an instructor, please use the additional notes to help guide you through the examples. 

CodeQL and variant analysis for C/C++
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- `Introduction to variant analysis: CodeQL for C/C++ </QL/ql-training/cpp/intro-ql-cpp.html>`__–an introduction to variant analysis and CodeQL for C/C++ programmers.
- `Example: Bad overflow guard </QL/ql-training/cpp/bad-overflow-guard.html>`__–an example of iterative query development to find bad overflow guards in a C++ project.
- `Program representation: CodeQL for C/C++ </QL/ql-training/cpp/program-representation-cpp.html>`__–information on how CodeQL analysis represents C/C++ programs. 
- `Introduction to local data flow </QL/ql-training/cpp/data-flow-cpp.html>`__–an introduction to analyzing local data flow in C/C++ using CodeQL, including an example demonstrating how to develop a query to find a real CVE.
- `Exercise: snprintf overflow </QL/ql-training/cpp/snprintf.html>`__–an example demonstrating how to develop a data flow query.
- `Introduction to global data flow </QL/ql-training/cpp/global-data-flow-cpp.html>`__–an introduction to analyzing global data flow in C/C++ using CodeQL.
- `Analyzing control flow: CodeQL for C/C++  </QL/ql-training/cpp/control-flow-cpp.html>`__–an introduction to analyzing control flow in C/C++ using CodeQL.

CodeQL and variant analysis for Java
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- `Introduction to variant analysis: CodeQL for Java </QL/ql-training/java/intro-ql-java.html>`__–an introduction to variant analysis and CodeQL for Java programmers.
- `Example: Query injection </QL/ql-training/java/query-injection-java.html>`__–an example of iterative query development to find unsanitized SPARQL injections in a Java project.
- `Program representation: CodeQL for Java </QL/ql-training/java/program-representation-java.html>`__–information on how CodeQL analysis represents Java programs. 
- `Introduction to local data flow </QL/ql-training/java/data-flow-java.html>`__–an introduction to analyzing local data flow in Java using CodeQL, including an example demonstrating how to develop a query to find a real CVE.
- `Exercise: Apache Struts </QL/ql-training/java/apache-struts-java.html>`__–an example demonstrating how to develop a data flow query.
- `Introduction to global data flow </QL/ql-training/java/global-data-flow-java.html>`__–an introduction to analyzing global data flow in Java using CodeQL.

Further reading
~~~~~~~~~~~~~~~

- `GitHub Security Lab <https://securitylab.github.com/research>`__
