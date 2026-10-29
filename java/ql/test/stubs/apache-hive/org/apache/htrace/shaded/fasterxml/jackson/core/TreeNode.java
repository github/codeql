// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.TreeNode for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;

import java.util.Iterator;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonPointer;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonToken;
import org.apache.htrace.shaded.fasterxml.jackson.core.ObjectCodec;

public interface TreeNode
{
    Iterator<String> fieldNames();
    JsonParser traverse();
    JsonParser traverse(ObjectCodec p0);
    JsonParser.NumberType numberType();
    JsonToken asToken();
    TreeNode at(JsonPointer p0);
    TreeNode at(String p0);
    TreeNode get(String p0);
    TreeNode get(int p0);
    TreeNode path(String p0);
    TreeNode path(int p0);
    boolean isArray();
    boolean isContainerNode();
    boolean isMissingNode();
    boolean isObject();
    boolean isValueNode();
    int size();
}
