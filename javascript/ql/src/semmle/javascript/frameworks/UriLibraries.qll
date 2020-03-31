/**
 * Provides classes for modelling URI libraries.
 */

import javascript

/**
 * A taint propagating data flow edge arising from an operation in a URI library.
 */
abstract class UriLibraryStep extends DataFlow::ValueNode, TaintTracking::AdditionalTaintStep { }

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
    DataFlow::Node src;

    Step() {
      // flow through "constructors" (`new` is optional)
      exists(DataFlow::InvokeNode invk | invk = this and invk = invocation() |
        src = invk.getAnArgument()
      )
      or
      // flow through chained calls
      exists(DataFlow::MethodCallNode mc | mc = this and this = chainCall() |
        src = mc.getReceiver() or
        src = mc.getAnArgument()
      )
      or
      // flow through getter calls
      exists(DataFlow::MethodCallNode mc | mc = this and this = getter() | src = mc.getReceiver())
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
  private class Step extends UriLibraryStep, DataFlow::CallNode {
    DataFlow::Node src;

    Step() {
      exists(string name |
        name = "parse" or
        name = "serialize" or
        name = "resolve" or
        name = "normalize"
      |
        this = uridashjsMember(name).getACall() and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
  private class Step extends UriLibraryStep, DataFlow::CallNode {
    DataFlow::Node src;

    Step() {
      exists(string name |
        name = "decode" or
        name = "encode" or
        name = "toUnicode" or
        name = "toASCII"
      |
        this = punycodeMember(name).getACall() and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
  private class Step extends UriLibraryStep, DataFlow::CallNode {
    DataFlow::Node src;

    Step() {
      // parse(src)
      this = call() and
      src = getAnArgument()
      or
      exists(DataFlow::MethodCallNode mc | this = mc and mc = call().getAMethodCall("set") |
        // src = parse(...); src.set(x, y)
        src = mc.getReceiver()
        or
        // parse(x).set(y, src)
        src = mc.getArgument(1)
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
  private class Step extends UriLibraryStep, DataFlow::CallNode {
    DataFlow::Node src;

    Step() {
      exists(string name |
        name = "parse" or
        name = "stringify"
      |
        this = querystringifyMember(name).getACall() and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
  private class Step extends UriLibraryStep, DataFlow::CallNode {
    DataFlow::Node src;

    Step() {
      exists(string name |
        name = "parse" or
        name = "extract" or
        name = "parseUrl" or
        name = "stringify"
      |
        this = querydashstringMember(name).getACall() and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
  private class Step extends UriLibraryStep, DataFlow::CallNode {
    DataFlow::Node src;

    Step() {
      exists(string name |
        name = "parse" or
        name = "format" or
        name = "resolve"
      |
        this = urlMember(name).getACall() and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
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
  private class Step extends UriLibraryStep, DataFlow::CallNode {
    DataFlow::Node src;

    Step() {
      exists(string name |
        name = "escape" or
        name = "unescape" or
        name = "parse" or
        name = "stringify"
      |
        this = querystringMember(name).getACall() and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) { pred = src and succ = this }
  }
}

/**
 * Provides steps for the `goog.Uri` class in the closure library.
 */
private module ClosureLibraryUri {
  /**
   * Taint step from an argument of a `goog.Uri` call to the return value.
   */
  private class ArgumentStep extends UriLibraryStep, DataFlow::InvokeNode {
    int arg;

    ArgumentStep() {
      // goog.Uri constructor
      this = Closure::moduleImport("goog.Uri").getAnInstantiation() and arg = 0
      or
      // static methods on goog.Uri
      exists(string name | this = Closure::moduleImport("goog.Uri." + name).getACall() |
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
      exists(string name | this = Closure::moduleImport("goog.uri.utils." + name).getACall() |
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
      exists(string name | this = Closure::moduleImport("goog.string." + name).getACall() |
        name = "urlDecode" or
        name = "urlEncode"
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getArgument(arg) and
      succ = this
    }
  }

  /**
   * Taint steps through chainable setter calls.
   *
   * Setters mutate the URI object and return the same instance.
   */
  private class SetterCall extends DataFlow::MethodCallNode, UriLibraryStep {
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

    DataFlow::NewNode getUri() { result = uri }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getReceiver() and succ = this
      or
      (name = "setDomain" or name = "setPath" or name = "setScheme") and
      pred = getArgument(0) and
      succ = uri
    }
  }

  /**
   * Provides classes for working with [path](https://nodejs.org/api/path.html) code.
   */
  module path {
    /**
     * A taint step in the path module.
     */
    private class Step extends UriLibraryStep, DataFlow::CallNode {
      DataFlow::Node src;

      Step() {
        exists(DataFlow::SourceNode ref |
          ref = NodeJSLib::Path::moduleMember("parse") or
          // a ponyfill: https://www.npmjs.com/package/path-parse
          ref = DataFlow::moduleImport("path-parse") or
          ref = DataFlow::moduleMember("path-parse", "posix") or
          ref = DataFlow::moduleMember("path-parse", "win32")
        |
          this = ref.getACall() and
          src = getAnArgument()
        )
      }

      override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
        pred = src and succ = this
      }
    }
  }
}
