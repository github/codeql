package com.semmle.ts.extractor;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.semmle.util.trap.TrapWriter;
import com.semmle.util.trap.TrapWriter.Label;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Extracts type and symbol information into TRAP files.
 *
 * <p>This is closely coupled with the <code>type_table.ts</code> file in the parser-wrapper. Type
 * strings and symbol strings generated in that file are parsed here. See that file for reference
 * and documentation.
 */
public class TypeExtractor {
  private final TrapWriter trapWriter;
  private final TypeTable table;

  private static final Map<String, Integer> tagToKind = new LinkedHashMap<String, Integer>();

  private static final int referenceKind = 6;
  private static final int objectKind = 7;
  private static final int typevarKind = 8;
  private static final int typeofKind = 9;
  private static final int uniqueSymbolKind = 15;
  private static final int tupleKind = 18;
  private static final int lexicalTypevarKind = 19;
  private static final int thisKind = 20;
  private static final int numberLiteralTypeKind = 21;
  private static final int stringLiteralTypeKind = 22;
  private static final int bigintLiteralTypeKind = 25;

  static {
    tagToKind.put("any", 0);
    tagToKind.put("string", 1);
    tagToKind.put("number", 2);
    tagToKind.put("union", 3);
    tagToKind.put("true", 4);
    tagToKind.put("false", 5);
    tagToKind.put("reference", referenceKind);
    tagToKind.put("object", objectKind);
    tagToKind.put("typevar", typevarKind);
    tagToKind.put("typeof", typeofKind);
    tagToKind.put("void", 10);
    tagToKind.put("undefined", 11);
    tagToKind.put("null", 12);
    tagToKind.put("never", 13);
    tagToKind.put("plainsymbol", 14);
    tagToKind.put("uniquesymbol", uniqueSymbolKind);
    tagToKind.put("objectkeyword", 16);
    tagToKind.put("intersection", 17);
    tagToKind.put("tuple", tupleKind);
    tagToKind.put("lextypevar", lexicalTypevarKind);
    tagToKind.put("this", thisKind);
    tagToKind.put("numlit", numberLiteralTypeKind);
    tagToKind.put("strlit", stringLiteralTypeKind);
    tagToKind.put("unknown", 23);
    tagToKind.put("bigint", 24);
    tagToKind.put("bigintlit", bigintLiteralTypeKind);
  }

  private static final Map<String, Integer> symbolKind = new LinkedHashMap<String, Integer>();

  static {
    symbolKind.put("root", 0);
    symbolKind.put("member", 1);
    symbolKind.put("other", 2);
  }

  public TypeExtractor(TrapWriter trapWriter, TypeTable table) {
    this.trapWriter = trapWriter;
    this.table = table;
  }

  public void extract() {
    for (int i = 0; i < table.getNumberOfTypes(); ++i) {
      extractType(i);
    }
    extractPropertyLookups(table.getPropertyLookups());
    extractTypeAliases(table.getTypeAliases());
    for (int i = 0; i < table.getNumberOfSymbols(); ++i) {
      extractSymbol(i);
    }
    extractSymbolNameMapping("symbol_module", table.getModuleMappings());
    extractSymbolNameMapping("symbol_global", table.getGlobalMappings());
    extractSignatureMappings(table.getSignatureMappings());
    for (int i = 0; i < table.getNumberOfSignatures(); ++i) {
      extractSignature(i);
    }
    extractIndexTypeTable(table.getNumberIndexTypes(), "number_index_type");
    extractIndexTypeTable(table.getStringIndexTypes(), "string_index_type");
    extractBaseTypes(table.getBaseTypes());
    extractSelfTypes(table.getSelfTypes());
  }

  private void extractType(int id) {
    Label lbl = trapWriter.globalID("type;" + id);
    String contents = table.getTypeString(id);
    String[] parts = split(contents);
    int kind = tagToKind.get(parts[0]);
    trapWriter.addTuple("types", lbl, kind, table.getTypeToStringValue(id));
    int firstChild = 1;
    switch (kind) {
      case referenceKind:
      case typevarKind:
      case typeofKind:
      case uniqueSymbolKind:
        {
          // The first part of a reference is the symbol for name binding.
          Label symbol = trapWriter.globalID("symbol;" + parts[1]);
          trapWriter.addTuple("type_symbol", lbl, symbol);
          ++firstChild;
          break;
        }
      case tupleKind:
        {
          // The first two parts denote minimum length and index of rest element (or -1 if no rest element).
          trapWriter.addTuple("tuple_type_min_length", lbl, Integer.parseInt(parts[1]));
          int restIndex = Integer.parseInt(parts[2]);
          if (restIndex != -1) {
            trapWriter.addTuple("tuple_type_rest_index", lbl, restIndex);
          }
          firstChild += 2;
          break;
        }
      case objectKind:
      case lexicalTypevarKind:
        firstChild = parts.length; // No children.
        break;

      case numberLiteralTypeKind:
      case stringLiteralTypeKind:
      case bigintLiteralTypeKind:
        firstChild = parts.length; // No children.
        // The string value may contain `;` so don't use the split().
        String value = contents.substring(parts[0].length() + 1);
        trapWriter.addTuple("type_literal_value", lbl, value);
        break;
    }
    for (int i = firstChild; i < parts.length; ++i) {
      Label childLabel = trapWriter.globalID("type;" + parts[i]);
      trapWriter.addTuple("type_child", childLabel, lbl, i - firstChild);
    }
  }

  private void extractPropertyLookups(JsonObject lookups) {
    JsonArray baseTypes = lookups.get("baseTypes").getAsJsonArray();
    JsonArray names = lookups.get("names").getAsJsonArray();
    JsonArray propertyTypes = lookups.get("propertyTypes").getAsJsonArray();
    for (int i = 0; i < baseTypes.size(); ++i) {
      int baseType = baseTypes.get(i).getAsInt();
      String name = names.get(i).getAsString();
      int propertyType = propertyTypes.get(i).getAsInt();
      trapWriter.addTuple(
          "type_property",
          trapWriter.globalID("type;" + baseType),
          name,
          trapWriter.globalID("type;" + propertyType));
    }
  }

  private void extractTypeAliases(JsonObject aliases) {
    JsonArray aliasTypes = aliases.get("aliasTypes").getAsJsonArray();
    JsonArray underlyingTypes = aliases.get("underlyingTypes").getAsJsonArray();
    for (int i = 0; i < aliasTypes.size(); ++i) {
      int aliasType = aliasTypes.get(i).getAsInt();
      int underlyingType = underlyingTypes.get(i).getAsInt();
      trapWriter.addTuple(
          "type_alias",
          trapWriter.globalID("type;" + aliasType),
          trapWriter.globalID("type;" + underlyingType));
    }
  }

  private void extractSymbol(int index) {
    // Format is: kind;decl;parent;name
    String[] parts = split(table.getSymbolString(index), 4);
    int kind = symbolKind.get(parts[0]);
    String name = parts[3];
    Label label = trapWriter.globalID("symbol;" + index);
    trapWriter.addTuple("symbols", label, kind, name);
    String parentStr = parts[2];
    if (parentStr.length() > 0) {
      Label parentLabel = trapWriter.globalID("symbol;" + parentStr);
      trapWriter.addTuple("symbol_parent", label, parentLabel);
    }
  }

  private void extractSymbolNameMapping(String relationName, JsonObject mappings) {
    JsonArray symbols = mappings.get("symbols").getAsJsonArray();
    JsonArray names = mappings.get("names").getAsJsonArray();
    for (int i = 0; i < symbols.size(); ++i) {
      Label symbol = trapWriter.globalID("symbol;" + symbols.get(i).getAsInt());
      String moduleName = names.get(i).getAsString();
      trapWriter.addTuple(relationName, symbol, moduleName);
    }
  }

  private void extractSignature(int index) {
    // Format is:
    // kind;isAbstract;numTypeParams;requiredParams;restParamType;returnType(;paramName;paramType)*
    String[] parts = split(table.getSignatureString(index));
    Label label = trapWriter.globalID("signature;" + index);
    int kind = Integer.parseInt(parts[0]);
    boolean isAbstract = parts[1].equals("t");
    if (isAbstract) {
      trapWriter.addTuple("is_abstract_signature", label);
    }
    int numberOfTypeParameters = Integer.parseInt(parts[2]);
    int requiredParameters = Integer.parseInt(parts[3]);
    String restParamTypeTag = parts[4];
    if (!restParamTypeTag.isEmpty()) {
      trapWriter.addTuple(
          "signature_rest_parameter", label, trapWriter.globalID("type;" + restParamTypeTag));
    }
    Label returnType = trapWriter.globalID("type;" + parts[5]);
    trapWriter.addTuple(
        "signature_types",
        label,
        kind,
        table.getSignatureToStringValue(index),
        numberOfTypeParameters,
        requiredParameters);
    trapWriter.addTuple("signature_contains_type", returnType, label, -1);
    int numberOfParameters = (parts.length - 6) / 2; // includes type parameters
    for (int i = 0; i < numberOfParameters; ++i) {
      int partIndex = 6 + (2 * i);
      String paramName = parts[partIndex];
      String paramTypeId = parts[partIndex + 1];
      if (paramTypeId.length() > 0) { // Unconstrained type parameters have an empty type ID.
        Label paramType = trapWriter.globalID("type;" + parts[partIndex + 1]);
        trapWriter.addTuple("signature_contains_type", paramType, label, i);
      }
      trapWriter.addTuple("signature_parameter_name", label, i, paramName);
    }
  }

  private void extractSignatureMappings(JsonObject mappings) {
    JsonArray baseTypes = mappings.get("baseTypes").getAsJsonArray();
    JsonArray kinds = mappings.get("kinds").getAsJsonArray();
    JsonArray indices = mappings.get("indices").getAsJsonArray();
    JsonArray signatures = mappings.get("signatures").getAsJsonArray();
    for (int i = 0; i < baseTypes.size(); ++i) {
      int baseType = baseTypes.get(i).getAsInt();
      int kind = kinds.get(i).getAsInt();
      int index = indices.get(i).getAsInt();
      int signatureId = signatures.get(i).getAsInt();
      trapWriter.addTuple(
          "type_contains_signature",
          trapWriter.globalID("type;" + baseType),
          kind,
          index,
          trapWriter.globalID("signature;" + signatureId));
    }
  }

  private void extractIndexTypeTable(JsonObject table, String relationName) {
    JsonArray baseTypes = table.get("baseTypes").getAsJsonArray();
    JsonArray propertyTypes = table.get("propertyTypes").getAsJsonArray();
    for (int i = 0; i < baseTypes.size(); ++i) {
      int baseType = baseTypes.get(i).getAsInt();
      int propertyType = propertyTypes.get(i).getAsInt();
      trapWriter.addTuple(
          relationName,
          trapWriter.globalID("type;" + baseType),
          trapWriter.globalID("type;" + propertyType));
    }
  }

  private void extractBaseTypes(JsonObject table) {
    JsonArray symbols = table.get("symbols").getAsJsonArray();
    JsonArray baseTypeSymbols = table.get("baseTypeSymbols").getAsJsonArray();
    for (int i = 0; i < symbols.size(); ++i) {
      int symbolId = symbols.get(i).getAsInt();
      int baseTypeSymbolId = baseTypeSymbols.get(i).getAsInt();
      trapWriter.addTuple(
          "base_type_names",
          trapWriter.globalID("symbol;" + symbolId),
          trapWriter.globalID("symbol;" + baseTypeSymbolId));
    }
  }

  private void extractSelfTypes(JsonObject table) {
    JsonArray symbols = table.get("symbols").getAsJsonArray();
    JsonArray selfTypes = table.get("selfTypes").getAsJsonArray();
    for (int i = 0; i < symbols.size(); ++i) {
      int symbolId = symbols.get(i).getAsInt();
      int typeId = selfTypes.get(i).getAsInt();
      trapWriter.addTuple(
          "self_types",
          trapWriter.globalID("symbol;" + symbolId),
          trapWriter.globalID("type;" + typeId));
    }
  }

  /** Like {@link #split(String)} without a limit. */
  private static String[] split(String input) {
    return split(input, -1);
  }

  /**
   * Splits the input around the semicolon (<code>;</code>) character, preserving all empty
   * substrings.
   *
   * <p>At most <code>limit</code> substrings will be extracted. If the limit is reached, the last
   * substring will extend to the end of the string, possibly itself containing semicolons.
   *
   * <p>Note that the {@link String#split(String)} method does not preserve empty substrings at the
   * end of the string in case the string ends with a semicolon.
   */
  private static String[] split(String input, int limit) {
    List<String> result = new ArrayList<String>();
    int lastPos = 0;
    for (int i = 0; i < input.length(); ++i) {
      if (input.charAt(i) == ';') {
        result.add(input.substring(lastPos, i));
        lastPos = i + 1;
        if (result.size() == limit - 1) break;
      }
    }
    result.add(input.substring(lastPos));
    return result.toArray(EMPTY_STRING_ARRAY);
  }

  private static final String[] EMPTY_STRING_ARRAY = new String[0];
}
