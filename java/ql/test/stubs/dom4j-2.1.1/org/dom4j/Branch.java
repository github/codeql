// Generated automatically from org.dom4j.Branch for testing purposes

package org.dom4j;

import java.util.Iterator;
import java.util.List;
import org.dom4j.Comment;
import org.dom4j.Element;
import org.dom4j.Node;
import org.dom4j.ProcessingInstruction;
import org.dom4j.QName;

public interface Branch extends Node
{
    Element addElement(QName p0);
    Element addElement(String p0);
    Element addElement(String p0, String p1);
    Element elementByID(String p0);
    Iterator nodeIterator();
    List content();
    List processingInstructions();
    List processingInstructions(String p0);
    Node node(int p0);
    ProcessingInstruction processingInstruction(String p0);
    boolean remove(Comment p0);
    boolean remove(Element p0);
    boolean remove(Node p0);
    boolean remove(ProcessingInstruction p0);
    boolean removeProcessingInstruction(String p0);
    int indexOf(Node p0);
    int nodeCount();
    void add(Comment p0);
    void add(Element p0);
    void add(Node p0);
    void add(ProcessingInstruction p0);
    void appendContent(Branch p0);
    void clearContent();
    void normalize();
    void setContent(List p0);
    void setProcessingInstructions(List p0);
}
