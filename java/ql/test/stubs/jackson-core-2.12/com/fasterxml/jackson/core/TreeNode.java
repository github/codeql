/*
 * Jackson JSON-processor.
 *
 * Copyright (c) 2007- Tatu Saloranta, tatu.saloranta@iki.fi
 */

package com.fasterxml.jackson.core;

import java.util.Iterator;

public interface TreeNode {
    default JsonParser.NumberType numberType() {
        return null;
    }

    int size();

    boolean isValueNode();

    boolean isContainerNode();

    boolean isMissingNode();

    boolean isArray();

    boolean isObject();

    TreeNode get(String fieldName);

    TreeNode get(int index);

    TreeNode path(String fieldName);

    TreeNode path(int index);

    Iterator<String> fieldNames();

    TreeNode at(String jsonPointerExpression) throws IllegalArgumentException;

    default JsonParser traverse() {
        return null;
    }

}
