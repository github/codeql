/*
 * Copyright 2001-2005 (C) MetaStuff, Ltd. All Rights Reserved.
 *
 * This software is open source.
 * See the bottom of this file for the licence.
 */

/*
* Adapted from DOM4J version 2.1.1 as available at
*   https://search.maven.org/remotecontent?filepath=org/dom4j/dom4j/2.1.1/dom4j-2.1.1-sources.jar
* Only relevant stubs of this file have been retained for test purposes.
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

/*
 * Redistribution and use of this software and associated documentation
 * ("Software"), with or without modification, are permitted provided that the
 * following conditions are met:
 * 
 * 1. Redistributions of source code must retain copyright statements and
 * notices. Redistributions must also contain a copy of this document.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 * 
 * 3. The name "DOM4J" must not be used to endorse or promote products derived
 * from this Software without prior written permission of MetaStuff, Ltd. For
 * written permission, please contact dom4j-info@metastuff.com.
 * 
 * 4. Products derived from this Software may not be called "DOM4J" nor may
 * "DOM4J" appear in their names without prior written permission of MetaStuff,
 * Ltd. DOM4J is a registered trademark of MetaStuff, Ltd.
 * 
 * 5. Due credit should be given to the DOM4J Project - http://www.dom4j.org
 * 
 * THIS SOFTWARE IS PROVIDED BY METASTUFF, LTD. AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL METASTUFF, LTD. OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 * 
 * Copyright 2001-2005 (C) MetaStuff, Ltd. All Rights Reserved.
 */