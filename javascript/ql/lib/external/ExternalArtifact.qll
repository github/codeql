/**
 * Provides classes for working with external data.
 */

import semmle.javascript.Locations

/**
 * An external data item.
 */
class ExternalData extends @externalDataElement {
  /** Gets the path of the file this data was loaded from. */
  string getDataPath() { externalData(this, result, _, _) }

  /**
   * Gets the path of the file this data was loaded from, with its
   * extension replaced by `.ql`.
   */
  string getQueryPath() { result = this.getDataPath().regexpReplaceAll("\\.[^.]*$", ".ql") }

  /** Gets the number of fields in this data item. */
  int getNumFields() { result = 1 + max(int i | externalData(this, _, i, _) | i) }

  /** Gets the value of the `i`th field of this data item. */
  string getField(int i) { externalData(this, _, i, result) }

  /** Gets the integer value of the `i`th field of this data item. */
  int getFieldAsInt(int i) { result = this.getField(i).toInt() }

  /** Gets the floating-point value of the `i`th field of this data item. */
  float getFieldAsFloat(int i) { result = this.getField(i).toFloat() }

  /** Gets the value of the `i`th field of this data item, interpreted as a date. */
  date getFieldAsDate(int i) { result = this.getField(i).toDate() }

  /** Gets a textual representation of this data item. */
  string toString() { result = this.getQueryPath() + ": " + this.buildTupleString(0) }

  /** Gets a textual representation of this data item, starting with the `n`th field. */
  private string buildTupleString(int n) {
    n = this.getNumFields() - 1 and result = this.getField(n)
    or
    n < this.getNumFields() - 1 and result = this.getField(n) + "," + this.buildTupleString(n + 1)
  }
}

/**
 * An external data item interpreted as an error or warning reported by an external tool.
 */
class ExternalError extends ExternalData {
  /** Gets the name of the tool that reported the error. */
  string getReporter() { result = this.getField(0) }

  /** Gets the absolute path of the file in which the error occurs. */
  string getPath() { result = this.getField(1) }

  /** Gets the reported line of the error. */
  int getLine() { result = this.getFieldAsInt(2) }

  /** Gets the reported column of the error. */
  int getColumn() { result = this.getFieldAsInt(3) }

  /**
   * Gets the error type.
   *
   * This is tool-specific, but usually either "warning" or "error".
   */
  string getType() { result = this.getField(4) }

  /** Gets the error message. */
  string getMessage() { result = this.getField(5) }

  /** Gets the file associated with this error. */
  File getFile() { result.getAbsolutePath() = this.getPath() }

  /** Gets the URL associated with this error. */
  string getURL() {
    exists(string path, int line, int col |
      path = this.getPath() and
      line = this.getLine() and
      col = this.getColumn() and
      toUrl(path, line, col, line, col, result)
    )
  }
}

/**
 * An external data item with a location and a message.
 */
class DefectExternalData extends ExternalData {
  DefectExternalData() {
    this.getField(0).regexpMatch("\\w+://.*:[0-9]+:[0-9]+:[0-9]+:[0-9]+$") and
    this.getNumFields() = 2
  }

  /** Gets the URL associated with this data item. */
  string getURL() { result = this.getField(0) }

  /** Gets the message associated with this data item. */
  string getMessage() { result = this.getField(1) }
}
