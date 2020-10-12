package com.semmle.ts.extractor;

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
  private final Map<Integer, String> syntaxKindMap = new LinkedHashMap<>();

  public TypeScriptParserMetadata(JsonObject metadata) {
    this.nodeFlags = metadata.get("nodeFlags").getAsJsonObject();
    this.syntaxKinds = metadata.get("syntaxKinds").getAsJsonObject();
    makeEnumIdMap(syntaxKinds, syntaxKindMap);
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
   * Returns the logical name associated with syntax kind ID <code>id</code>,
   * or throws an exception if it does not exist.
   */
  String getSyntaxKindName(int id) {
    String name = syntaxKindMap.get(id);
    if (name == null) {
      throw new RuntimeException(
          "Incompatible version of TypeScript installed. Missing syntax kind ID " + id);
    }
    return name;
  }

  /**
   * Returns the syntax kind ID corresponding to the logical name <code>name</code>,
   * or throws an exception if it does not exist.
   */
  int getSyntaxKindId(String name) {
    JsonElement elm = syntaxKinds.get(name);
    if (elm == null) {
      throw new RuntimeException(
          "Incompatible version of TypeScript installed. Missing syntax kind " + name);
    }
    return elm.getAsInt();
  }

  /**
   * Returns the NodeFlag ID from the logical name <code>name</code>
   * or throws an exception if it does not exist.
   */
  int getNodeFlagId(String name) {
    JsonElement elm = nodeFlags.get(name);
    if (elm == null) {
      throw new RuntimeException(
          "Incompatible version of TypeScript installed. Missing node flag " + name);
    }
    return elm.getAsInt();
  }
}
