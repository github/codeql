/**
 * Provides classes modeling security-relevant aspects of the `Bun` package.
 */

import go

/**
 * Provides classes modeling security-relevant aspects of the `Bun` package.
 */
private module Bun {
  private string packagePath() { result = package("github.com/uptrace/bun", "") }

  private class RawQuerySources extends SourceNode {
    RawQuerySources() {
      // func (q *RawQuery) Exec(ctx context.Context, dest ...interface{}) (sql.Result, error)
      // func (q *RawQuery) Scan(ctx context.Context, dest ...interface{}) error
      exists(DataFlow::CallNode cn, int i |
        cn.getTarget().(Method).hasQualifiedName(packagePath(), "RawQuery", ["Exec", "Scan"]) and
        i >= 1
      |
        this = cn.getSyntacticArgument(i)
      )
    }

    override string getThreatModel() { result = "database" }
  }

  private class SelectQuerySources extends SourceNode {
    SelectQuerySources() {
      // func (q *SelectQuery) Exec(ctx context.Context, dest ...interface{}) (res sql.Result, err error)
      // func (q *SelectQuery) Scan(ctx context.Context, dest ...interface{}) error
      // func (q *SelectQuery) ScanAndCount(ctx context.Context, dest ...interface{}) (int, error)
      exists(DataFlow::CallNode cn, int i |
        cn.getTarget()
            .(Method)
            .hasQualifiedName(packagePath(), "SelectQuery", ["Exec", "Scan", "ScanAndCount"]) and
        i >= 1
      |
        this = cn.getSyntacticArgument(i)
      )
    }

    override string getThreatModel() { result = "database" }
  }

  private class DBScanRows extends TaintTracking::FunctionModel, Method {
    FunctionInput inp;
    FunctionOutput outp;

    DBScanRows() {
      // func (db *DB) ScanRow(ctx context.Context, rows *sql.Rows, dest ...interface{}) error
      // func (db *DB) ScanRows(ctx context.Context, rows *sql.Rows, dest ...interface{}) error
      this.hasQualifiedName(packagePath(), "DB", ["ScanRow", "ScanRows"]) and
      inp.isParameter(1) and
      outp.isParameter(any(int i | i >= 2))
    }

    override predicate hasTaintFlow(FunctionInput input, FunctionOutput output) {
      input = inp and output = outp
    }
  }
}
