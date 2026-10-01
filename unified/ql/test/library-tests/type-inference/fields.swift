class FieldBase {
  var inheritedField: Int = 0
}

class FieldContainer<T>: FieldBase {
  var storedField: String = "stored"
  var genericField: T

  init(genericField: T) {
    self.genericField = genericField  // $ type=.genericField:T field=FieldContainer.genericField
  }

  func getStoredField() -> String {
    return storedField  // $ type=storedField:String field=FieldContainer.storedField
  }

  func getGenericField() -> T {
    return self.genericField  // $ type=.genericField:T field=FieldContainer.genericField
  }
}

struct StaticFieldContainer {
  static var staticField: Bool = true
}

struct NestedField {
  var value: Double
}

struct OuterField {
  var nested: NestedField
}

func testFieldAccesses() {
  let container = FieldContainer(genericField: 42)  // $ target=FieldContainer.init
  let stored = container.storedField  // $ type=.storedField:String field=FieldContainer.storedField
  let generic = container.genericField  // $ type=.genericField:Int field=FieldContainer.genericField
  let inherited = container.inheritedField  // $ type=.inheritedField:Int field=FieldBase.inheritedField
  let staticValue = StaticFieldContainer.staticField  // $ type=.staticField:Bool field=StaticFieldContainer.staticField

  let outer = OuterField(nested: NestedField(value: 1.0))  // $ MISSING: target=OuterField.init target=NestedField.init
  let nestedValue = outer.nested.value  // $ MISSING: type=.nested:NestedField field=OuterField.nested type=.value:Double field=NestedField.value
}
