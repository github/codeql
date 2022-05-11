/**
 * Provides classes for modeling URI libraries.
 */

import javascript

/**
 * DEPRECATED. Use `TaintTracking::SharedTaintStep` or `TaintTracking::uriStep` instead.
 *
 * A taint propagating data flow edge arising from an operation in a URI library.
 */
abstract deprecated class UriLibraryStep extends DataFlow::ValueNode {
  /** Holds if `pred -> succ` is a step through a URI library function. */
  predicate step(DataFlow::Node pred, DataFlow::Node succ) { none() }
}

/** DEPRECATED: Alias for `Urijs` */
deprecated module urijs = Urijs;

/**
 * Provides classes for working with [urijs](http://medialize.github.io/URI.js/) code.
 */
module Urijs {
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
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      // flow through "constructors" (`new` is optional)
      exists(DataFlow::InvokeNode invk | invk = succ and invk = invocation() |
        pred = invk.getAnArgument()
      )
      or
      // flow through chained calls
      exists(DataFlow::MethodCallNode mc | mc = succ and succ = chainCall() |
        pred = mc.getReceiver() or
        pred = mc.getAnArgument()
      )
      or
      // flow through getter calls
      exists(DataFlow::MethodCallNode mc | mc = succ and succ = getter() | pred = mc.getReceiver())
    }
  }
}

/** DEPRECATED: Alias for `Uridashjs` */
deprecated module uridashjs = Uridashjs;

/**
 * Provides classes for working with [uri-js](https://github.com/garycourt/uri-js) code.
 */
module Uridashjs {
  /**
   * Gets a data flow source node for member `name` of the uridashjs library.
   */
  DataFlow::SourceNode uridashjsMember(string name) {
    result = DataFlow::moduleMember("uri-js", name)
  }

  /**
   * A taint step in the urijs library.
   */
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = uridashjsMember(["parse", "serialize", "resolve", "normalize"]).getACall() and
        pred = call.getAnArgument() and
        succ = call
      )
    }
  }
}

/** DEPRECATED: Alias for `Punycode` */
deprecated module punycode = Punycode;

/**
 * Provides classes for working with [punycode](https://github.com/bestiejs/punycode.js) code.
 */
module Punycode {
  /**
   * Gets a data flow source node for member `name` of the punycode library.
   */
  DataFlow::SourceNode punycodeMember(string name) {
    result = DataFlow::moduleMember("punycode", name)
  }

  /**
   * A taint step in the punycode library.
   */
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = punycodeMember(["decode", "encode", "toUnicode", "toASCII"]).getACall() and
        pred = call.getAnArgument() and
        succ = call
      )
    }
  }
}

/** DEPRECATED: Alias for `UrlParse` */
deprecated module urlParse = UrlParse;

/**
 * Provides classes for working with [url-parse](https://github.com/unshiftio/url-parse) code.
 */
module UrlParse {
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
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call | succ = call |
        // parse(pred)
        call = call() and
        pred = call.getAnArgument()
        or
        call = call().getAMethodCall("set") and
        (
          // pred = parse(...); pred.set(x, y)
          pred = call.getReceiver()
          or
          // parse(x).set(y, pred)
          pred = call.getArgument(1)
        )
      )
    }
  }
}

/** DEPRECATED: Alias for `Querystringify` */
deprecated module querystringify = Querystringify;

/**
 * Provides classes for working with [querystringify](https://github.com/unshiftio/querystringify) code.
 */
module Querystringify {
  /**
   * Gets a data flow source node for member `name` of the querystringify library.
   */
  DataFlow::SourceNode querystringifyMember(string name) {
    result = querystringify().getMember(name).getAnImmediateUse()
  }

  /** Gets an API node referring to the `querystringify` module. */
  private API::Node querystringify() {
    result = [API::moduleImport("querystringify"), API::moduleImport("url-parse").getMember("qs")]
  }

  /**
   * A taint step in the querystringify library.
   */
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = querystringify().getMember(["parse", "stringify"]).getACall() and
        pred = call.getAnArgument() and
        succ = call
      )
    }
  }
}

/** DEPRECATED: Alias for `Querydashstring` */
deprecated module querydashstring = Querydashstring;

/**
 * Provides classes for working with [query-string](https://github.com/sindresorhus/query-string) code.
 */
module Querydashstring {
  /**
   * Gets a data flow source node for member `name` of the query-string library.
   */
  DataFlow::SourceNode querydashstringMember(string name) {
    result = DataFlow::moduleMember("query-string", name)
  }

  /**
   * A taint step in the query-string library.
   */
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = querydashstringMember(["parse", "extract", "parseUrl", "stringify"]).getACall() and
        pred = call.getAnArgument() and
        succ = call
      )
    }
  }
}

/** DEPRECATED: Alias for `Url` */
deprecated module url = Url;

/**
 * Provides classes for working with [url](https://nodejs.org/api/url.html) code.
 */
module Url {
  /**
   * Gets a data flow source node for member `name` of the url library.
   */
  DataFlow::SourceNode urlMember(string name) { result = DataFlow::moduleMember("url", name) }

  /**
   * A taint step in the url library.
   */
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = urlMember(["parse", "format", "resolve"]).getACall() and
        pred = call.getAnArgument() and
        succ = call
      )
    }
  }
}

/** DEPRECATED: Alias for `Querystring` */
deprecated module querystring = Querystring;

/**
 * Provides classes for working with [querystring](https://nodejs.org/api/querystring.html) code.
 */
module Querystring {
  /**
   * Gets a data flow source node for member `name` of the querystring library.
   */
  DataFlow::SourceNode querystringMember(string name) {
    result = DataFlow::moduleMember("querystring", name)
  }

  /**
   * A taint step in the querystring library.
   */
  private class Step extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call |
        call = querystringMember(["escape", "unescape", "parse", "stringify"]).getACall() and
        pred = call.getAnArgument() and
        succ = call
      )
    }
  }
}

/**
 * A taint step through a call to [qs](https://npmjs.com/package/qs)
 */
private class QsStep extends TaintTracking::SharedTaintStep {
  override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call |
      call = API::moduleImport("qs").getMember(["parse", "stringify"]).getACall()
    |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A taint step through a call to [normalize-url](https://npmjs.com/package/normalize-url)
 */
private class NormalizeUrlStep extends TaintTracking::SharedTaintStep {
  override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call | call = API::moduleImport("normalize-url").getACall() |
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * A taint step through a call to [parseqs](https://npmjs.com/package/parseqs).
 */
private class ParseQsStep extends TaintTracking::SharedTaintStep {
  override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(API::CallNode call |
      call = API::moduleImport("parseqs").getMember(["encode", "decode"]).getACall() and
      pred = call.getArgument(0) and
      succ = call
    )
  }
}

/**
 * Provides steps for the `goog.Uri` class in the closure library.
 */
private module ClosureLibraryUri {
  /**
   * Taint step from an argument of a `goog.Uri` call to the return value.
   */
  private class ArgumentStep extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::InvokeNode invoke, int arg |
        pred = invoke.getArgument(arg) and succ = invoke
      |
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

    DataFlow::NewNode getUri() { result = uri }

    string getName() { result = name }
  }

  /** A taint step derived from a setter call on a `goog.Uri` object. */
  private class SetterCallStep extends TaintTracking::SharedTaintStep {
    override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(SetterCall call |
        pred = call.getReceiver() and succ = call
        or
        (call.getName() = "setDomain" or call.getName() = "setPath" or call.getName() = "setScheme") and
        pred = call.getArgument(0) and
        succ = call.getUri()
      )
    }
  }

  /**
   * Provides classes for working with [path](https://nodejs.org/api/path.html) code.
   */
  module Path {
    /**
     * A taint step in the path module.
     */
    private class Step extends TaintTracking::SharedTaintStep {
      override predicate uriStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(DataFlow::SourceNode ref, DataFlow::CallNode call |
          ref = NodeJSLib::Path::moduleMember("parse") or
          // a ponyfill: https://www.npmjs.com/package/path-parse
          ref = DataFlow::moduleImport("path-parse") or
          ref = DataFlow::moduleMember("path-parse", "posix") or
          ref = DataFlow::moduleMember("path-parse", "win32")
        |
          call = ref.getACall() and
          pred = call.getAnArgument() and
          succ = call
        )
      }
    }
  }
}
