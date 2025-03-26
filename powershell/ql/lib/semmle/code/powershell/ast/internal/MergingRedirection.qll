private import AstImport

class MergingRedirection extends Redirection {
  MergingRedirection() { this = TRedirection(any(Raw::MergingRedirection r)) }

  override string toString() { result = "MergingRedirection" }
}
