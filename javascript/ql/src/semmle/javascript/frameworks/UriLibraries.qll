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
  deprecated DataFlow::SourceNode uridashjs() {
    result = DataFlow::moduleImport("uri-js")
  }

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
      exists (string name |
        name = "parse" or
        name = "serialize" or
        name = "resolve" or
        name = "normalize" |
        this = uridashjsMember(name).getACall() and
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
  deprecated DataFlow::SourceNode punycode() {
    result = DataFlow::moduleImport("punycode")
  }

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
      exists (string name |
        name = "decode" or
        name = "encode" or
        name = "toUnicode" or
        name = "toASCII" |
        this = punycodeMember(name).getACall() and
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
  deprecated DataFlow::SourceNode querystringify() {
    result = DataFlow::moduleImport("querystringify")
  }

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
      exists (string name |
        name = "parse" or
        name = "stringify" |
        this = querystringifyMember(name).getACall() and
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
  deprecated DataFlow::SourceNode querydashstring() {
    result = DataFlow::moduleImport("query-string")
  }


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
      exists (string name |
        name = "parse" or
        name = "extract" or
        name = "parseUrl" or
        name = "stringify" |
        this = querydashstringMember(name).getACall() and
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
  deprecated DataFlow::SourceNode url() {
    result = DataFlow::moduleImport("url")
  }


  /**
   * Gets a data flow source node for member `name` of the url library.
   */
  DataFlow::SourceNode urlMember(string name) {
    result = DataFlow::moduleMember("url", name)
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
        this = urlMember(name).getACall() and
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
  deprecated DataFlow::SourceNode querystring() {
    result = DataFlow::moduleImport("querystring")
  }

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
      exists (string name |
        name = "escape" or
        name = "unescape" or
        name = "parse" or
        name = "stringify" |
        this = querystringMember(name).getACall() and
        src = getAnArgument()
      )
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = src and succ = this
    }
  }

}
