/**
 * Provides classes for modelling URI libraries.
 */

import javascript

private newtype TUnit = TUnitInjector()

private class UriLibraryStepGlue extends TaintTracking::AdditionalTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    any(UriLibraryStep step).step(pred, succ)
  }
}

/**
 * A taint propagating data flow edge arising from an operation in a URI library.
 */
class UriLibraryStep extends TUnit {
  abstract predicate step(DataFlow::Node pred, DataFlow::Node succ);

  string toString() { result = "Additional URI library taint step class" }
}

/**
 * Provides classes for working with [urijs](http://medialize.github.io/URI.js/) code.
 */
module urijs {
  /**
   * Gets a data flow source node for the urijs library.
   */
  DataFlow::SourceNode urijs() {
    result = DataFlow::globalVarRef("URI") or
    result = DataFlow::moduleImport("urijs") or
    result = DataFlow::moduleImport("URIjs")
  }

  /**
   * Gets a data flow source node for an invocation of the urijs function.
   */
  private DataFlow::InvokeNode invocation() { result = urijs().getAnInvocation() }

  /**
   * Gets a data flow source node for a urijs instance.
   */
  private DataFlow::InvokeNode instance() {
    result = invocation() or
    result = chainCall()
  }

  /**
   * Gets a data flow source node for a chainable method call on a urijs instance.
   */
  private DataFlow::MethodCallNode chainCall() {
    result = instance().getAMethodCall(_) and
    // the API has the convention that calls with arguments are chainable
    not result.getNumArgument() = 0
  }

  /**
   * Gets a data flow source node for a method call on an `instance` that returns a string value.
   */
  private DataFlow::MethodCallNode getter() {
    result = instance().getAMethodCall(_) and
    // the API has the convention that calls with zero arguments are string-valued getters
    result.getNumArgument() = 0
  }

  /**
   * A taint step in the urijs library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::ValueNode value | value = succ |
        // flow through "constructors" (`new` is optional)
        exists(DataFlow::InvokeNode invk | invk = value and invk = invocation() |
          pred = invk.getAnArgument()
        )
        or
        // flow through chained calls
        exists(DataFlow::MethodCallNode mc | mc = value and value = chainCall() |
          pred = mc.getReceiver() or
          pred = mc.getAnArgument()
        )
        or
        // flow through getter calls
        exists(DataFlow::MethodCallNode mc | mc = value and value = getter() |
          pred = mc.getReceiver()
        )
      )
    }
  }
}

/**
 * Provides classes for working with [uri-js](https://github.com/garycourt/uri-js) code.
 */
module uridashjs {
  /**
   * Gets a data flow source node for member `name` of the uridashjs library.
   */
  DataFlow::SourceNode uridashjsMember(string name) {
    result = DataFlow::moduleMember("uri-js", name)
  }

  /**
   * A taint step in the urijs library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call, string name |
        name = "parse" or
        name = "serialize" or
        name = "resolve" or
        name = "normalize"
      |
        call instanceof DataFlow::ValueNode and
        call = succ and
        call = uridashjsMember(name).getACall() and
        pred = call.getAnArgument()
      )
    }
  }
}

/**
 * Provides classes for working with [punycode](https://github.com/bestiejs/punycode.js) code.
 */
module punycode {
  /**
   * Gets a data flow source node for member `name` of the punycode library.
   */
  DataFlow::SourceNode punycodeMember(string name) {
    result = DataFlow::moduleMember("punycode", name)
  }

  /**
   * A taint step in the punycode library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call, string name |
        name = "decode" or
        name = "encode" or
        name = "toUnicode" or
        name = "toASCII"
      |
        call instanceof DataFlow::ValueNode and
        call = succ and
        call = punycodeMember(name).getACall() and
        pred = call.getAnArgument()
      )
    }
  }
}

/**
 * Provides classes for working with [url-parse](https://github.com/unshiftio/url-parse) code.
 */
module urlParse {
  /**
   * Gets a data flow source node for the url-parse library.
   */
  DataFlow::SourceNode urlParse() { result = DataFlow::moduleImport("url-parse") }

  /**
   * Gets a data flow source node for a call of the url-parse function.
   */
  private DataFlow::InvokeNode call() { result = urlParse().getACall() }

  /**
   * A taint step in the url-parse library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      // parse(src)
      succ = call() and
      succ instanceof DataFlow::ValueNode and
      pred = succ.(DataFlow::CallNode).getAnArgument()
      or
      exists(DataFlow::MethodCallNode mc |
        mc instanceof DataFlow::ValueNode and succ = mc and mc = call().getAMethodCall("set")
      |
        // src = parse(...); src.set(x, y)
        pred = mc.getReceiver()
        or
        // parse(x).set(y, src)
        pred = mc.getArgument(1)
      )
    }
  }
}

/**
 * Provides classes for working with [querystringify](https://github.com/unshiftio/querystringify) code.
 */
module querystringify {
  /**
   * Gets a data flow source node for member `name` of the querystringify library.
   */
  DataFlow::SourceNode querystringifyMember(string name) {
    result = DataFlow::moduleMember("querystringify", name)
  }

  /**
   * A taint step in the querystringify library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call, string name |
        name = "parse" or
        name = "stringify"
      |
        call = querystringifyMember(name).getACall() and
        pred = call.getAnArgument() and
        succ = call and
        call instanceof DataFlow::ValueNode
      )
    }
  }
}

/**
 * Provides classes for working with [query-string](https://github.com/sindresorhus/query-string) code.
 */
module querydashstring {
  /**
   * Gets a data flow source node for member `name` of the query-string library.
   */
  DataFlow::SourceNode querydashstringMember(string name) {
    result = DataFlow::moduleMember("query-string", name)
  }

  /**
   * A taint step in the query-string library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call, string name |
        name = "parse" or
        name = "extract" or
        name = "parseUrl" or
        name = "stringify"
      |
        call = querydashstringMember(name).getACall() and
        pred = call.getAnArgument() and
        call instanceof DataFlow::ValueNode and
        call = succ
      )
    }
  }
}

/**
 * Provides classes for working with [url](https://nodejs.org/api/url.html) code.
 */
module url {
  /**
   * Gets a data flow source node for member `name` of the url library.
   */
  DataFlow::SourceNode urlMember(string name) { result = DataFlow::moduleMember("url", name) }

  /**
   * A taint step in the url library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call, string name |
        name = "parse" or
        name = "format" or
        name = "resolve"
      |
        call = urlMember(name).getACall() and
        call instanceof DataFlow::ValueNode and
        succ = call and
        pred = call.getAnArgument()
      )
    }
  }
}

/**
 * Provides classes for working with [querystring](https://nodejs.org/api/querystring.html) code.
 */
module querystring {
  /**
   * Gets a data flow source node for member `name` of the querystring library.
   */
  DataFlow::SourceNode querystringMember(string name) {
    result = DataFlow::moduleMember("querystring", name)
  }

  /**
   * A taint step in the querystring library.
   */
  private class Step extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call, string name |
        name = "escape" or
        name = "unescape" or
        name = "parse" or
        name = "stringify"
      |
        call = querystringMember(name).getACall() and
        call instanceof DataFlow::ValueNode and
        call = succ and
        pred = call.getAnArgument()
      )
    }
  }
}

/**
 * Provides steps for the `goog.Uri` class in the closure library.
 */
private module ClosureLibraryUri {
  /**
   * Taint step from an argument of a `goog.Uri` call to the return value.
   */
  private class ArgumentStep extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::InvokeNode invoke, int arg |
        // goog.Uri constructor
        invoke = Closure::moduleImport("goog.Uri").getAnInstantiation() and arg = 0
        or
        // static methods on goog.Uri
        exists(string name | invoke = Closure::moduleImport("goog.Uri." + name).getACall() |
          name = "parse" and arg = 0
          or
          name = "create" and
          (arg = 0 or arg = 2 or arg = 4)
          or
          name = "resolve" and
          (arg = 0 or arg = 1)
        )
        or
        // static methods in goog.uri.utils
        arg = 0 and
        exists(string name | invoke = Closure::moduleImport("goog.uri.utils." + name).getACall() |
          name = "appendParam" or // preserve taint from the original URI, but not from the appended param
          name = "appendParams" or
          name = "appendParamsFromMap" or
          name = "appendPath" or
          name = "getParamValue" or
          name = "getParamValues" or
          name = "getPath" or
          name = "getPathAndAfter" or
          name = "getQueryData" or
          name = "parseQueryData" or
          name = "removeFragment" or
          name = "removeParam" or
          name = "setParam" or
          name = "setParamsFromMap" or
          name = "setPath" or
          name = "split"
        )
        or
        // static methods in goog.string
        arg = 0 and
        exists(string name | invoke = Closure::moduleImport("goog.string." + name).getACall() |
          name = "urlDecode" or
          name = "urlEncode"
        )
      |
        pred = invoke.getArgument(arg) and
        succ = invoke and
        succ instanceof DataFlow::ValueNode
      )
    }
  }

  /**
   * Taint steps through chainable setter calls.
   *
   * Setters mutate the URI object and return the same instance.
   */
  private class SetterCall extends DataFlow::MethodCallNode {
    DataFlow::NewNode uri;
    string name;

    SetterCall() {
      exists(DataFlow::SourceNode base |
        base = Closure::moduleImport("goog.Uri").getAnInstantiation() and
        uri = base
        or
        base.(SetterCall).getUri() = uri
      |
        this = base.getAMethodCall(name) and
        name.matches("set%")
      )
    }

    string getName() { result = name }

    DataFlow::NewNode getUri() { result = uri }
  }

  private class SetterCallStep extends UriLibraryStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(SetterCall setterCall |
        pred = setterCall.getReceiver() and succ = setterCall
        or
        setterCall.getName() = ["setDomain", "setPath", "setScheme"] and
        pred = setterCall.getArgument(0) and
        succ = setterCall.getUri()
      )
    }
  }

  /**
   * Provides classes for working with [path](https://nodejs.org/api/path.html) code.
   */
  module path {
    /**
     * A taint step in the path module.
     */
    private class Step extends UriLibraryStep {
      override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
        exists(DataFlow::CallNode call, DataFlow::SourceNode ref |
          ref = NodeJSLib::Path::moduleMember("parse") or
          // a ponyfill: https://www.npmjs.com/package/path-parse
          ref = DataFlow::moduleImport("path-parse") or
          ref = DataFlow::moduleMember("path-parse", "posix") or
          ref = DataFlow::moduleMember("path-parse", "win32")
        |
          call = ref.getACall() and
          call instanceof DataFlow::ValueNode and
          call = succ and
          pred = call.getAnArgument()
        )
      }
    }
  }
}
