# CodeQL workshop for Java: SQL Injection

- Analyzed language: Java 

## Overview

 - [Problem statement](#problemstatement)
 - [Setup instructions](#setupinstructions)
 - [Documentation Links](#documentationlinks)
 - [Workshop](#workshop)
   - [Section 1: Finding Sources - Method Calls to getText()](#section1)
   - [Section 2: Finding Sinks - Method Calls to rawQuery](#section2)
   - [Section 3: Data Flow](#section3)
   - [Section 4: Adding Additional Taint Steps](#section4)
   - [Section 5: Final Query](#section5)
   - [Section 6 - Extending default queries](#section6)
 - [What's next](#whatsnext)

## Problem statement <a id="problemstatement"></a>
In this workshop, we will write a query to find a SQL injection vulnerabilities (CWE-089) in a database built from the Security Shephard repository maintained by OWASP. This repository is generally used for training and education purposes. We will be looking at client side injection in an Android application. The vulnerability arises from an Android Activity that takes in user input values via multiple fields. It reads these fields via the activity and passes them into the `login` method. This method opens a SQLite database on the users device and it constructs a query using string concatenation which it then passes to the `rawQuery` method that eventually gets executed on the databate. There is no sanitization so there exists a potential SQL injection vulnerability inside this applicatiion. 

**Source**

`String CheckName = userName.getText().toString();`

**Sink**

`db.rawQuery(query, null);`

## Setup instructions for Visual Studio Code <a id="setupinstructions"></a>

To take part in the workshop you will need to follow these steps to get the CodeQL development environment setup:

1. Install the Visual Studio Code IDE.
2. Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
3. [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    -   ****Important****: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
4. Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.
5. Download and unzip the [OWASP Mobile Shepard CodeQL database](https://drive.google.com/file/d/10hx6RR3BHJ4-uy4AVnUZphaNBxfGpweQ/view?usp=sharing).
6. Choose this database in CodeQL (using `Ctrl + Shift + P` to open the command palette, then selecting "CodeQL: Choose Database").
7. Create a new file in the `codeql-custom-queries-java` directory called `sqlinjection-workshop.ql`.

## Documentation links <a id="documentationlinks"></a>
If you get stuck, try searching our documentation and blog posts for help and ideas. Below are a few links to help you get started:
- [Learning CodeQL](https://help.semmle.com/QL/learn-ql)
- [Learning CodeQL for Java](https://help.semmle.com/QL/learn-ql/cpp/ql-for-java.html)
- [Using the CodeQL extension for VS Code](https://help.semmle.com/codeql/codeql-for-vscode.html)




## Workshop <a id="workshop"></a>

The workshop is split into several steps. You can write one query per step, or work with a single query that you refine at each step. Each step has a **hint** that describes useful classes and predicates in the CodeQL standard libraries for Java. You can explore these in your IDE using the autocomplete suggestions (`Ctrl + Space`) and the jump-to-definition command (`F12`).

### Section 1: Finding Sources - Method Calls to getText()  <a id="section1"></a>

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
1. The `rawQuery` method sends the SQL query which is first argument (i.e the argument at index 0) to the database. Update your query to report this argument. 
  
    <details>
    <summary>Hint</summary>

    - `MethodCall.getArgument(int i)` returns the argument at the i-th index.
    - The arguments are _expressions_ in the program, represented by the CodeQL class `Expr`. Introduce a new variable to hold the argument expression.
    - `VarAccess` is a reference to a field, parameter or local variable

    </details>
    <details>
    <summary>Solution</summary>
	
    ```ql
    import java

    from MethodAccess ma, VarAccess arg
    where ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
    arg  = ma.getArgument(0)
    select ma, arg
    ```
    </details>

### Section 3: Data Flow  <a id="section3"></a>

We have now identified (a) places in the program which receive untrusted data and (b) places in the program which potentially trigger malicious SQL queries.. We now want to tie these two together to ask: does the untrusted data ever _flow_ to the potentially unsafe SQL query call?

In program analysis we call this a _data flow_ problem. Data flow helps us answer questions like: does this expression ever hold a value that originates from a particular other place in the program?

We can visualize the data flow problem as one of finding paths through a directed graph, where the nodes of the graph are elements in program, and the edges represent the flow of data between those elements. If a path exists, then the data flows between those two nodes.

CodeQL for Java provides data flow analysis as part of the standard library. You can import it using `semmle.code.java.dataflow.DataFlow`. The library models nodes using the `DataFlow::Node` CodeQL class. These nodes are separate and distinct from the AST (Abstract Syntax Tree, which represents the basic structure of the program) nodes, to allow for flexibility in how data flow is modeled.

There are a small number of data flow node types – expression nodes and parameter nodes are most common.

In this section we will create a data flow query by populating this template:

```ql
/**
* @name SQL Injection in OWASP Security Shepard
* @kind problem
* @id java/sqlinjectionowasp
*/
	
import java
import semmle.code.java.dataflow.DataFlow


class AndroidSQLInjection extends TaintTracking::Configuration {
	AndroidSQLInjection() { this = "AndroidSQLInjection" }
	// TODO add previous class and predicate definitions here
	override predicate isSource(DataFlow::Node source) {
		exists(/** TODO fill me in **/ |
      		source.asExpr() = /** TODO fill me in **/     
		)
	}
 	 
  	override predicate isSink(DataFlow::Node sink) {
		exists(/** TODO fill me in **/ |
     		 /** TODO fill me in **/
		      sink.asExpr() = /** TODO fill me in **/     
		      )
		}
	}
}
from AndroidSQLInjection config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, source, sink, "SQL Injection"
  ```

1. Complete the `isSource` predicate using the query you wrote previously

    <details>
    <summary>Hint</summary>

    - You can translate from a query clause to a predicate by:
       - Converting the variable declarations in the `from` part to the variable declarations of an `exists`
       - Placing the `where` clause conditions (if any) in the body of the exists
       - Adding a condition which equates the `select` to one of the parameters of the predicate.
   
    </details>
    <details>
    <summary>Solution</summary>

    ```ql
      override predicate isSource(DataFlow::Node node) {
        exists(MethodAccess ma |
          ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText") and
          node.asExpr() = ma
        )
      }
     ```
    </details>

1. Complete the `isSink` predicate 
    <details>
    <summary>Hint</summary>
      `Complete the same process as above.`
   </details>
   <details>
    <summary>Solution</summary>

     ```ql
      override predicate isSink(DataFlow::Node node) {
          exists(MethodAccess ma |
              ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
              node.asExpr() = ma.getArgument(0)
       	  )
       }
     ```
  </details>


You can now run the completed query. What results did you get? Was it what you were expecting? 

### Section 4: Adding Additional Taint Steps <a id="section4"></a>
Sometimes the data flow or taint tracking analysis will not be aware that data may flow through a particular code pattern or function call. It is conservative by default, to keep results precise.

We can add additional problem-specific steps if necessary, by implementing the `isAdditionalTaintStep` predicate on our `TaintTracking::Configuration` subclass.

By inspecting `String CheckName = username.getText().toString()` we can observe that the `toString()` is a method call on the return value of `getText()` which is an `Editable` type. Our current taint tracking analysis does not capture flow from the `Editable` object returned by `username.getText()` to `toString()`

As alternative, we can just check all flows from a source:
```codeql
import java
import semmle.code.java.dataflow.TaintTracking

class AndroidSQLInjection extends TaintTracking::Configuration {
    AndroidSQLInjection() { this = "AndroidSQLInjection" }

    override predicate isSource(DataFlow::Node node) {
        exists(MethodAccess ma |
            ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText") and
            node.asExpr() = ma
        )
    }

    override predicate isSink(DataFlow::Node sink) { any() }
}

from AndroidSQLInjection config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, source, sink, "SQL Injection"
```

Note that this stops at the source -- so we start expanding there via
```codeql


    override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
        exists(MethodAccess ma |
            ma.getQualifier().getType().hasName(["Editable", "EditText"]) and
            ma.getMethod().hasName("toString") and
            node1.asExpr() = ma.getQualifier() and
            node2.asExpr() = ma
        )
    }
```
and try again.


(If you are using `DataFlow::Configuration`, this predicate is called `isAdditionalFlowStep` instead.
  <details>
  <summary>Solution</summary>
	
 ```codeql
 // String CheckName = username.getText().toString();
 //                  \----methodAccess------------/
 //                  \--- qualifier---/ \-method--/	
  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
	exists(MethodAccess ma |	 
		ma.getQualifier().getType().hasName(["Editable", "EditText"]) and
	     	ma.getMethod().hasName("toString") and
	      	node1.asExpr() = ma.getQualifier() and
	      	 node2.asExpr() = ma
	       )
        }
  ```
  </details>

### Section 5: Final Query <a id="section5"></a>

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
	* @name SQL Injection in OWASP Security Shepard
	* @kind problem
	* @id java/sqlinjectionowasp
	*/

	import java
	import semmle.code.java.dataflow.TaintTracking
	import DataFlow::PathGraph

	class AndroidSQLInjection extends TaintTracking::Configuration {
	  AndroidSQLInjection() { this = "AndroidSQLInjection" }

	  override predicate isSource(DataFlow::Node node) {
	    exists(MethodAccess ma |
	      ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText") and
	      node.asExpr() = ma
	    )
	  }

	  override predicate isSink(DataFlow::Node node) {
	    exists(MethodAccess ma |
	      ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
	      node.asExpr() = ma.getArgument(0)
	    )
	  }

	  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
	    exists(MethodAccess ma |
	      ma.getQualifier().getType().hasName(["Editable", "EditText"]) and
	      ma.getMethod().hasName("toString") and
	      node1.asExpr() = ma.getQualifier() and
	      node2.asExpr() = ma
	    )
	  }
	}

	from AndroidSQLInjection config, DataFlow::PathNode source, DataFlow::PathNode sink
	where config.hasFlowPath(source, sink)
	select sink, source, sink, "SQL Injection"

	```
    </details>

### Section 6 - Extending default queries <a id="section6"></a>

Although we have created a query from scratch to find this problem, we can also extend our default SQL Injection queries, [SqlTaintedLocal.ql](https://github.com/github/codeql/blob/main/java/ql/src/Security/CWE/CWE-089/SqlTaintedLocal.ql) and [SqlTainted.ql](https://github.com/github/codeql/blob/main/java/ql/src/Security/CWE/CWE-089/SqlTainted.ql) to capture these sources and sinks. This is done by implementing the file [Customizations.qll](https://github.com/github/codeql/blob/main/java/ql/src/Customizations.qll) located at the root of the CodeQL repository.  

Like predicates, _classes_ in CodeQL can be used to encapsulate reusable portions of logic. Classes represent single sets of values, and they can also include operations (known as _member predicates_) specific to that set of values. You have already seen numerous instances of CodeQL classes (`MethodAccess`, `Method` etc.) and associated member predicates (`MethodAccess.getMethod()`, `Method.getName()`, etc.).

  <details>
  <summary>Solution</summary>

  ```ql
	
		import java
		import semmle.code.java.security.QueryInjection
		import semmle.code.java.dataflow.FlowSources

		class EditTextLocalSource extends LocalUserInput {
		  EditTextLocalSource() {
		    exists(MethodAccess ma |
		      ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText") and
		      this.asExpr() = ma
		    )
		  }
		}

		class SqlCipherRawQuery extends QueryInjectionSink {
		  SqlCipherRawQuery() {
		    exists(MethodAccess ma |
		      ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
		      this.asExpr() = ma.getArgument(0)
		    )
		  }
		}

		class ToStringStep extends AdditionalQueryInjectionTaintStep {
		  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
		    exists(MethodAccess ma |
		      ma.getQualifier().getType().hasName(["Editable", "EditText"]) and
		      ma.getMethod().hasName("toString") and
		      node1.asExpr() = ma.getQualifier() and
		      node2.asExpr() = ma
		    )
		  }

  ```
  </details>


## What's next? <a id="whatsnext"></a>
- Read the [tutorial on analyzing data flow in Java](https://help.semmle.com/QL/learn-ql/java/dataflow.html).
- Go through more [CodeQL training materials for Java](https://help.semmle.com/QL/learn-ql/ql-training.html#codeql-and-variant-analysis-for-java).
- Try out the latest CodeQL Java Capture-the-Flag challenge on the [GitHub Security Lab website](https://securitylab.github.com/ctf) for a chance to win a prize! Or try one of the older Capture-the-Flag challenges to improve your CodeQL skills.
- Try out a CodeQL course on [GitHub Learning Lab](https://lab.github.com/githubtraining/codeql-u-boot-challenge-(cc++)).
- Read about more vulnerabilities found using CodeQL on the [GitHub Security Lab research blog](https://securitylab.github.com/research).
- Explore the [open-source CodeQL queries and libraries](https://github.com/github/codeql), and [learn how to contribute a new query](https://github.com/github/codeql/blob/master/CONTRIBUTING.md)
