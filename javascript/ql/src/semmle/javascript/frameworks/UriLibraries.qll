/**
 * Provides classes for modelling URI libraries.
 */

import javascript

/**
 * A taint propagating data flow edge arising from an operation in a URI library.
 */
abstract class UriLibraryStep extends DataFlow::ValueNode, TaintTracking::AdditionalTaintStep {}

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
  private DataFlow::InvokeNode invocation() {
    result = urijs().getAnInvocation()
  }

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
      exists (DataFlow::InvokeNode invk | invk = this and invk = invocation() |
        src = invk.getAnArgument()
      )
      or
      // flow through chained calls
      exists (DataFlow::MethodCallNode mc | mc = this and this = chainCall() |
        src = mc.getReceiver() or
        src = mc.getAnArgument()
      )
      or
      // flow through getter calls
      exists (DataFlow::MethodCallNode mc | mc = this and this = getter() |
        src = mc.getReceiver()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}

/**
 * Provides classes for working with [uri-js](https://github.com/garycourt/uri-js) code.
 */
module uridashjs {

  /**
   * Gets a data flow source node for the uridashjs library.
   */
  DataFlow::SourceNode uridashjs() {
    result = DataFlow::moduleImport("uri-js")
  }

  /**
   * A taint step in the urijs library.
   */
  private class Step extends UriLibraryStep, DataFlow::CallNode {

    DataFlow::Node src;

    Step() {
      exists (string name |
        name = "parse" or
        name = "serialize" or
        name = "resolve" or
        name = "normalize" |
        this = uridashjs().getAMemberCall(name) and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}

/**
 * Provides classes for working with [punycode](https://github.com/bestiejs/punycode.js) code.
 */
module punycode {

  /**
   * Gets a data flow source node for the punycode library.
   */
  DataFlow::SourceNode punycode() {
    result = DataFlow::moduleImport("punycode")
  }

  /**
   * A taint step in the punycode library.
   */
  private class Step extends UriLibraryStep, DataFlow::CallNode {

    DataFlow::Node src;

    Step() {
      exists (string name |
        name = "decode" or
        name = "encode" or
        name = "toUnicode" or
        name = "toASCII" |
        this = punycode().getAMemberCall(name) and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
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
  DataFlow::SourceNode urlParse() {
    result = DataFlow::moduleImport("url-parse")
  }

  /**
   * Gets a data flow source node for a call of the url-parse function.
   */
  private DataFlow::InvokeNode call() {
    result = urlParse().getACall()
  }

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
      exists (DataFlow::MethodCallNode mc | this = mc and mc = call().getAMethodCall("set") |
        // src = parse(...); src.set(x, y)
        src = mc.getReceiver() or
        // parse(x).set(y, src)
        src = mc.getArgument(1)
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}

/**
 * Provides classes for working with [querystringify](https://github.com/unshiftio/querystringify) code.
 */
module querystringify {

  /**
   * Gets a data flow source node for the querystringify library.
   */
  DataFlow::SourceNode querystringify() {
    result = DataFlow::moduleImport("querystringify")
  }

  /**
   * A taint step in the querystringify library.
   */
  private class Step extends UriLibraryStep, DataFlow::CallNode {

    DataFlow::Node src;

    Step() {
      exists (string name |
        name = "parse" or
        name = "stringify" |
        this = querystringify().getAMemberCall(name) and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}

/**
 * Provides classes for working with [query-string](https://github.com/sindresorhus/query-string) code.
 */
module querydashstring {

  /**
   * Gets a data flow source node for the query-string library.
   */
  DataFlow::SourceNode querydashstring() {
    result = DataFlow::moduleImport("query-string")
  }

  /**
   * A taint step in the query-string library.
   */
  private class Step extends UriLibraryStep, DataFlow::CallNode {

    DataFlow::Node src;

    Step() {
      exists (string name |
        name = "parse" or
        name = "extract" or
        name = "parseUrl" or
        name = "stringify" |
        this = querydashstring().getAMemberCall(name) and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}

/**
 * Provides classes for working with [url](https://nodejs.org/api/url.html) code.
 */
module url {

  /**
   * Gets a data flow source node for the url library.
   */
  DataFlow::SourceNode url() {
    result = DataFlow::moduleImport("url")
  }

  /**
   * A taint step in the url library.
   */
  private class Step extends UriLibraryStep, DataFlow::CallNode {

    DataFlow::Node src;

    Step() {
      exists (string name |
        name = "parse" or
        name = "format" or
        name = "resolve" |
        this = url().getAMemberCall(name) and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}

/**
 * Provides classes for working with [querystring](https://nodejs.org/api/querystring.html) code.
 */
module querystring {

  /**
   * Gets a data flow source node for the querystring library.
   */
  DataFlow::SourceNode querystring() {
    result = DataFlow::moduleImport("querystring")
  }

  /**
   * A taint step in the querystring library.
   */
  private class Step extends UriLibraryStep, DataFlow::CallNode {

    DataFlow::Node src;

    Step() {
      exists (string name |
        name = "escape" or
        name = "unescape" or
        name = "parse" or
        name = "stringify" |
        this = querystring().getAMemberCall(name) and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}
