// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.TreeCodec for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.core.TreeNode;

abstract public class TreeCodec
{
    public TreeCodec(){}
    public abstract <T extends TreeNode> T readTree(JsonParser p0);
    public abstract JsonParser treeAsTokens(TreeNode p0);
    public abstract TreeNode createArrayNode();
    public abstract TreeNode createObjectNode();
    public abstract void writeTree(JsonGenerator p0, TreeNode p1);
}
