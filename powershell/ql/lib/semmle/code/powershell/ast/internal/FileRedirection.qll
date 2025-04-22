private import AstImport

class FileRedirection extends Redirection {
  FileRedirection() { this = TRedirection(any(Raw::FileRedirection r)) }

  override string toString() { result = "FileRedirection" }
}
