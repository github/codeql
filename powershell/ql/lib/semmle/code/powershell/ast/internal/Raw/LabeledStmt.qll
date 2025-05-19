private import Raw

class LabeledStmt extends @labeled_statement, Stmt {
  string getLabel() { label(this, result) }
}
