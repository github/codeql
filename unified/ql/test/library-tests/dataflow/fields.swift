func source(_ s: String) -> String { return s }

@discardableResult
func sink(_ s: Any) -> String { return "" }

class FieldBox {
    var field: String = ""

    func setField(_ value: String) {
        self.field = value
    }
}

class OtherFieldBox {
    var field: String = ""
}

class InheritedFieldBox: FieldBox {}

func resolvedFields() {
    let box = FieldBox()
    box.field = source("fields.resolved")
    sink(box.field)  // $ hasValueFlow=fields.resolved
    sink((box as! OtherFieldBox).field)
}

func postfixConditionalFieldWrite() {
    let box = FieldBox()
    box
        #if FIRST
            .setField(source("fields.postfix-write"))
        #endif
    sink(box.field)  // $ MISSING: hasValueFlow=fields.postfix-write (aliasing)
}

func inheritedFields() {
    let box = InheritedFieldBox()
    box.field = source("fields.inherited")
    sink((box as! FieldBox).field)  // $ hasValueFlow=fields.inherited
}

func unresolvedFieldRead() {
    let box = FieldBox()
    box.field = source("fields.unresolved-read")
    sink((box as! UnknownFieldBox).field)  // $ hasValueFlow=fields.unresolved-read
}

func unresolvedFieldStore() {
    let box = FieldBox()
    (box as! UnknownFieldBox).field = source("fields.unresolved-store")
    sink(box.field)  // $ hasValueFlow=fields.unresolved-store
}

func summarizedFieldRead() {
    let box = FieldBox()
    box.field = source("fields.summary")
    sink(TestType.readField(box))  // $ hasValueFlow=fields.summary
}

class BaseBox {
    var field: String = ""
}

class OverridingBox: BaseBox {
    override var field: String {
        get { super.field }
        set { super.field = newValue }
    }
}

func overriddenFieldRead() {
    let base: BaseBox = OverridingBox()
    base.field = source("fields.override-read")
    let sub = base as! OverridingBox
    sink(sub.field)  // $ hasValueFlow=fields.override-read
}

protocol FieldProtocol {
    var field: String { get set }
}

class ProtocolBox: FieldProtocol {
    var field: String = ""
}

class ProtocolBox2: FieldProtocol {
    var field: String = ""
}

func protocolFieldRead() {
    let box = ProtocolBox()
    box.field = source("fields.protocol")
    sink(box.field)  // $ hasValueFlow=fields.protocol
    let p = box as FieldProtocol
    sink(p.field)  // $ hasValueFlow=fields.protocol
    let box2 = box as! ProtocolBox2
    sink(box2.field)
    let box1or2 = 2 > 3 ? box as FieldProtocol : box2
    sink(box1or2.field)  // $ hasValueFlow=fields.protocol
}

func protocolFieldWrite() {
    let box = ProtocolBox()
    var p = box as FieldProtocol
    p.field = source("fields.protocol")
    sink(p.field)  // $ hasValueFlow=fields.protocol
    sink(box.field)  // $ MISSING: hasValueFlow=fields.protocol (aliasing)
    let box2 = p as! OtherFieldBox
    sink(box2.field)  // $ SPURIOUS: hasValueFlow=fields.protocol
}

extension FieldBox {
    func withField(_ value: String) -> FieldBox {
        let box = FieldBox()
        box.field = value
        return box
    }

    func keep() -> FieldBox {
        return self
    }
}

func postfixConditionalValueFlow() {
    let branches = FieldBox()
        #if FIRST
            .withField(source("fields.postfix-if"))
        #else
            .withField(source("fields.postfix-else"))
        #endif
    sink(branches.field)  // $ hasValueFlow=fields.postfix-if hasValueFlow=fields.postfix-else

    let noElse = FieldBox().withField(source("fields.postfix-no-else"))
        #if FIRST
            .withField("clean")
        #endif
    sink(noElse.field)  // $ hasValueFlow=fields.postfix-no-else

    let emptyBranch = FieldBox().withField(source("fields.postfix-empty"))
        #if FIRST
            .withField("clean")
        #else
        #endif
    sink(emptyBranch.field)  // $ hasValueFlow=fields.postfix-empty

    let inChain = FieldBox()
        #if FIRST
            .withField(source("fields.postfix-in-chain"))
        #endif
        .field
    sink(inChain)  // $ hasValueFlow=fields.postfix-in-chain

    let nested = FieldBox().withField(source("fields.postfix-nested-base"))
        #if FIRST
            .keep()
            #if SECOND
                .withField(source("fields.postfix-nested-inner"))
            #endif
        #endif
    sink(nested.field)  // $ hasValueFlow=fields.postfix-nested-base hasValueFlow=fields.postfix-nested-inner

    let nestedNoBase = FieldBox().withField(source("fields.postfix-nested-nobase"))
        #if FIRST
            #if SECOND
                .withField(source("fields.postfix-nested-nobase-inner"))
            #endif
        #endif
    sink(nestedNoBase.field)  // $ hasValueFlow=fields.postfix-nested-nobase hasValueFlow=fields.postfix-nested-nobase-inner

    let chain = FieldBox().withField(source("fields.postfix-chain-base"))
        #if FIRST
            #if SECOND
                .withField(source("fields.postfix-chain-second"))
            #endif
            #if THIRD
                .withField(source("fields.postfix-chain-third"))
            #endif
        #endif
    sink(chain.field)  // $ hasValueFlow=fields.postfix-chain-base hasValueFlow=fields.postfix-chain-second hasValueFlow=fields.postfix-chain-third
}
