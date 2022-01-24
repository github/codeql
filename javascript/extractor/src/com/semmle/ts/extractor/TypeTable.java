package com.semmle.ts.extractor;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * Holds the output of the <code>get-type-table</code> command.
 *
 * <p>See documentation in <code>parser-wrapper/src/type_table.ts</code>.
 */
public class TypeTable {
  private final JsonArray typeStrings;
  private final JsonArray typeToStringValues;
  private final JsonObject propertyLookups;
  private final JsonObject typeAliases;
  private final JsonArray symbolStrings;
  private final JsonObject moduleMappings;
  private final JsonObject globalMappings;
  private final JsonArray signatureStrings;
  private final JsonObject signatureMappings;
  private final JsonArray signatureToStringValues;
  private final JsonObject stringIndexTypes;
  private final JsonObject numberIndexTypes;
  private final JsonObject baseTypes;
  private final JsonObject selfTypes;

  public TypeTable(JsonObject typeTable) {
    this.typeStrings = typeTable.get("typeStrings").getAsJsonArray();
    this.typeToStringValues = typeTable.get("typeToStringValues").getAsJsonArray();
    this.propertyLookups = typeTable.get("propertyLookups").getAsJsonObject();
    this.typeAliases = typeTable.get("typeAliases").getAsJsonObject();
    this.symbolStrings = typeTable.get("symbolStrings").getAsJsonArray();
    this.moduleMappings = typeTable.get("moduleMappings").getAsJsonObject();
    this.globalMappings = typeTable.get("globalMappings").getAsJsonObject();
    this.signatureStrings = typeTable.get("signatureStrings").getAsJsonArray();
    this.signatureMappings = typeTable.get("signatureMappings").getAsJsonObject();
    this.signatureToStringValues = typeTable.get("signatureToStringValues").getAsJsonArray();
    this.numberIndexTypes = typeTable.get("numberIndexTypes").getAsJsonObject();
    this.stringIndexTypes = typeTable.get("stringIndexTypes").getAsJsonObject();
    this.baseTypes = typeTable.get("baseTypes").getAsJsonObject();
    this.selfTypes = typeTable.get("selfTypes").getAsJsonObject();
  }

  public String getTypeString(int index) {
    return typeStrings.get(index).getAsString();
  }

  public String getTypeToStringValue(int index) {
    return typeToStringValues.get(index).getAsString();
  }

  public JsonObject getPropertyLookups() {
    return propertyLookups;
  }

  public JsonObject getTypeAliases() {
    return typeAliases;
  }

  public int getNumberOfTypes() {
    return typeStrings.size();
  }

  public String getSymbolString(int index) {
    return symbolStrings.get(index).getAsString();
  }

  public int getNumberOfSymbols() {
    return symbolStrings.size();
  }

  public JsonObject getModuleMappings() {
    return moduleMappings;
  }

  public JsonObject getGlobalMappings() {
    return globalMappings;
  }

  public JsonArray getSignatureStrings() {
    return signatureStrings;
  }

  public int getNumberOfSignatures() {
    return signatureStrings.size();
  }

  public String getSignatureString(int i) {
    return signatureStrings.get(i).getAsString();
  }

  public JsonObject getSignatureMappings() {
    return signatureMappings;
  }

  public JsonArray getSignatureToStringValues() {
    return signatureToStringValues;
  }

  public String getSignatureToStringValue(int i) {
    return signatureToStringValues.get(i).getAsString();
  }

  public JsonObject getNumberIndexTypes() {
    return numberIndexTypes;
  }

  public JsonObject getStringIndexTypes() {
    return stringIndexTypes;
  }

  public JsonObject getBaseTypes() {
    return baseTypes;
  }

  public JsonObject getSelfTypes() {
    return selfTypes;
  }
}
