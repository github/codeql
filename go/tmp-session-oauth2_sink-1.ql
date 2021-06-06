/**
 * @name Empty block
 * @kind path-problem
 * @problem.severity warning
 * @id go/example/empty-block
 */

import go
import DataFlow::PathGraph

/*
 * redirect = req.Header.Get("X-Redirect")
 * ...
 * we are checking this
 *
 * if (strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//"):
 * 	valid = true
 *
 * But forgot to check "/\\"
 *
 *
 * There are three distinct parts we need in this query:
 *
 * 1. a data source with the structure
 *   redirect = req.Header.Get("X-Redirect")
 *
 * 2. a data sink with the structure
 *   strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//")
 *
 * 3. a taint flow configuration to connect the source and sink
 */

// At any point, working with ASTNode or Controlflow node or DataFlow::Node
// best ref https://codeql.github.com/docs/codeql-language-guides/abstract-syntax-tree-classes-for-working-with-go-programs/#abstract-syntax-tree-classes-for-working-with-go-programs
// This    redirect = req.Header.Get("X-Redirect")
// is a CallExpr
// Find all HasPrefix calls, identify the `checked` argument and the `prefix`
//
//     find strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//")
// from CallExpr call, Function target, Expr checked, Expr tmp, string prefix
// where
//     target.getName() = "HasPrefix" and
//     call.getTarget() = target   and
//     checked = call.getArgument(0) and
//     tmp = call.getArgument(1) and
//     prefix = tmp.(StringLit).getValue()
// select call as the_call, target, checked, prefix
/**
 *  Find all HasPrefix calls, identify the `checked` argument and the `prefix`
 *  find strings.HasPrefix(checked, prefix)
 */
predicate hasPrefixCall(CallExpr call, Function target, Expr checked, Expr tmp, string prefix) {
  target.getName() = "HasPrefix" and
  call.getTarget() = target and
  checked = call.getArgument(0) and
  tmp = call.getArgument(1) and
  prefix = tmp.(StringLit).getValue()
}

// from CallExpr call, Function target, Expr checked, Expr tmp, string prefix
// where hasPrefixCall(call, target, checked, tmp, prefix)
// select checked
/*
 *        SRCDIR=$HOME/local/goof
 *        DB=$HOME/local/db/js-goof-$(cd $SRCDIR && git rev-parse --short HEAD)
 *        echo $DB
 *        test -d "$DB" && rm -fR "$DB"
 *        mkdir -p "$DB"
 *
 *        export PATH=$HOME/local/vmsync/codeql224:"$PATH"
 *        codeql database create --language=javascript -s $SRCDIR  -j 8 -v $DB
 */

/**
 *  Find all HasPrefix calls, identify the `checked` argument and the `prefix`
 *   find strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//")
 */
predicate hasPrefixCall(Expr checked, string prefix) {
  exists(CallExpr call, Function target, Expr tmp |
    target.getName() = "HasPrefix" and
    call.getTarget() = target and
    checked = call.getArgument(0) and
    tmp = call.getArgument(1) and
    prefix = tmp.(StringLit).getValue()
  )
}

// from Expr checked, string prefix
// where hasPrefixCall(checked, prefix)
// select prefix, checked
/**
 *  Find all HasPrefix calls, identify the `checked` argument and the `prefix`:
 *   find strings.HasPrefix(prefix, checked)
 */
class HasPrefixCall extends CallExpr {
  Function target;
  Expr checked;
  Expr tmp;
  string prefix;

  HasPrefixCall() { hasPrefixCall(this, target, checked, tmp, prefix) }

  Expr getChecked() { result = checked }

  string getPrefix() { result = prefix }
}

// finding strings.HasPrefix(v, _)
// from HasPrefixCall call, DataFlow::Node checked, string prefix, Variable v
// where
//   prefix = call.getPrefix() and
//   checked.asExpr() = call.getChecked() and
//   v.getARead() = checked
// select call, checked, prefix, v

// session 1 above
// finding strings.HasPrefix(v, _)

// we need this sink: places with strings.HasPrefix(redirect, "/") && !strings.HasPrefix(redirect, "//")
// but missing /\.

// our goal: The string is prefix-checked against / but not both // and /\


// enforce one of the strings:
// from HasPrefixCall call, DataFlow::Node checked, string prefix, Variable v
// where
//   prefix = call.getPrefix() and
//   prefix = "/" and
//   checked.asExpr() = call.getChecked() and
//   v.getARead() = checked
// select call, checked, prefix, v

// as predicate:
predicate prefixCheck(HasPrefixCall call, DataFlow::Node checked, string prefix, Variable v) {
  prefix = call.getPrefix() and
  checked.asExpr() = call.getChecked() and
  v.getARead() = checked
}

// verify:
// from HasPrefixCall call, DataFlow::Node checked, Variable v
// where
//     prefixCheck(call, checked, "/", v)
// select call, checked, v

// Insufficient checks on prefix
// our goal: The string is prefix-checked against / but not both // and /\
//   / and (not // or not /\)
// maybe use LocalVariable
// from HasPrefixCall call, DataFlow::Node checked, Variable v
// where
//     // identifies "main" sink
//     prefixCheck(call, checked, "/", v) and (
//         // extra conditions to satisfy
//         not prefixCheck(_, _, "//", v)  
//         or 
//         not prefixCheck(_, _, "/\\", v)
//     )
// select call, checked, v

/** 
 Insufficient checks on prefix
 The string is prefix-checked against / but not both // and /\, that is 
 / and (not // or not /\)
 */
predicate insufficientPrefixChecks(HasPrefixCall call, DataFlow::Node checked, Variable v) {
    // identifies "main" sink
    prefixCheck(call, checked, "/", v) and (
        // extra conditions to satisfy
        not prefixCheck(_, _, "//", v)  
        or 
        not prefixCheck(_, _, "/\\", v)
    )
}

// Query with DataFlow::Node -- the sink
// from HasPrefixCall call, DataFlow::Node checked, Variable v
// where insufficientPrefixChecks(call, checked, v)
// select checked

// Broadly three ql "base types": ASTNodes -- structural
// variable.getARead() -- DataFlow::Node -- dataflow
// variable.getAWrite() -- ControlFlow::Node -- control flow graph

// Got the sink, need source:
// redirect = req.Header.Get("X-Redirect")
// Let's use CodeQL library class UntrustedFlowSource
predicate isSource(DataFlow::Node source) {
    source instanceof UntrustedFlowSource
    // https://codeql.github.com/codeql-standard-libraries/go/semmle/go/security/FlowSources.qll/type.FlowSources$UntrustedFlowSource.html
    // note the import path in the docs:
    // import semmle.go.security.OpenUrlRedirectCustomizations
}

// dataflow vs. taint tracking
// sink = source 
// foo(sink) -- data flow will track this
// 
// sink = source + "_suffix"
// foo(sink) -- data flow will not track, taint tracking will track

class Config extends TaintTracking::Configuration {
    Config() { this = "Config" }

    override predicate isSource(DataFlow::Node source) { 
        source instanceof UntrustedFlowSource
    }

    override predicate isSink(DataFlow::Node sink) { 
        insufficientPrefixChecks(_, sink, _)
    }
}

// Plain source, sink pairs:
// from DataFlow::Node source, DataFlow::Node sink, Config c
// where   
//     c.hasFlow(source, sink)
// select sink, source

from DataFlow::PathNode source, DataFlow::PathNode sink, Config c
where   
     c.hasFlowPath(source, sink)
select sink, source, sink, "Untrusted value reaches insufficient redirect check"



/* 
12845  export PATH="$HOME/local/vmsync/codeql243:$PATH"
12846  codeql database create --help
12847  mkdir function.db
12848  codeql database create --language=go -s . -j 8 function.db/
12851  ls function.db/
*/

/* 
        SRCDIR=$HOME/local/goof
        DB=$HOME/local/db/js-goof-$(cd $SRCDIR && git rev-parse --short HEAD)
        echo $DB
        test -d "$DB" && rm -fR "$DB"
        mkdir -p "$DB"

        export PATH=$HOME/local/vmsync/codeql224:"$PATH"
        codeql database create --language=javascript -s $SRCDIR  -j 8 -v $DB

*/

/* 
    - [ ] More resources:
      - [[https://codeql.github.com/docs/codeql-language-guides/codeql-library-for-go/#data-flow][Data flow documentation]] is a subtopic of =CodeQL library for Go=
      - Sample codeql/go snippets: https://github.com/github/codeql-go/tree/main/ql/examples/snippets
      - [[https://codeql.github.com/docs/codeql-cli/testing-custom-queries/][testing custom queries]]
*/