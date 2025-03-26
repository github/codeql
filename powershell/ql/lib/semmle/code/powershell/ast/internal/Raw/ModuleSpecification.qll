private import Raw

class ModuleSpecification extends @module_specification {
  string toString() { result = this.getName() }

  string getName() { module_specification(this, result, _, _, _, _) }

  string getGuid() { module_specification(this, _, result, _, _, _) }

  string getMaxVersion() { module_specification(this, _, _, result, _, _) }

  string getRequiredVersion() { module_specification(this, _, _, _, result, _) }

  string getVersion() { module_specification(this, _, _, _, _, result) }

  Location getLocation() { result instanceof EmptyLocation }
}
