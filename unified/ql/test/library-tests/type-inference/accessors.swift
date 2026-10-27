// --- Computed properties ---

class AccessorContainer {
  var stored: Int = 0

  var implicitGetter: Int {
    return stored  // $ type=stored:Int field=AccessorContainer.stored
  }

  var explicitGetter: String {
    let value = "accessor"  // $ type=value:String
    return value  // $ type=value:String
  }

  var writable: Int {
    get {
      return stored  // $ type=stored:Int field=AccessorContainer.stored
    }
    set {
      stored = newValue  // $ field=AccessorContainer.stored type=newValue:Int
    }
  }

  var namedSetter: Int {
    get {
      return stored  // $ type=stored:Int field=AccessorContainer.stored
    }
    set(value) {
      stored = value  // $ field=AccessorContainer.stored type=value:Int
    }
  }
}

func testComputedProperties() {
  let container = AccessorContainer()  // $ target=AccessorContainer.init
  let implicitValue = container.implicitGetter  // $ type=implicitValue:Int accessor=AccessorContainer.implicitGetter
  let explicitValue = container.explicitGetter  // $ type=explicitValue:String accessor=AccessorContainer.explicitGetter
  let writableValue = container.writable  // $ type=writableValue:Int accessor=AccessorContainer.writable
  container.writable = 42  // $ accessor=AccessorContainer.writable
  container.writable += 0  // $ accessor=AccessorContainer.writable accessor=AccessorContainer.writable
  let namedValue = container.namedSetter  // $ type=namedValue:Int accessor=AccessorContainer.namedSetter
  container.namedSetter = 43  // $ accessor=AccessorContainer.namedSetter
}

// --- Stored properties with observers ---

class ObservedProperties {
  var observed: Int = 0 {
    willSet {
      let current = observed  // $ type=current:Int field=ObservedProperties.observed accessor=ObservedProperties.observed
      let incoming = newValue  // $ type=incoming:Int
    }
    didSet {
      let current = observed  // $ type=current:Int field=ObservedProperties.observed accessor=ObservedProperties.observed
      let previous = oldValue  // $ type=previous:Int
    }
  }

  var namedObservers: String = "" {
    willSet(incoming) {
      let value = incoming  // $ type=value:String
    }
    didSet(previous) {
      let value = previous  // $ type=value:String
    }
  }
}

func testObservedProperties() {
  let container = ObservedProperties()  // $ target=ObservedProperties.init
  let observed = container.observed  // $ type=observed:Int accessor=ObservedProperties.observed field=ObservedProperties.observed
  container.observed = 42  // $ accessor=ObservedProperties.observed field=ObservedProperties.observed
  let named = container.namedObservers  // $ type=named:String accessor=ObservedProperties.namedObservers field=ObservedProperties.namedObservers
  container.namedObservers = "updated"  // $ accessor=ObservedProperties.namedObservers field=ObservedProperties.namedObservers
}

// --- Generic and inherited accessors ---

class GenericAccessors<T> {
  var stored: T

  init(value: T) {
    stored = value  // $ type=value:T field=GenericAccessors.stored
  }

  var value: T {
    get {
      return stored  // $ type=stored:T field=GenericAccessors.stored
    }
    set {
      stored = newValue  // $ field=GenericAccessors.stored type=newValue:T
    }
  }

  var observed: Int = 0 {
    didSet {
      let current = observed  // $ type=current:Int field=GenericAccessors.observed accessor=GenericAccessors.observed
      let previous = oldValue  // $ type=previous:Int
    }
  }
}

class InheritedAccessors: GenericAccessors<Int> {
  override var observed: Int {
    didSet {
      let current = observed  // $ accessor=InheritedAccessors.observed $ MISSING: type=current:Int field=GenericAccessors.observed -- static name binding is currently unable to resolve the access to the backing field
      let current2 = self.observed  // $ accessor=InheritedAccessors.observed type=current2:Int field=GenericAccessors.observed
      let previous = oldValue  // $ type=previous:Int
    }
  }
}

extension GenericAccessors {
  var extensionValue: T {
    return stored  // $ field=GenericAccessors.stored $ MISSING: type=stored:T
  }
}

func testGenericAccessors() {
  let container = GenericAccessors(value: "value")  // $ target=GenericAccessors.init
  let value = container.value  // $ type=value:String accessor=GenericAccessors.value
  let extensionValue = container.extensionValue  // $ accessor=GenericAccessors.extensionValue $ MISSING: type=extensionValue:String
  let inherited = InheritedAccessors(value: 42)  // $ target=GenericAccessors.init
  let inheritedValue = inherited.value  // $ type=inheritedValue:Int accessor=GenericAccessors.value
  let inheritedObserver = inherited.observed  // $ type=inheritedObserver:Int field=GenericAccessors.observed accessor=InheritedAccessors.observed
}

// --- Protocol accessor requirements ---

protocol AccessorRequirements {
  var readOnly: Int { get }
  var readWrite: String { get set }
}

func testAccessorRequirements(_ value: inout AccessorRequirements) {
  let readOnly = value.readOnly  // $ type=readOnly:Int accessor=AccessorRequirements.readOnly
  let readWrite = value.readWrite  // $ type=readWrite:String accessor=AccessorRequirements.readWrite
  value.readWrite = "updated"  // $ accessor=AccessorRequirements.readWrite
}

// --- Function-valued properties ---
class C {
  var callback: () -> String { { "x" } }

  func f() {
    let result = callback()  // $ type=result:String accessor=C.callback target=Function.callAsFunction
    let result2 = self.callback()  // $ type=result2:String accessor=C.callback target=Function.callAsFunction
  }
}

// --- Static and class accessors ---

class StaticAccessors {
  static var stored: Int = 0

  static var value: Int {
    get {
      return stored  // $ type=stored:Int field=StaticAccessors.stored
    }
    set {
      stored = newValue  // $ field=StaticAccessors.stored type=newValue:Int
    }
  }
}

func testStaticAccessors() {
  let value = StaticAccessors.value  // $ type=value:Int accessor=StaticAccessors.value
  StaticAccessors.value = 42  // $ accessor=StaticAccessors.value
}

class ClassAccessors {
  static var stored: Int = 0

  class var value: Int {
    get {
      return stored  // $ type=stored:Int field=ClassAccessors.stored
    }
    set {
      stored = newValue  // $ field=ClassAccessors.stored type=newValue:Int
    }
  }
}

func testClassAccessors() {
  let value = ClassAccessors.value  // $ type=value:Int accessor=ClassAccessors.value
  ClassAccessors.value = 42  // $ accessor=ClassAccessors.value
}

// --- Top-level accessors ---

var answer: Int { 42 }
let x = answer  // $ type=x:Int accessor=answer
