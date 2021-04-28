/*
 * Copyright 2001-2005 (C) MetaStuff, Ltd. All Rights Reserved.
 *
 * This software is open source.
 * See the bottom of this file for the licence.
 */

package org.dom4j;

import java.io.Serializable;
import java.util.Map;

import org.dom4j.rule.Pattern;
import org.jaxen.VariableContext;

public class DocumentFactory implements Serializable {
  public DocumentFactory() {
  }

  public static synchronized DocumentFactory getInstance() {
    return null;
  }

  public Document createDocument() {
    return null;
  }

  public Document createDocument(String encoding) {
    return null;
  }

  public Document createDocument(Element rootElement) {
    return null;
  }

  public Element createElement(String name) {
    return null;
  }

  public Element createElement(String qualifiedName, String namespaceURI) {
    return null;
  }

  public Namespace createNamespace(String prefix, String uri) {
    return null;
  }

  public XPath createXPath(String xpathExpression) throws InvalidXPathException {
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

  public Map<String, String> getXPathNamespaceURIs() {
    return null;
  }

  public void setXPathNamespaceURIs(Map<String, String> namespaceURIs) {
  }

}
