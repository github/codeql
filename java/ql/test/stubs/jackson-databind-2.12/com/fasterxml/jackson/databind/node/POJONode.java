package com.fasterxml.jackson.databind.node;

import com.fasterxml.jackson.databind.JsonNode;
import java.util.List;

public class POJONode extends ValueNode {
    protected final Object _value;

    public POJONode(Object v) {
        _value = v;
    }

    @Override
    public boolean equals(Object o) {
        return false;
    }

    public String toString() {
        return null;
    }

    @Override
    public <T extends JsonNode> T deepCopy() {
        return null;
    }

    @Override
    public JsonNode get(int index) {
        return null;
    }
  
    @Override
    public JsonNode path(String fieldName) {
        return null;
    }
  
    @Override
    public JsonNode path(int index) {
        return null;
    }

    @Override
    public String asText() {
        return null;
    }

    @Override
    public JsonNode findValue(String fieldName) {
        return null;
    }

    @Override
    public JsonNode findPath(String fieldName) {
        return null;
    }

    @Override
    public JsonNode findParent(String fieldName) {
        return null;
    }

    @Override
    public List<JsonNode> findValues(String fieldName, List<JsonNode> foundSoFar) {
        return null;
    }

    @Override
    public List<String> findValuesAsText(String fieldName, List<String> foundSoFar) {
        return null;
    }

    @Override
    public List<JsonNode> findParents(String fieldName, List<JsonNode> foundSoFar) {
        return null;
    }
}
