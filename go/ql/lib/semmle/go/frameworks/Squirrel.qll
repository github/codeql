/**
 * Provides classes modeling security-relevant aspects of the `squirrel` ORM package.
 */

import go

/**
 * Provides classes modeling security-relevant aspects of the `squirrel` ORM package.
 */
module Squirrel {
  private string packagePath() {
    result =
      package([
          "github.com/Masterminds/squirrel",
          "github.com/lann/squirrel",
          "gopkg.in/Masterminds/squirrel",
        ], "")
  }

  private class RowScan extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    RowScan() {
      // signature: func (r *Row) Scan(dest ...interface{}) error
      this.hasQualifiedName(packagePath(), "Row", "Scan") and
      inp.isReceiver() and
      outp.isParameter(_)
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class RowScannerScan extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    RowScannerScan() {
      // signature: func (rs *RowScanner) Scan(dest ...interface{}) error
      this.hasQualifiedName(packagePath(), "RowScanner", "Scan") and
      inp.isReceiver() and
      outp.isParameter(_)
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class BuilderScan extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    BuilderScan() {
      // signature: func (b {Insert,Delete,Select,Update}Builder) Scan(dest ...interface{}) error
      this.hasQualifiedName(packagePath(),
        ["DeleteBuilder", "InsertBuilder", "SelectBuilder", "UpdateBuilder"], "Scan") and
      inp.isReceiver() and
      outp.isParameter(_)
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }

  private class BuilderScanContext extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    BuilderScanContext() {
      // signature: func (b {Insert,Delete,Select,Update}Builder) ScanContext(ctx context.Context, dest ...interface{}) error
      this.hasQualifiedName(packagePath(),
        ["DeleteBuilder", "InsertBuilder", "SelectBuilder", "UpdateBuilder"], "ScanContext") and
      inp.isReceiver() and
      exists(int i | i > 0 | outp.isParameter(i))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
