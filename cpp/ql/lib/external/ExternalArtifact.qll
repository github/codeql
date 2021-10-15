/**
 * Provides classes for working with external data.
 */

import cpp

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
  string getQueryPath() { result = getDataPath().regexpReplaceAll("\\.[^.]*$", ".ql") }

  /** Gets the number of fields in this data item. */
  int getNumFields() { result = 1 + max(int i | externalData(this, _, i, _) | i) }

  /** Gets the value of the `i`th field of this data item. */
  string getField(int i) { externalData(this, _, i, result) }

  /** Gets the integer value of the `i`th field of this data item. */
  int getFieldAsInt(int i) { result = getField(i).toInt() }

  /** Gets the floating-point value of the `i`th field of this data item. */
  float getFieldAsFloat(int i) { result = getField(i).toFloat() }

  /** Gets the value of the `i`th field of this data item, interpreted as a date. */
  date getFieldAsDate(int i) { result = getField(i).toDate() }

  /** Gets a textual representation of this data item. */
  string toString() { result = getQueryPath() + ": " + buildTupleString(0) }

  /** Gets a textual representation of this data item, starting with the `n`th field. */
  private string buildTupleString(int n) {
    n = getNumFields() - 1 and result = getField(n)
    or
    n < getNumFields() - 1 and result = getField(n) + "," + buildTupleString(n + 1)
  }
}

/**
 * External data with a location, and a message, as produced by tools that used to produce QLDs.
 */
class DefectExternalData extends ExternalData {
  DefectExternalData() {
    this.getField(0).regexpMatch("\\w+://.*:[0-9]+:[0-9]+:[0-9]+:[0-9]+$") and
    this.getNumFields() = 2
  }

  /** Gets the URL associated with this data item. */
  string getURL() { result = getField(0) }

  /** Gets the message associated with this data item. */
  string getMessage() { result = getField(1) }
}
