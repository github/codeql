/*
 * Copyright 2001-2005 (C) MetaStuff, Ltd. All Rights Reserved.
 *
 * This software is open source.
 * See the bottom of this file for the licence.
 */

package org.dom4j;

import java.util.List;
import java.util.Map;
import org.dom4j.rule.Pattern;
import org.jaxen.VariableContext;

public final class DocumentHelper {
  public static Document createDocument() {
    return null;
  }

  public static Document createDocument(Element rootElement) {
    return null;
  }

  public static Element createElement(String name) {
    return null;
  }

  public static Namespace createNamespace(String prefix, String uri) {
    return null;
  }

  public static XPath createXPath(String xpathExpression) throws InvalidXPathException {
    return null;
  }

  public static XPath createXPath(String xpathExpression, VariableContext context) throws InvalidXPathException {
    return null;
  }

  public static NodeFilter createXPathFilter(String xpathFilterExpression) {
    return null;
  }

  public static Pattern createPattern(String xpathPattern) {
    return null;
  }

  public static List<Node> selectNodes(String xpathFilterExpression, List<Node> nodes) {
    return null;
  }

  public static List<Node> selectNodes(String xpathFilterExpression, Node node) {
    return null;
  }

  public static void sort(List<Node> list, String xpathExpression) {
  }

  public static void sort(List<Node> list, String expression, boolean distinct) {
  }

  public static Element makeElement(Branch source, String path) {
    return null;
  }

}
