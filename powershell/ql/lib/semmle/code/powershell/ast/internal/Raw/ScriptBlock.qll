private import Raw

class ScriptBlock extends @script_block, Ast {
  predicate isTopLevel() { not exists(this.getParent()) }

  override Location getLocation() { script_block_location(this, result) }

  int getNumUsings() { script_block(this, result, _, _, _, _) }

  int getNumRequiredModules() { script_block(this, _, result, _, _, _) }

  int getNumRequiredAssemblies() { script_block(this, _, _, result, _, _) }

  int getNumRequiredPsEditions() { script_block(this, _, _, _, result, _) }

  int getNumRequiredPsSnapIns() { script_block(this, _, _, _, _, result) }

  Stmt getUsing(int i) { script_block_using(this, i, result) }

  Stmt getAUsing() { result = this.getUsing(_) }

  ParamBlock getParamBlock() { script_block_param_block(this, result) }

  NamedBlock getBeginBlock() { script_block_begin_block(this, result) }

  NamedBlock getCleanBlock() { script_block_clean_block(this, result) }

  NamedBlock getDynamicParamBlock() { script_block_dynamic_param_block(this, result) }

  NamedBlock getEndBlock() { script_block_end_block(this, result) }

  NamedBlock getProcessBlock() { script_block_process_block(this, result) }

  string getRequiredApplicationId() { script_block_required_application_id(this, result) }

  boolean getRequiresElevation() { script_block_requires_elevation(this, result) }

  string getRequiredPsVersion() { script_block_required_ps_version(this, result) }

  ModuleSpecification getModuleSpecification(int i) {
    script_block_required_module(this, i, result)
  }

  ModuleSpecification getAModuleSpecification() { result = this.getModuleSpecification(_) }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = ScriptBlockUsing(index) and
      result = this.getUsing(index)
    )
    or
    i = ScriptBlockParamBlock() and
    result = this.getParamBlock()
    or
    i = ScriptBlockBeginBlock() and
    result = this.getBeginBlock()
    or
    i = ScriptBlockCleanBlock() and
    result = this.getCleanBlock()
    or
    i = ScriptBlockDynParamBlock() and
    result = this.getDynamicParamBlock()
    or
    i = ScriptBlockEndBlock() and
    result = this.getEndBlock()
    or
    i = ScriptBlockProcessBlock() and
    result = this.getProcessBlock()
  }
}

class TopLevelScriptBlock extends ScriptBlock {
  TopLevelScriptBlock() { this.isTopLevel() }
}
