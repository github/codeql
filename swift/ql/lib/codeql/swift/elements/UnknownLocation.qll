private import codeql.swift.generated.UnknownLocation
private import codeql.swift.elements.UnknownFile
private import codeql.swift.elements.File

class UnknownLocation extends UnknownLocationBase {
  override File getImmediateFile() { result instanceof UnknownFile }

  override int getStartLine() { result = 0 }

  override int getStartColumn() { result = 0 }

  override int getEndLine() { result = 0 }

  override int getEndColumn() { result = 0 }
}
