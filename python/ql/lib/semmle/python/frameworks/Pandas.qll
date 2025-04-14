/**
 * Provides classes modeling security-relevant aspects of the `pandas` PyPI package.
 * See https://pypi.org/project/pandas/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for the `pandas` PyPI package.
 * See https://pypi.org/project/pandas/.
 */
private module Pandas {
  /**
   * A call to `pandas.read_pickle`
   * See https://pypi.org/project/pandas/
   * See https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_pickle.html
   */
  private class PandasReadPickleCall extends Decoding::Range, DataFlow::CallCfgNode {
    PandasReadPickleCall() {
      this = API::moduleImport("pandas").getMember("read_pickle").getACall()
    }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("filepath_or_buffer")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }

  /**
   * Provides security related models for `pandas.DataFrame`.
   * See https://pandas.pydata.org/docs/reference/frame.html
   */
  module DataFrame {
    /**
     * A `pandas.DataFrame` Object.
     *
     * Extend this class to model new APIs.
     * See https://pandas.pydata.org/docs/reference/frame.html
     */
    abstract class DataFrame extends API::Node {
      override string toString() { result = this.(API::Node).toString() }
    }

    /**
     * A `pandas.DataFrame` instantiation.
     * See https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.html
     */
    class DataFrameConstructor extends DataFrame {
      DataFrameConstructor() {
        this = API::moduleImport("pandas").getMember("DataFrame").getReturn()
      }
    }

    /**
     * The `pandas.read_*` functions that return a `pandas.DataFrame`.
     * See https://pandas.pydata.org/docs/reference/io.html
     */
    class InputRead extends DataFrame {
      InputRead() {
        this =
          API::moduleImport("pandas")
              .getMember([
                  "read_csv", "read_fwf", "read_pickle", "read_table", "read_clipboard",
                  "read_excel", "read_xml", "read_parquet", "read_orc", "read_spss",
                  "read_sql_table", "read_sql_query", "read_sql", "read_gbq", "read_stata"
                ])
              .getReturn()
        or
        this = API::moduleImport("pandas").getMember("read_html").getReturn().getASubscript()
        or
        exists(API::Node readSas, API::CallNode readSasCall |
          readSas = API::moduleImport("pandas").getMember("read_sas") and
          this = readSas.getReturn() and
          readSasCall = readSas.getACall()
        |
          // Returns DataFrame if iterator=False and chunksize=None, Also with default values it returns DataFrame.
          (
            not readSasCall.getParameter(5, "iterator").asSink().asExpr().(BooleanLiteral)
              instanceof True
            or
            not exists(readSasCall.getParameter(5, "iterator").asSink())
          ) and
          not exists(
            readSasCall.getParameter(4, "chunksize").asSink().asExpr().(IntegerLiteral).getN()
          )
        )
      }
    }

    /**
     * The `pandas.DataFrame.*` methods that return a `pandas.DataFrame` object.
     * See https://pandas.pydata.org/docs/reference/io.html
     */
    class DataFrameMethods extends DataFrame {
      DataFrameMethods() {
        this =
          any(DataFrame df)
              .getMember([
                  "copy", "from_records", "from_dict", "from_spmatrix", "assign", "select_dtypes",
                  "set_flags", "astype", "infer_objects", "head", "xs", "get", "isin", "where",
                  "mask", "query", "add", "mul", "truediv", "mod", "pow", "dot", "radd", "rsub",
                  "rdiv", "rfloordiv", "rtruediv", "rpow", "lt", "gt", "le", "ne", "agg", "combine",
                  "apply", "aggregate", "transform", "all", "any", "clip", "corr", "cov", "cummax",
                  "cummin", "cumprod", "describe", "mode", "pct_change", "quantile", "rank",
                  "round", "sem", "add_prefix", "add_suffix", "at_time", "between_time", "drop",
                  "drop_duplicates", "filter", "first", "head", "idxmin", "last", "reindex",
                  "reindex_like", "reset_index", "sample", "set_axis", "tail", "take", "truncate",
                  "bfill", "dropna", "ffill", "fillna", "interpolate", "isna", "isnull", "notna",
                  "notnull", "pad", "replace", "droplevel", "pivot", "pivot_table",
                  "reorder_levels", "sort_values", "sort_index", "nlargest", "nsmallest",
                  "swaplevel", "stack", "unstack", "isnull", "notna", "notnull", "replace",
                  "droplevel", "pivot", "pivot_table", "reorder_levels", "sort_values",
                  "sort_index", "nlargest", "nsmallest", "swaplevel", "stack", "unstack", "melt",
                  "explode", "squeeze", "T", "transpose", "compare", "join", "from_spmatrix",
                  "shift", "asof", "merge", "from_dict", "tz_convert", "to_period", "asfreq",
                  "to_dense", "tz_localize", "box", "__dataframe__"
                ])
              .getReturn()
      }
    }
  }

  /**
   * A Call to `pandas.DataFrame.query` or `pandas.DataFrame.eval`.
   * See https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.query.html
   * https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.eval.html
   */
  class CodeExecutionCall extends CodeExecution::Range, API::CallNode {
    CodeExecutionCall() {
      this = any(DataFrame::DataFrame df).getMember(["query", "eval"]).getACall()
    }

    override DataFlow::Node getCode() { result = this.getParameter(0, "expr").asSink() }
  }

  /**
   * A Call to `pandas.eval`.
   * See https://pandas.pydata.org/docs/reference/api/pandas.eval.html
   */
  class PandasEval extends CodeExecution::Range, API::CallNode {
    PandasEval() { this = API::moduleImport("pandas").getMember("eval").getACall() }

    override DataFlow::Node getCode() { result = this.getParameter(0, "expr").asSink() }
  }
}
