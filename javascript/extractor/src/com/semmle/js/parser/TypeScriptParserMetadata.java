package com.semmle.js.parser;

import java.util.LinkedHashMap;
import java.util.Map;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

/**
 * Static data from the TypeScript compiler needed for decoding ASTs.
 * <p>
 * AST nodes store their kind and flags as integers, but the meaning of this integer changes
 * between compiler versions. The metadata contains mappings from integers to logical names
 * which are stable across versions.
 */
public class TypeScriptParserMetadata {
  private final JsonObject nodeFlags;
  private final JsonObject syntaxKinds;
  private final Map<Integer, String> nodeFlagMap = new LinkedHashMap<>();
  private final Map<Integer, String> syntaxKindMap = new LinkedHashMap<>();

  public TypeScriptParserMetadata(JsonObject metadata) {
    this.nodeFlags = metadata.get("nodeFlags").getAsJsonObject();
    this.syntaxKinds = metadata.get("syntaxKinds").getAsJsonObject();
    makeEnumIdMap(getNodeFlags(), getNodeFlagMap());
    makeEnumIdMap(getSyntaxKinds(), getSyntaxKindMap());
  }

  /** Builds a mapping from ID to name given a TypeScript enum object. */
  private void makeEnumIdMap(JsonObject enumObject, Map<Integer, String> idToName) {
    for (Map.Entry<String, JsonElement> entry : enumObject.entrySet()) {
      JsonPrimitive prim = entry.getValue().getAsJsonPrimitive();
      if (prim.isNumber() && !idToName.containsKey(prim.getAsInt())) {
        idToName.put(prim.getAsInt(), entry.getKey());
      }
    }
  }

  /**
   * Returns the <code>NodeFlags</code> enum object from the TypeScript API.
   */
  public JsonObject getNodeFlags() {
    return nodeFlags;
  }

  /**
   * Returns the <code>SyntaxKind</code> enum object from the TypeScript API.
   */
  public JsonObject getSyntaxKinds() {
    return syntaxKinds;
  }

  /**
   * Returns the mapping from node flag bit to its name.
   */
  public Map<Integer, String> getNodeFlagMap() {
    return nodeFlagMap;
  }

  /**
   * Returns the mapping from syntax kind ID to its name.
   */
  public Map<Integer, String> getSyntaxKindMap() {
    return syntaxKindMap;
  }
}
