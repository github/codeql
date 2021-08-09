# CodeQL workshop for Java: SQL Injection

- Analyzed language: Java 

## Overview

 - [Problem statement](#problemstatement)
 - [Setup instructions](#setupinstructions)
 - [Documentation links](#documentationlinks)
 - [Workshop](#workshop)
   - [Section 1: Finding XML deserialization](#section1)
   - [Section 2: Find the implementations of the `toObject` method from ContentTypeHandler](#section2)
   - [Section 3: Unsafe XML deserialization](#section3)

## Problem statement <a id="problemstatement"></a>
In this workshop, we will write a query to find CVE-2017-9805 in a database built from the known vulnerable version of Apache Struts.

## Setup instructions for Visual Studio Code <a id="setupinstructions"></a>

## Workshop <a id="workshop"></a>

The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describes useful classes and predicates in the CodeQL standard libraries for Java. You can explore these in your IDE using the autocomplete suggestions (`Ctrl + Space`) and the jump-to-definition command (`F12`).

### Section 1: Finding Sources - Method Calls to getText()  <a id="section1"></a>
Blurb aboout Android framwork

 1. Find all method calls in the program.
    <details>
    <summary>Hint</summary>

    - A method call is represented by the `MethodAccess` type in the CodeQL Java library.

    </details>
    <details>
    <summary>Solution</summary>

    ```ql
    import java

    from MethodAccess ma
    select ma
    ```
    </details>

 1. Find all the calls in the program to methods called `getText`
    <details>
    <summary>Hints</summary>

    - `MethodAccess` has a predicate called `getMethod()` for returning the method.
    - Add a `where` clause.

    </details>
    <details>
    <summary>Solution</summary>

    ```ql
    import java

    from MethodAccess call
    where ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText") 
    select ma
    ```
    </details>

### Section 2: Finding Sinks - Method Calls to rawQuery  <a id="section2"></a>
 1. Find all the calls in the program to methods called `rawQuery`

    ```ql
    import java

    from MethodAccess call
    where ma.getMethod().hasQualifiedName(net.sqlcipher.databaset", "SQLLiteDatabase", "rawQuery")
    select ma
    ```
1. The `rawQuery` method sends the SQL query which is first argument (i.e the argument at index 0) to the database. Update your query to report the sql argument. 
  
    <details>
    <summary>Hint</summary>

    - `MethodCall.getArgument(int i)` returns the argument at the i-th index.
    - The arguments are _expressions_ in the program, represented by the CodeQL class `Expr`. Introduce a new variable to hold the argument expression.

    </details>
    <details>
    <summary>Solution</summary>

    ```ql
    import java

    from MethodAccess fromXML, Expr arg
    where
      fromXML.getMethod().getName() = "fromXML" and
      arg = fromXML.getArgument(0)
    select fromXML, arg
    ```
    </details>


Like predicates, _classes_ in CodeQL can be used to encapsulate reusable portions of logic. Classes represent single sets of values, and they can also include operations (known as _member predicates_) specific to that set of values. You have already seen numerous instances of CodeQL classes (`MethodAccess`, `Method` etc.) and associated member predicates (`MethodAccess.getMethod()`, `Method.getName()`, etc.).
### Section 3: Unsafe XML deserialization <a id="section3"></a>

We have now identified (a) places in the program which receive untrusted data and (b) places in the program which potentially perform unsafe XML deserialization. We now want to tie these two together to ask: does the untrusted data ever _flow_ to the potentially unsafe XML deserialization call?

In program analysis we call this a _data flow_ problem. Data flow helps us answer questions like: does this expression ever hold a value that originates from a particular other place in the program?

We can visualize the data flow problem as one of finding paths through a directed graph, where the nodes of the graph are elements in program, and the edges represent the flow of data between those elements. If a path exists, then the data flows between those two nodes.

Consider this example Java method:

```c
int func(int tainted) {
   int x = tainted;
   if (someCondition) {
     int y = x;
     callFoo(y);
   } else {
     return x;
   }
   return -1;
}
```
The data flow graph for this method will look something like this:

<img src="https://help.semmle.com/QL/ql-training/_images/graphviz-2ad90ce0f4b6f3f315f2caf0dd8753fbba789a14.png" alt="drawing" width="260"/>

This graph represents the flow of data from the tainted parameter. The nodes of graph represent program elements that have a value, such as function parameters and expressions. The edges of this graph represent flow through these nodes.

CodeQL for Java provides data flow analysis as part of the standard library. You can import it using `semmle.code.java.dataflow.DataFlow`. The library models nodes using the `DataFlow::Node` CodeQL class. These nodes are separate and distinct from the AST (Abstract Syntax Tree, which represents the basic structure of the program) nodes, to allow for flexibility in how data flow is modeled.

There are a small number of data flow node types – expression nodes and parameter nodes are most common.

In this section we will create a data flow query by populating this template:

```ql
/**
 * @name Unsafe XML deserialization
 * @kind problem
 * @id java/unsafe-deserialization
 */
import java
import semmle.code.java.dataflow.DataFlow

// TODO add previous class and predicate definitions here

class StrutsUnsafeDeserializationConfig extends DataFlow::Configuration {
  StrutsUnsafeDeserializationConfig() { this = "StrutsUnsafeDeserializationConfig" }
  override predicate isSource(DataFlow::Node source) {
    exists(/** TODO fill me in **/ |
      source.asParameter() = /** TODO fill me in **/
    )
  }
  override predicate isSink(DataFlow::Node sink) {
    exists(/** TODO fill me in **/ |
      /** TODO fill me in **/
      sink.asExpr() = /** TODO fill me in **/
    )
  }
}

from StrutsUnsafeDeserializationConfig config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "Unsafe XML deserialization"
```

 1. Complete the `isSource` predicate using the query you wrote for [Section 2](#section2).

    <details>
    <summary>Hint</summary>

    - You can translate from a query clause to a predicate by:
       - Converting the variable declarations in the `from` part to the variable declarations of an `exists`
       - Placing the `where` clause conditions (if any) in the body of the exists
       - Adding a condition which equates the `select` to one of the parameters of the predicate.
    - Remember to include the `ContentTypeHandlerToObject` class you defined earlier.

    </details>
    <details>
    <summary>Solution</summary>

    ```ql
      override predicate isSource(Node source) {
        exists(ContentTypeHandlerToObject toObjectMethod |
          source.asParameter() = toObjectMethod.getParameter(0)
        )
      }
    ```
    </details>

 1. Complete the `isSink` predicate by using the final query you wrote for [Section 1](#section1). Remember to use the `isXMLDeserialized` predicate!
    <details>
    <summary>Hint</summary>

    - Complete the same process as above.

    </details>
    <details>
    <summary>Solution</summary>

    ```ql
      override predicate isSink(Node sink) {
        exists(Expr arg |
          isXMLDeserialized(arg) and
          sink.asExpr() = arg
        )
      }
    ```
    </details>

You can now run the completed query. You should find exactly one result, which is the CVE reported by our security researchers in 2017!

For this result, it is easy to verify that it is correct, because both the source and sink are in the same method. However, for many data flow problems this is not the case.

We can update the query so that it not only reports the sink, but it also reports the source and the path to that source. We can do this by making these changes:
The answer to this is to convert the query to a _path problem_ query. There are five parts we will need to change:
 - Convert the `@kind` from `problem` to `path-problem`. This tells the CodeQL toolchain to interpret the results of this query as path results.
 - Add a new import `DataFlow::PathGraph`, which will report the path data alongside the query results.
 - Change `source` and `sink` variables from `DataFlow::Node` to `DataFlow::PathNode`, to ensure that the nodes retain path information.
 - Use `hasFlowPath` instead of `hasFlow`.
 - Change the select to report the `source` and `sink` as the second and third columns. The toolchain combines this data with the path information from `PathGraph` to build the paths.

 3. Convert your previous query to a path-problem query.
    <details>
    <summary>Solution</summary>

    ```ql
    /**
    * @name Unsafe XML deserialization
    * @kind path-problem
    * @id java/unsafe-deserialization
    */
    import java
    import semmle.code.java.dataflow.DataFlow
    import DataFlow::PathGraph

    predicate isXMLDeserialized(Expr arg) {
      exists(MethodAccess fromXML |
        fromXML.getMethod().getName() = "fromXML" and
        arg = fromXML.getArgument(0)
      )
    }

    /** The interface `org.apache.struts2.rest.handler.ContentTypeHandler`. */
    class ContentTypeHandler extends RefType {
      ContentTypeHandler() {
        this.hasQualifiedName("org.apache.struts2.rest.handler", "ContentTypeHandler")
      }
    }

    /** A `toObject` method on a subtype of `org.apache.struts2.rest.handler.ContentTypeHandler`. */
    class ContentTypeHandlerToObject extends Method {
      ContentTypeHandlerToObject() {
        this.getDeclaringType().getASupertype() instanceof ContentTypeHandler and
        this.hasName("toObject")
      }
    }

    class StrutsUnsafeDeserializationConfig extends DataFlow::Configuration {
      StrutsUnsafeDeserializationConfig() { this = "StrutsUnsafeDeserializationConfig" }
      override predicate isSource(DataFlow::Node source) {
        exists(ContentTypeHandlerToObject toObjectMethod |
          source.asParameter() = toObjectMethod.getParameter(0)
        )
      }
      override predicate isSink(DataFlow::Node sink) {
        exists(Expr arg |
          isXMLDeserialized(arg) and
          sink.asExpr() = arg
        )
      }
    }

    from StrutsUnsafeDeserializationConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
    where config.hasFlowPath(source, sink)
    select sink, source, sink, "Unsafe XML deserialization"
    ```
    </details>

For more information on how the vulnerability was identified, you can read the [blog disclosing the original problem](https://securitylab.github.com/research/apache-struts-vulnerability-cve-2017-9805).

Although we have created a query from scratch to find this problem, it can also be found with one of our default security queries, [UnsafeDeserialization.ql](https://github.com/github/codeql/blob/master/java/ql/src/Security/CWE/CWE-502/UnsafeDeserialization.ql). You can see this on a [vulnerable copy of Apache Struts](https://github.com/m-y-mo/struts_9805) that has been [analyzed on LGTM.com](https://lgtm.com/projects/g/m-y-mo/struts_9805/snapshot/31a8d6be58033679a83402b022bb89dad6c6e330/files/plugins/rest/src/main/java/org/apache/struts2/rest/handler/XStreamHandler.java?sort=name&dir=ASC&mode=heatmap#x121788d71061ed86:1), our free open source analysis platform.

## What's next?
- Read the [tutorial on analyzing data flow in Java](https://help.semmle.com/QL/learn-ql/java/dataflow.html).
- Go through more [CodeQL training materials for Java](https://help.semmle.com/QL/learn-ql/ql-training.html#codeql-and-variant-analysis-for-java).
- Try out the latest CodeQL Java Capture-the-Flag challenge on the [GitHub Security Lab website](https://securitylab.github.com/ctf) for a chance to win a prize! Or try one of the older Capture-the-Flag challenges to improve your CodeQL skills.
- Try out a CodeQL course on [GitHub Learning Lab](https://lab.github.com/githubtraining/codeql-u-boot-challenge-(cc++)).
- Read about more vulnerabilities found using CodeQL on the [GitHub Security Lab research blog](https://securitylab.github.com/research).
- Explore the [open-source CodeQL queries and libraries](https://github.com/github/codeql), and [learn how to contribute a new query](https://github.com/github/codeql/blob/master/CONTRIBUTING.md)
