import javascript

/**
 * Classes and predicates modelling the `puppeteer` library.
 */
module Puppeteer {
  /**
   * A reference to a module import of puppeteer.
   */
  private API::Node puppeteer() { result = API::moduleImport(["puppeteer", "puppeteer-core"]) }

  private class BrowserTypeEntryPoint extends API::EntryPoint {
    BrowserTypeEntryPoint() { this = "PuppeteerBrowserTypeEntryPoint" }

    override DataFlow::SourceNode getAUse() { result.hasUnderlyingType("puppeteer", "Browser") }

    override DataFlow::Node getARhs() { none() }
  }

  /**
   * A reference to a `Browser` from puppeteer.
   */
  private API::Node browser() {
    result = API::root().getASuccessor(any(BrowserTypeEntryPoint b))
    or
    result = puppeteer().getMember(["launch", "connect"]).getReturn().getPromised()
    or
    result = [page(), context(), target()].getMember("browser").getReturn()
  }

  private class PageTypeEntryPoint extends API::EntryPoint {
    PageTypeEntryPoint() { this = "PuppeteerPageTypeEntryPoint" }

    override DataFlow::SourceNode getAUse() { result.hasUnderlyingType("puppeteer", "Page") }

    override DataFlow::Node getARhs() { none() }
  }

  /**
   * A reference to a `Page` from puppeteer.
   */
  API::Node page() {
    result = API::root().getASuccessor(any(PageTypeEntryPoint b))
    or
    result = [browser(), context()].getMember("newPage").getReturn().getPromised()
    or
    result = [browser(), context()].getMember("pages").getReturn().getPromised().getUnknownMember()
    or
    result = target().getMember("page").getReturn().getPromised()
  }

  private class TargetTypeEntryPoint extends API::EntryPoint {
    TargetTypeEntryPoint() { this = "PuppeteerTargetTypeEntryPoint" }

    override DataFlow::SourceNode getAUse() { result.hasUnderlyingType("puppeteer", "Target") }

    override DataFlow::Node getARhs() { none() }
  }

  /**
   * A reference to a `Target` from puppeteer.
   */
  private API::Node target() {
    result = API::root().getASuccessor(any(TargetTypeEntryPoint b))
    or
    result = [page(), browser()].getMember("target").getReturn()
    or
    result = context().getMember("targets").getReturn().getUnknownMember()
    or
    result = target().getMember("opener").getReturn()
  }

  private class ContextTypeEntryPoint extends API::EntryPoint {
    ContextTypeEntryPoint() { this = "PuppeteerContextTypeEntryPoint" }

    override DataFlow::SourceNode getAUse() {
      result.hasUnderlyingType("puppeteer", "BrowserContext")
    }

    override DataFlow::Node getARhs() { none() }
  }

  /**
   * A reference to a `BrowserContext` from puppeteer.
   */
  private API::Node context() {
    result = API::root().getASuccessor(any(ContextTypeEntryPoint b))
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
