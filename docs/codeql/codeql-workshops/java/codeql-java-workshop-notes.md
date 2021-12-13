# Java SQL Injection Workshop Notes 


## Second last slide 
- OWASP/SecurityShepherd - a web and mobile application security training platform created by OWASP. It has delibrate vulnerabilities in it for training and education purposes 
- Project composition - contains source directory, has a web application (src/main/java) written as servlets that act as the backend for this application. It also has some mobile applications for android with different vulnerabilities 
- We will be looking at CS injection today (Client Side injection) - SQL injection in an android application  
- Navigate to src/MobileShepherd/CSInjection/app/src/main/java/com/mobshep/csinjection
- Has two files so simple application. It is an android activity that takes some values from a field. It has an `EditText username` and  `EditText password` in CSInjection.java. Reads these fields from the activity and passes them into the `login` method. The `login` opens a `SQLLiteDatabase` so this is a database on the users mobile device and it constructs a query using string concatenation which then gets passed to `db.rawQuery`
- Therefore this is a potential SQL injection issue as there is no sanitisation of the username and password and is user controlled 
- Go to last slide and talk about source and sink 

## For sources 
- Choose method access by looking at the AST
- They are still calls but they are calls that have qualifiers 
- explain `hasQualifiedName(package, type, name) 
- We're going to use `hasQualifiedName` because it allows us to specify not just the name of the method but also the type and package.
- This is useful as `getText` is not very specific. There may be many methods in the program called getText() so we want to be specific

## VS Starter Workspace Notes
- CodeQL scans siblings of the installation directory (and their subdirectories) for qlpack.yml files. The metadata in the file tells CodeQL how to compile queries, what libraries the pack depends on, and where to find query suite definitions.

```ql
import java

//MethodAccess is a method Call is Java
//CodeQL is a relational language so we're thinking about it in terms of sets
// The variable ma is the set of all MethodAccess calls in the database
from MethodAccess ma
where ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText")
select ma
```

## For sink 
- It is the same as source 
- Explain that the sink is actually the first argument 

    ```ql
    import java

    from MethodAccess ma, VarAccess arg
    where ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
    arg  = ma.getArgument(0)
    select ma, arg
    ```
## Data flow 
- @id must be unique
- more info if they wanna read up on meta data - https://codeql.github.com/docs/writing-codeql-queries/metadata-for-codeql-queries/
- F12 to taint tracking and show them what they can extend
- This is basic dataflow query  -> they have source and sink. You can also specify things like sanitizers and additional taint steps
- Specify unique name in characteristic predicate
- Sanitizer - if you hit a certain thing in the program you can assume everything after this is safe
- Additional Taint steps - add extra flow nodes
- `instanceof` is in the set
- class in CodeQl represents a set of things
- `abstract class` is the union of all of its subclasses - The way that we define abstract classes is that we need to define subclasses of it
- Add source and sink. Run query and look confused when you get nothing back. Ask them why


```ql

/**
* @name SQL Injection in OWASP Security Shepard
* @kind problem
* @id java/sqlinjectionowasp
*/
	
import java
import semmle.code.java.dataflow.TaintTracking

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
from AndroidSQLInjection config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "SQL Injection"
```

## Additional Taint Step 

-By inspecting `String CheckName = username.getText().toString()` we can observe that the `toString()` is a method call on the return value of `getText()` which is an `Editable` type. Our current taint tracking analysis does not capture flow from the `Editable` object returned by `username.getText()` to `toString()`
- https://developer.android.com/reference/android/widget/EditText
- `.getQualifier` is saying the thing before the `toString()` dot
- why don't we use `hasQualifierName` on the `toString()`. The reason is that `toString()` returns an `Object` type so the Qualifier name is `Object.toString()`
- If we filter by qualifier name we will be adding flow for all `Object.toString()` and the result will be imprecise
- because not all `toString()` will propogate taint to the `Object.toString()`
- `node1` adding flow from Qualifier (Editable)
- `node2` is the return of the method
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

- I need to import `DataFlow::PartialPathGraph`
- I need to `  override int explorationLimit() { result = 5 }`
-  I need to quick eval predicate
-  I need to change to path-problem



```
///**
// * @name SQL Injection in OWASP Security Shepard
// * @kind path-problem
// * @id java/sqlinjectionowasp
// */
//import java
//import semmle.code.java.dataflow.TaintTracking
//import DataFlow::PartialPathGraph
//class AndroidSQLInjection extends TaintTracking::Configuration {
//  AndroidSQLInjection() { this = "AndroidSQLInjection" }
//  override predicate isSource(DataFlow::Node source) {
//    exists(MethodAccess ma |
//      ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText") and
//      source.asExpr() = ma
//    )
//  }
//  override int explorationLimit() { result = 5 }
//  override predicate isSink(DataFlow::Node sink) {
//    exists(MethodAccess ma |
//      ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
//      ma.getArgument(0) = sink.asExpr()
//    )
//  }
//}
//from AndroidSQLInjection config, DataFlow::PartialPathNode source, DataFlow::PartialPathNode sink
//where config.hasPartialFlowRev(_, sink, config.explorationLimit())
//select sink, source, sink, "hellow "
////Source
////String CheckName = userName.getText().toString();
////from MethodAccess ma
////where ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText")
////select ma
////Sink
////db.rawQuery(query, null);
////from MethodAccess ma, VarAccess arg
////where
////  ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
////  arg = ma.getArgument(0)
////select ma, arg
/**
 * @kind path-problem
 */

import java
import semmle.code.java.dataflow.TaintTracking
import DataFlow::PartialPathGraph

class AndroidSQLInjection extends TaintTracking::Configuration {
  AndroidSQLInjection() { this = "AndroidSQLInjection" }

  override predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("android.widget", "EditText", "getText") and
      source.asExpr() = ma
    )
  }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma |
      ma.getMethod().hasQualifiedName("net.sqlcipher.database", "SQLiteDatabase", "rawQuery") and
      node.asExpr() = ma.getArgument(0)
    )
  }

  override int explorationLimit() { result = 5 }
  // String CheckName = username.getText().toString();
  //                  \----methodAccess------------/
  //                  \--- qualifier---/ \-method--/	
  //  override predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  //    exists(MethodAccess ma |
  //      ma.getQualifier().getType().hasName("Editable") and
  //      ma.getMethod().hasName("toString") and
  //      node1.asExpr() = ma.getQualifier() and
  //      node2.asExpr() = ma
  //    )
  //  }
}

from AndroidSQLInjection config, DataFlow::PartialPathNode source, DataFlow::PartialPathNode sink
where config.hasPartialFlow(source, _, config.explorationLimit())
select config
```




Note that this stops at the source -- so we start expanding there via
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
and try again.

## Final Query
- convert to path problem
- select clause must have format select element, source, sink, string
- element is location of the alert, string is the message of the alert
- source sink are nodes on the path graph 

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

## Customizations

- I have my source and sink but how do I integrate it into the current queries 
- Navigate to SqlTaintedLocal.ql - representative of the common structure found in queries, they almost  all look like this 
- This is basic dataflow query  -> they have source and sink. You can also specify things like sanitizers and additional taint steps 
- We have  a number of queries to find default SQL injections in our queries. There are two which are most interesting `SqlTainted.ql` and `SqlTaintedLocal.ql`
- These are located in CWE-089 folder 
- SqlTainted.ql - is the query that find flow from remote sources of data so for example a network connection that provides this data.So this will be the query that is used for web servlets that receive untrusted data and submitting that to a SQL like API.
- SqlTaintedLocal.ql - this is supposed to find local sources of untrusted input and find SQL like sinks
- The reason they are seperate is because the threat model for remote versus local is different for each given database
- For example you may be less concerned by a SQL input via command line versus a remote flow source. Hence the speration and the different precisions. Local has medium precision and is generally less interesting
- Since the input from the Android application is local we would expect the result to be picked up from `SqlTaintedLocal.ql- If I run these queries I get not results back 
- There are two reasons: 
  - 1st - we don't find `String checkName = username.getText().toString()` to be a source to tained data in general.
  - The EditText is not a source of potentially tained data in the OOTB CodeQL library  
  - 2nd - The activity doesn't use the built in `SQLite` database but instead a wrapper around it from a company called `sqlcipher`and they do some form of encryption on the fly of the database. We support SQLite database as a sink but we don't support `net.sqlcipher` as a SQL sink
- For the reasons above we don't find the above vulnerability 

- Specify unique name in characteristic predicate
- Sanitizer - if you hit a certain thing in the program you can assume everything after this is safe
- Additional Taint steps - add extra flow nodes 
- `instanceof` is in the set 
- class in CodeQl represents a set of things 
- `abstract class` is the union of all of its subclasses - The way that we define abstract classes is that we need to define subclasses of it
- F12 to the source, and walk through some of the FlowSoures.qll 
- F12 ro the sink - navigate to SQLlite sink and see that it is out of the box 

```CodeQL
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
}
```


 
