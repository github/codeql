/**
 * Provides classes and predicates for reasoning about [puppeteer](https://www.npmjs.com/package/puppeteer).
 */

import javascript

/**
 * Classes and predicates modeling the [puppeteer](https://www.npmjs.com/package/puppeteer) library.
 */
module Puppeteer {
  /**
   * Gets a reference to a module import of puppeteer.
   */
  private API::Node puppeteer() { result = API::moduleImport(["puppeteer", "puppeteer-core"]) }

  /**
   * Gets a reference to a `Browser` from puppeteer.
   */
  private API::Node browser() {
    result = API::Node::ofType("puppeteer", "Browser")
    or
    result = puppeteer().getMember(["launch", "connect"]).getReturn().getPromised()
    or
    result = [page(), context(), target()].getMember("browser").getReturn()
  }

  /**
   * Gets a reference to a `Page` from puppeteer.
   */
  API::Node page() {
    result = API::Node::ofType("puppeteer", "Page")
    or
    result = [browser(), context()].getMember("newPage").getReturn().getPromised()
    or
    result = [browser(), context()].getMember("pages").getReturn().getPromised().getUnknownMember()
    or
    result = target().getMember("page").getReturn().getPromised()
  }

  /**
   * Gets a reference to a `Target` from puppeteer.
   */
  private API::Node target() {
    result = API::Node::ofType("puppeteer", "Target")
    or
    result = [page(), browser()].getMember("target").getReturn()
    or
    result = context().getMember("targets").getReturn().getUnknownMember()
    or
    result = target().getMember("opener").getReturn()
  }

  /**
   * Gets a reference to a `BrowserContext` from puppeteer.
   */
  private API::Node context() {
    result = API::Node::ofType("puppeteer", "BrowserContext")
    or
    result = [page(), target()].getMember("browserContext").getReturn()
    or
    result = browser().getMember("browserContexts").getReturn().getUnknownMember()
    or
    result = browser().getMember("createIncognitoBrowserContext").getReturn().getPromised()
    or
    result = browser().getMember("defaultBrowserContext").getReturn()
  }

  /**
   * A call requesting a `Page` to navigate to some url, seen as a `ClientRequest`.
   */
  private class PuppeteerGotoCall extends ClientRequest::Range, API::InvokeNode {
    PuppeteerGotoCall() { this = page().getMember("goto").getACall() }

    override DataFlow::Node getUrl() { result = getArgument(0) }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }

  /**
   * A call requesting a `Page` to load a stylesheet or script, seen as a `ClientRequest`.
   */
  private class PuppeteerLoadResourceCall extends ClientRequest::Range, API::InvokeNode {
    PuppeteerLoadResourceCall() {
      this = page().getMember(["addStyleTag", "addScriptTag"]).getACall()
    }

    override DataFlow::Node getUrl() { result = getParameter(0).getMember("url").getARhs() }

    override DataFlow::Node getHost() { none() }

    override DataFlow::Node getADataNode() { none() }
  }
}
