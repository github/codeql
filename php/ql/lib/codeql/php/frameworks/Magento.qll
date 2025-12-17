/**
 * Provides classes for modeling Magento framework patterns.
 */

private import codeql.php.ast.internal.TreeSitter as TS
private import codeql.php.ast.Expr
private import codeql.php.frameworks.Core

/**
 * A Magento request input method call.
 */
class MagentoUserInput extends MethodCall {
  MagentoUserInput() {
    this.getMethodName() in [
      "getParam", "getParams", "getQuery", "getPost", "getServer",
      "getCookie", "getFiles", "getContent"
    ]
  }
}

/**
 * A Magento collection filter call.
 */
class MagentoCollectionFilter extends MethodCall {
  MagentoCollectionFilter() {
    this.getMethodName() in [
      "addFieldToFilter", "addAttributeToFilter", "addFilter",
      "setOrder", "setPageSize", "setCurPage",
      "load", "getFirstItem", "getItems", "toArray"
    ]
  }
}

/**
 * A Magento unsafe query.
 */
class MagentoUnsafeQuery extends MethodCall {
  MagentoUnsafeQuery() {
    this.getMethodName() in ["query", "rawQuery", "raw"]
  }
}

/**
 * A Magento template output.
 */
class MagentoTemplateOutput extends MethodCall {
  MagentoTemplateOutput() {
    this.getMethodName() in [
      "getBlockHtml", "getChildHtml", "toHtml", "setTemplate", "fetchView"
    ]
  }
}

/**
 * A Magento escaper.
 */
class MagentoXssSanitizer extends MethodCall {
  MagentoXssSanitizer() {
    this.getMethodName() in [
      "escapeHtml", "escapeHtmlAttr", "escapeJs", "escapeCss", "escapeUrl", "escapeQuote"
    ]
  }
}

/**
 * A Magento form key check.
 */
class MagentoTokenCheck extends MethodCall {
  MagentoTokenCheck() {
    this.getMethodName() in ["getFormKey", "validateFormKey"]
  }
}

/**
 * A Magento cache call.
 */
class MagentoCacheCall extends MethodCall {
  MagentoCacheCall() {
    this.getMethodName() in ["load", "save", "remove", "clean", "getIdentifier"]
  }
}
