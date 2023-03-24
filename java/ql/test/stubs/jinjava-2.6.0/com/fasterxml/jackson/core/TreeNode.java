// Generated automatically from com.fasterxml.jackson.core.TreeNode for testing purposes

package com.fasterxml.jackson.core;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonPointer;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.core.ObjectCodec;
import java.util.Iterator;

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
