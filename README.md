# Introduction
This repository contains material for teaching/learning CodeQL.  It supplements
the more general introductory material and the reference material by presenting
full solutions for specific problems.

The presentations are split by the programming language they present, currently
c++, csharp, go, java and javascript.

The directory structure for all recent additions is 

    language/project/content

Some older workshops are in single files, with directory structure

    language/project

The difficulty of these projects varies.  Further, some purely cover CodeQL
programming using an existing database while others include use of the command
line to create a database from code.

As a rough guide:
```
cpp
├── codeql-dataflow-sql-injection
├── codeql-workshop-cpp-bad-overflow-check.md
└── introduction
    ├── codeql-workshop-for-cpp.md
    ├── session-1
    ├── session-2
    ├── session-3
    └── session-4

csharp
├── codeql-workshop-csharp-unsafe-pointer-arithmetic.md
├── codeql-workshop-csharp-zipslip.md
└── top-down-vulnerability-guide.md

go
├── codeql-go-sqli
├── codeql-workshop-go-bad-redirect-check.md
├── oauth2-notes.org


java
├── Introduction\ to\ CodeQL\ -\ Java.pdf           | slide presentation 
├── codeql-java-workshop-notes.md                   | notes for presentation
├── apache-struts-online.txt                        |
├── codeql-java-workshop-sqlinjection.md            | sql injection OWASP Security Shepherd
├── java-unsafe-deserialization.md                  | lecture notes
├── unsafe-deserialization-apache-struts.md         | unsafe deserialization, compact, intermediate, db build
└── workshop-java-mismatched-loop-condition.md      |

javascript
├── codeql-js-goof-workshop  | Full example illustrating all the steps, beginner, db build, source build
├── codeql-workshop-javascript-unsafe-jquery-calls.md | pure codeql, beginner 

python
└── codeql-dataflow-sql-injection | Full example, beginner, db build, source build
```

# Status & Roadmap
These are actively developed and used workshops.  We are planning to add
intermediate and advanced material as time permits.

# Setup and running
Currently all projects require installing VS Code and the CodeQL plugin.  They can
be run on linux, macOS, and Windows.  Some additionally require the CodeQL command
line tools.  See the individual project's instructions, or 
[./common/cli-for-codeql.org](here for the cli) and 
[./common/vscode-for-codeql.org](here for VS Code).

# Contributing
New tutorials should use the `language/project/content` structure to allow for
expansion.  Primary focus should be on learning and explaining CodeQL and the
content should cover at least these items:
1. A high-level problem description
2. the specific parts of the original source code to be analyzed 
3. descriptions of the codeql predicates / classes developed
4. a description of the final query





