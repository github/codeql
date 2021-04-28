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

package org.dom4j.tree;

import org.dom4j.*;
import org.dom4j.rule.Pattern;
import java.io.IOException;
import java.io.Serializable;
import java.io.Writer;
import java.util.List;

public abstract class AbstractNode implements Node, Cloneable, Serializable {
  public AbstractNode() {
  }

  public short getNodeType() {
    return 0;
  }

  public String getNodeTypeName() {
    return null;
  }

  public Document getDocument() {
    return null;
  }

  public void setDocument(Document document) {
  }

  public Element getParent() {
    return null;
  }

  public void setParent(Element parent) {
  }

  public boolean supportsParent() {
    return false;
  }

  public boolean isReadOnly() {
    return false;
  }

  public boolean hasContent() {
    return false;
  }

  public String getPath() {
    return null;
  }

  public String getUniquePath() {
    return null;
  }

  public Object clone() {
    return null;
  }

  public Node detach() {
    return null;
  }

  public String getName() {
    return null;
  }

  public void setName(String name) {
  }

  public String getText() {
    return null;
  }

  public String getStringValue() {
    return null;
  }

  public void setText(String text) {
  }

  public void write(Writer writer) throws IOException {
  }

  public Object selectObject(String xpathExpression) {
    return null;
  }

  public List<Node> selectNodes(String xpathExpression) {
    return null;
  }

  public List<Node> selectNodes(String xpathExpression, String comparisonXPathExpression) {
    return null;
  }

  public List<Node> selectNodes(String xpathExpression, String comparisonXPathExpression, boolean removeDuplicates) {
    return null;
  }

  public Node selectSingleNode(String xpathExpression) {
    return null;
  }

  public String valueOf(String xpathExpression) {
    return null;
  }

  public Number numberValueOf(String xpathExpression) {
    return null;
  }

  public boolean matches(String patternText) {
    return false;
  }

  public XPath createXPath(String xpathExpression) {
    return null;
  }

  public NodeFilter createXPathFilter(String patternText) {
    return null;
  }

  public Pattern createPattern(String patternText) {
    return null;
  }

  public Node asXPathResult(Element parent) {
    return null;
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