/*
 * Copyright 2001-2005 (C) MetaStuff, Ltd. All Rights Reserved.
 *
 * This software is open source.
 * See the bottom of this file for the licence.
 */

package org.dom4j.util;

import org.dom4j.Document;
import org.dom4j.DocumentFactory;
import org.dom4j.Element;
import org.dom4j.NodeFilter;
import org.dom4j.XPath;
import org.dom4j.rule.Pattern;
import org.jaxen.VariableContext;

public abstract class ProxyDocumentFactory {
  public ProxyDocumentFactory() {
  }

  public ProxyDocumentFactory(DocumentFactory proxy) {
  }

  public Document createDocument() {
    return null;
  }

  public Document createDocument(Element rootElement) {
    return null;
  }

  public Element createElement(String name) {
    return null;
  }

  public XPath createXPath(String xpathExpression) {
    return null;
  }

  public XPath createXPath(String xpathExpression, VariableContext variableContext) {
    return null;
  }

  public NodeFilter createXPathFilter(String xpathFilterExpression, VariableContext variableContext) {
    return null;
  }

  public NodeFilter createXPathFilter(String xpathFilterExpression) {
    return null;
  }

  public Pattern createPattern(String xpathPattern) {
    return null;
  }

}
