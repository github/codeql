import javascript

query Parameter getDependencyParameter(AmdModuleDefinition mod, string name) {
  result = mod.getDependencyParameter(name)
}

from AmdModuleDefinition d
select d, d.getFactoryNode()
