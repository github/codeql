
// --- stubs ---

protocol View {
}

struct Binding<Value> {
}

@propertyWrapper
struct State<Value> { // an @State
	var wrappedValue: Value
	var projectedValue: Binding<Value> { get { return 0 as! Binding<Value> } } // what you get with `$`
}

struct LocalizedStringKey : ExpressibleByStringLiteral {
	typealias StringLiteralType = String

	init(stringLiteral value: Self.StringLiteralType) {
	}
}

struct Label<Title, Icon> : View where Title : View, Icon : View {
}

struct Text : View {
}

struct TextField<Label> : View where Label : View {
	init(_ titleKey: LocalizedStringKey, text: Binding<String>) where Label == Text { }
}

struct SecureField<Label> : View where Label : View {
	init(_ titleKey: LocalizedStringKey, text: Binding<String>, prompt: Text?) where Label == Text { }
}

struct TextEditor : View {
	init(text: Binding<String>) { }
}

struct SubmitTriggers {
  init(rawValue: UInt) {
    self.rawValue = rawValue
  }

  var rawValue: UInt

  static let text = SubmitTriggers(rawValue: 1)
}

extension View {
	func onSubmit(
		of triggers: SubmitTriggers = .text,
		_ action: @escaping (() -> Void)
		) -> some View {
		return self
	}
}

// --- tests ---

func sink(arg: Any) { }

func mkHarmlessBinding(text: Binding<String>) { }

struct MyStruct {
	@State var input: String = "default value"
	@State var harmless: String = "default value"
	@State var harmless2: String = "default value"

	var myView1: some View {
		TextField("title", text: $input)
		.onSubmit {
			sink(arg: input) // $ MISSING: tainted
			sink(arg: harmless)
			mkHarmlessBinding(text: $harmless2)
			sink(arg: harmless2)
		}
	}

	@State var secureInput: String = "default value"

	var myView2: some View {
		SecureField("title", text: $secureInput, prompt: nil)
		.onSubmit {
			sink(arg: secureInput) // $ MISSING: tainted
		}
	}

	@State var longInput: String = "default value"

	var myView3: some View {
		TextEditor(text: $longInput)
		.onSubmit {
			sink(arg: longInput) // $ MISSING: tainted
		}
	}
}
