// --- stubs ---

class NSObject { }

struct _NSRange { }

typealias NSRange = _NSRange

class NSAttributedString: NSObject { }

class UIResponder: NSObject { }

class UIView: UIResponder { }

class UIControl: UIView { }

class UITextRange : NSObject {
}

protocol UITextInput {
	func text(in range: UITextRange) -> String?

  func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool
}

class UITextField: UIControl {
  var text: String? {
    get { nil }
    set { }
  }

  var attributedText: NSAttributedString? {
    get { nil }
    set { }
  }

  var placeholder: String? {
    get { nil }
    set { }
  }
}

class UISearchTextField : UITextField {
}

protocol UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

// --- tests ---

func sink(arg: Any) { }

class MyTextInput : UITextInput {
	func text(in range: UITextRange) -> String? { return nil }
	func harmless(in range: UITextRange) -> String? { return nil }

	func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool { // $ source=local
		sink(arg: text) // $ tainted

		return true
	}
}

class MyUITextFieldDelegate : UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // $ source=local
		sink(arg: string) // $ tainted

		return true
	}
}

func test(
    textField: UITextField,
    searchTextField: UISearchTextField,
    myTextInput: MyTextInput,
    range: UITextRange,
    protocolTextInput: UITextInput) {
  _ = textField.text // $ source=local
  _ = textField.attributedText // $ source=local
  _ = textField.placeholder // GOOD (not input)
  _ = textField.text?.uppercased() // $ source=local
  _ = searchTextField.text // $ source=local

  _ = myTextInput.text(in: range)! // $ source=local
  _ = myTextInput.harmless(in: range)! // GOOD (not input)

  let str = protocolTextInput.text(in: range)! // $ source=local
  sink(arg: str) // $ tainted
}
