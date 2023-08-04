// Generated automatically from org.dom4j.Visitor for testing purposes

package org.dom4j;

import org.dom4j.Attribute;
import org.dom4j.CDATA;
import org.dom4j.Comment;
import org.dom4j.Document;
import org.dom4j.DocumentType;
import org.dom4j.Element;
import org.dom4j.Entity;
import org.dom4j.Namespace;
import org.dom4j.ProcessingInstruction;
import org.dom4j.Text;

public interface Visitor
{
    void visit(Attribute p0);
    void visit(CDATA p0);
    void visit(Comment p0);
    void visit(Document p0);
    void visit(DocumentType p0);
    void visit(Element p0);
    void visit(Entity p0);
    void visit(Namespace p0);
    void visit(ProcessingInstruction p0);
    void visit(Text p0);
}
