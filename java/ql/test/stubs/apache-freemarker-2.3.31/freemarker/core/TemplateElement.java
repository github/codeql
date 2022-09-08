// Generated automatically from freemarker.core.TemplateElement for testing purposes

package freemarker.core;

import freemarker.core.TemplateObject;
import freemarker.template.TemplateNodeModel;
import freemarker.template.TemplateSequenceModel;
import java.util.Enumeration;
import javax.swing.tree.TreeNode;

abstract public class TemplateElement extends TemplateObject implements TreeNode
{
    protected abstract String dump(boolean p0);
    public Enumeration children(){ return null; }
    public String getNodeName(){ return null; }
    public String getNodeNamespace(){ return null; }
    public String getNodeType(){ return null; }
    public TemplateElement(){}
    public TemplateNodeModel getParentNode(){ return null; }
    public TemplateSequenceModel getChildNodes(){ return null; }
    public TreeNode getChildAt(int p0){ return null; }
    public TreeNode getParent(){ return null; }
    public boolean getAllowsChildren(){ return false; }
    public boolean isLeaf(){ return false; }
    public final String getCanonicalForm(){ return null; }
    public final String getDescription(){ return null; }
    public int getChildCount(){ return 0; }
    public int getIndex(TreeNode p0){ return 0; }
    public void setChildAt(int p0, TemplateElement p1){}
}
