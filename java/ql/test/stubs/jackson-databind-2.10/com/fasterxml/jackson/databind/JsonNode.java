package com.fasterxml.jackson.databind;

import java.util.*;
import com.fasterxml.jackson.core.TreeNode;

public abstract class JsonNode implements TreeNode, Iterable<JsonNode> {
    public JsonNode() {}
}
