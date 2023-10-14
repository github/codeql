/**
 * Provides models for the `UITextField` and related Swift class.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `UITextField`, `UITextInput` and related class members that are flow sources.
 */
private class UITextFieldSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";UITextField;true;text;;;;local", ";UITextField;true;attributedText;;;;local",
        ";UITextFieldDelegate;true;textField(_:shouldChangeCharactersIn:replacementString:);;;Parameter[2];local",
        ";UITextViewDelegate;true;textView(_:shouldChangeTextIn:replacementText:);;;Parameter[2];local",
        ";UITextInput;true;text(in:);;;ReturnValue;local",
        ";UITextInput;true;shouldChangeText(in:replacementText:);;;Parameter[1];local",
      ]
  }
}
