/**
 * Provides the decoded Lua 5.1 bytecode fact model.
 *
 * The model exposes artifacts, profiles, prototypes, constants, diagnostics,
 * and source mappings. Instruction-level and semantic facts are exposed by the
 * corresponding analysis libraries.
 */
class LuaArtifact extends @lua_artifact {
  LuaArtifact() { lua_artifacts(this, _, _, _, _, _, _) }

  string getFixtureId() { lua_artifacts(this, result, _, _, _, _, _) }

  string getPath() { lua_artifacts(this, _, result, _, _, _, _) }

  string getInputKind() { lua_artifacts(this, _, _, result, _, _, _) }

  string getProfileId() { lua_artifacts(this, _, _, _, result, _, _) }

  predicate isAccepted() { lua_artifacts(this, _, _, _, _, 1, _) }

  string getProvenance() { lua_artifacts(this, _, _, _, _, _, result) }

  string toString() { result = this.getPath() }
}

class LuaProfile extends @lua_artifact {
  LuaProfile() { lua_profiles(this, _, _, _, _, _, _, _, _) }

  LuaArtifact getArtifact() { result = this }

  string getVersion() { lua_profiles(this, result, _, _, _, _, _, _, _) }

  int getFormat() { lua_profiles(this, _, result, _, _, _, _, _, _) }

  int isLittleEndian() { lua_profiles(this, _, _, result, _, _, _, _, _) }

  int getIntSize() { lua_profiles(this, _, _, _, result, _, _, _, _) }

  int getSizeTSize() { lua_profiles(this, _, _, _, _, result, _, _, _) }

  int getInstructionSize() { lua_profiles(this, _, _, _, _, _, result, _, _) }

  int getLuaNumberSize() { lua_profiles(this, _, _, _, _, _, _, result, _) }

  int getIntegralFlag() { lua_profiles(this, _, _, _, _, _, _, _, result) }

  string toString() { result = this.getArtifact().toString() }
}

class LuaPrototype extends @lua_prototype {
  LuaPrototype() { lua_prototypes(this, _, _, _, _, _, _, _, _, _, _, _, _) }

  LuaArtifact getArtifact() { lua_prototypes(this, result, _, _, _, _, _, _, _, _, _, _, _) }

  string getFixtureId() { lua_prototypes(this, _, result, _, _, _, _, _, _, _, _, _, _) }

  string getPrototypeId() { lua_prototypes(this, _, _, result, _, _, _, _, _, _, _, _, _) }

  string getParentPrototypeId() { lua_prototypes(this, _, _, _, result, _, _, _, _, _, _, _, _) }

  int getOrdinalIndex() { lua_prototypes(this, _, _, _, _, result, _, _, _, _, _, _, _) }

  int getNumParams() { lua_prototypes(this, _, _, _, _, _, result, _, _, _, _, _, _) }

  int isVararg() { lua_prototypes(this, _, _, _, _, _, _, result, _, _, _, _, _) }

  int getMaxStack() { lua_prototypes(this, _, _, _, _, _, _, _, result, _, _, _, _) }

  int getUpvalueCount() { lua_prototypes(this, _, _, _, _, _, _, _, _, result, _, _, _) }

  string getDebugName() { lua_prototypes(this, _, _, _, _, _, _, _, _, _, result, _, _) }

  string getMappingState() { lua_prototypes(this, _, _, _, _, _, _, _, _, _, _, result, _) }

  string getProvenance() { lua_prototypes(this, _, _, _, _, _, _, _, _, _, _, _, result) }

  string toString() { result = this.getPrototypeId() }
}

class LuaConstant extends @lua_constant {
  LuaConstant() { lua_constants(this, _, _, _, _, _, _, _) }

  LuaPrototype getPrototype() { lua_constants(this, result, _, _, _, _, _, _) }

  string getFixtureId() { lua_constants(this, _, result, _, _, _, _, _) }

  string getConstantId() { lua_constants(this, _, _, result, _, _, _, _) }

  string getPrototypeId() { lua_constants(this, _, _, _, result, _, _, _) }

  int getIndex() { lua_constants(this, _, _, _, _, result, _, _) }

  string getLuaType() { lua_constants(this, _, _, _, _, _, result, _) }

  string getValue() { lua_constants(this, _, _, _, _, _, _, result) }

  string toString() { result = this.getConstantId() }
}

class LuaDiagnostic extends @lua_diagnostic {
  LuaDiagnostic() { lua_diagnostics(this, _, _, _, _, _, _, _, _, _) }

  LuaArtifact getArtifact() { lua_diagnostics(this, result, _, _, _, _, _, _, _, _) }

  string getFixtureId() { lua_diagnostics(this, _, result, _, _, _, _, _, _, _) }

  string getDiagnosticId() { lua_diagnostics(this, _, _, result, _, _, _, _, _, _) }

  string getKind() { lua_diagnostics(this, _, _, _, result, _, _, _, _, _) }

  string getInputRef() { lua_diagnostics(this, _, _, _, _, result, _, _, _, _) }

  string getSeverity() { lua_diagnostics(this, _, _, _, _, _, result, _, _, _) }

  string getMessageCategory() { lua_diagnostics(this, _, _, _, _, _, _, result, _, _) }

  predicate allowsSuccessFacts() { lua_diagnostics(this, _, _, _, _, _, _, _, 1, _) }

  string getProvenance() { lua_diagnostics(this, _, _, _, _, _, _, _, _, result) }

  string toString() { result = this.getDiagnosticId() }
}

class LuaMappingMarker extends @lua_mapping_marker {
  LuaMappingMarker() { lua_mapping_markers(this, _, _, _, _, _) }

  string getFixtureId() { lua_mapping_markers(this, result, _, _, _, _) }

  string getMappingKind() { lua_mapping_markers(this, _, result, _, _, _) }

  string getBytecodeRef() { lua_mapping_markers(this, _, _, result, _, _) }

  string getState() { lua_mapping_markers(this, _, _, _, result, _) }

  string getProvenance() { lua_mapping_markers(this, _, _, _, _, result) }

  string toString() { result = this.getBytecodeRef() }
}
