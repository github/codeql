/**
 * Provides models for the `UITextField` Swift class.
 */

import swift
private import codeql.swift.dataflow.ExternalFlow

/**
 * A model for `UITextField` members that are flow sources.
 */
private class UITextFieldSource extends SourceModelCsv {
  override predicate row(string row) {
    row = [";UITextField;true;text;;;;local", ";UITextField;true;attributedText;;;;local"]
  }
}
