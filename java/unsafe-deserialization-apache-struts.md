- [Unsafe Deserialization Demo: Apache struts](#org6695b9f)
    - [Reference material](#org26c9ce6)
    - [Setup instructions for Visual Studio Code](#org89e340c)
    - [Creating the database from a project](#orge8c9e69)
    - [The Demonstration](#org3267c27)


<a id="org6695b9f"></a>

# Unsafe Deserialization Demo: Apache struts

Short link for this summary: <https://git.io/JfkGY>


<a id="org26c9ce6"></a>

## Reference material

Blog describing the problem: <https://securitylab.github.com/research/apache-struts-CVE-2018-11776>

Clone of the original Struts repository with the vulnerability:
- External: <https://lgtm.com/projects/g/mmosemmle/struts_9805>
- Internal: <https://github.com/github/codeql-demo-struts-CVE-2017-9805>

LGTM query console: <https://lgtm.com/query/project:1510734246425/lang:javascript/>

codeql cli reference: <https://codeql.github.com/docs/codeql-cli/creating-codeql-databases>

codeql setup for VS code: <https://gist.github.com/adityasharad/a0b1d0a73e959249d78bd1efd4daf4ef#setup-instructions>

9-minute youtube video <https://www.youtube.com/watch?v=XsUcSd75K00>


<a id="org89e340c"></a>

## Setup instructions for Visual Studio Code

To run CodeQL queries offline, follow these steps:

1.  Install the Visual Studio Code IDE.
2.  Download and install the [CodeQL extension for Visual Studio Code](https://help.semmle.com/codeql/codeql-for-vscode.html). Full setup instructions are [here](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html).
3.  [Set up the starter workspace](https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html#using-the-starter-workspace).
    -   ****Important****: Don't forget to `git clone --recursive` or `git submodule update --init --remote`, so that you obtain the standard query libraries.
4.  Open the starter workspace: File > Open Workspace > Browse to `vscode-codeql-starter/vscode-codeql-starter.code-workspace`.


<a id="orge8c9e69"></a>

## Obtaining a database of the vulnerable code

There are two options here: you can obtain a pre-built database from downloads.lgtm.com or lgtm.com, or you can build your own with the CodeQL CLI.

### Downloading a pre-built database
- Download and unzip the database at https://downloads.lgtm.com/snapshots/java/apache/struts/apache-struts-91ae344-CVE-2017-9805.zip OR
- Log in to LGTM.com, go to https://lgtm.com/projects/g/m-y-mo/struts_9805/ci, scroll down to **CodeQL databases for local analysis**, and click to download the latest database for Java.

### Creating a database with the CodeQL CLI

The setup procedure using the `/bin/bash` shell, with one deviation from the reference manual: using `mvn clean compile` instead of `mvn clean install`.

```sh
# Get maven (mvn) and ant
brew install maven ant
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"

# Install CodeQL via brew
#     Add the tap to your homebrew install
brew tap github/codeql-cli git@github.com:github/homebrew-codeql-cli.git
#     Install CodeQL
brew cask install codeql-cli

# Install CodeQL manually from https://github.com/github/codeql-cli-binaries
https://github.com/github/codeql-cli-binaries

# Clone repo with vulnerability
cd ~/local
git clone git@github.com:github/codeql-demo-struts-CVE-2017-9805.git

# Build / download dependencies / populate ~/.m2/repository/
cd ~/local/codeql-demo-struts-CVE-2017-9805/
mvn clean
mvn compile
mvn install -DskipTests

# Create CodeQL database -- adjust PATH for your codeql binary
export PATH=$HOME/local/vmsync/codeql206:"$PATH"

SRCDIR=$HOME/local/codeql-demo-struts-CVE-2017-9805
DB=$HOME/local/db/mh_struts_db_1

test -d "$DB" && rm -fR "$DB" && mkdir -p "$DB"
codeql database create --language=java --command='mvn clean compile' \
       -s $SRCDIR  -j 8 -v $DB
```


<a id="org3267c27"></a>

## The Demonstration

In VS Code,

-   open vscode-codeql-starter workspace
-   add the unzipped Struts database you downloaded or created
-   open `codeql-custom-queries-java/example.ql` and run `> codeql: run query` to test.
-   save this file to `unsafe-deserialization.ql` for the rest of this demo

Following the 9-minute youtube video <https://www.youtube.com/watch?v=XsUcSd75K00>, but using VS Code:

-   Change `unsafe-deserialization.ql` to
    
    ```java
    /**
     * @kind path-problem
     * @id java/unsafe-deserialization
     */
    
    import java
    
    from Call c
    where c.getCallee().hasName("fromXML")
    select c
    ```

-   find calls to `fromXML`
-   add imports
    
    ```java
    import semmle.code.java.dataflow.FlowSources
    import DataFlow::PathGraph
    ```
-   add taint tracking configuration boilerplate
    
    ```java
    class FlowConfig extends TaintTracking::Configuration {
        FlowConfig() {
            this = "flowconfig for deserialization"
        }
        override predicate isSource(DataFlow::Node src) {}
        override predicate isSink(DataFlow::Node sink) {}
    }
    ```
-   taint tracking content
    
    ```java
    src instanceof RemoteFlowSource
    ```
    
    ```java
    exists(Call c |
        c.getCallee().hasName("fromXML") and
        sink.asExpr() = c.getAnArgument()
    )
    ```
    
    One query, no paths:
    
    ```java
    from FlowConfig config, DataFlow::Node source, DataFlow::Node sink
    where config.hasFlow(source, sink)
    select source, sink
    ```
    
    PathNode query:
    
    ```java
    from FlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
    where config.hasFlowPath(source, sink)
    select source, source, sink, "unsafe data use"
    ```

The final query for reference:

```java
/**
 * @kind path-problem
 * @id java/unsafe-deserialization
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class FlowConfig extends TaintTracking::Configuration {
    FlowConfig() { this = "flowconfig for deserialization" }

    override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

    override predicate isSink(DataFlow::Node sink) {
        exists(Call c |
            c.getCallee().hasName("fromXML") and
            sink.asExpr() = c.getAnArgument()
        )
    }
}

from FlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select source, source, sink, "unsafe data use"
```
