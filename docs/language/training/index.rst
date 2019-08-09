QL training
###########

Introduction to variant analysis with QL
========================================

`Variant analysis <https://semmle.com/variant-analysis>`__ is the process of using a known vulnerability as a seed to find similar problems in your code. Security engineers typically perform variant analysis to identify possible vulnerabilities and to ensure these threats are properly fixed across multiple code bases.

`QL <https://semmle.com/ql>`__ is Semmle's variant analysis engine, and it is also the technology that underpins LGTM, Semmle's community driven security analysis platform. Together, QL and LGTM provide continuous monitoring and scalable variant analysis for your projects, even if you don’t have your own team of dedicated security engineers. You can read more about using QL and LGTM in variant analysis in the `Semmle blog <https://blog.semmle.com/tags/variant-analysis>`__.

Getting started with QL for variant analysis
============================================

The QL language is easy to learn, and exploring code using QL is the most efficient way to perform variant analysis. 

Start learning how to use QL in variant analysis by working through the topics below, taking a look at `Learning QL <https://help.semmle.com/QL/learn-ql>`__, or by browsing Semmle's standard QL libraries and queries, which are avaliable in our `open source repository on GitHub <https://github.com/semmle/ql>`__.

Each topic below contains a short presentation on the QL language. Examples featured in the slides explain how to write QL queries. In each topic, you can also find links to useful technical information about the QL language, QL language tutorials, and examples of QL queries that were used to find variants of security vulnerabilities in open source projects. 

QL for C/C++
------------

- `Introduction to QL for C/C++ <https://docs.google.com/presentation/d/e/2PACX-1vR1-TRNlyhQhm3TB6WO1DgURmwuNtcXMlgrwPQ8SflN0ywBhjePxZi6K7DLexXqOP4xkIKS9ar3d-kL/pub?start=false&loop=false&delayms=3000>`__–an introduction to the QL language for C/C++ programmers.

QL for Java
------------

- `Introduction to QL for Java <https://docs.google.com/presentation/d/e/2PACX-1vSuPW87dRWsIHwbH2VvfWEmodFXTwbQVlP71rSAA-IpYBbBGEoOJFbVRbhtwoqObmBMrzKxgB2D1zkb/pub?start=false&loop=false&delayms=3000>`__–an introduction to the QL language for Java programmers.

Other resources
===============

To read more about how QL queries have been used in Semmle's security research, and to read about new QL developments, visit the `Semmle blog <https://blog.semmle.com>`__. You can find examples of the queries written by Semmle's own security resesarchers in the `Semmle Demos repository <https://github.com/semmle/demos>`__ on GitHub.

There is also `extensive documentation <https://help.semmle.com/QL/learn-ql>`__ available to help you learn QL. You can use the `interactive query console <https://lgtm.com/query>`__ on LGTM.com or the `QL for Eclipse plugin <https://lgtm.com/help/lgtm/running-queries-ide>`__ to try out your own queries on any of the open source projects that are currently on LGTM.