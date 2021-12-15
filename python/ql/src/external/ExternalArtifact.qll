/**
 * Provides classes for working with external data.
 */

import python

class ExternalDefect extends @externalDefect {
  string getQueryPath() {
    exists(string path |
      externalDefects(this, path, _, _, _) and
      result = path.replaceAll("\\", "/")
    )
  }

  string getMessage() { externalDefects(this, _, _, result, _) }

  float getSeverity() { externalDefects(this, _, _, _, result) }

  Location getLocation() { externalDefects(this, _, result, _, _) }

  /** Gets a textual representation of this element. */
  string toString() {
    result = this.getQueryPath() + ": " + this.getLocation() + " - " + this.getMessage()
  }
}

class ExternalMetric extends @externalMetric {
  string getQueryPath() { externalMetrics(this, result, _, _) }

  float getValue() { externalMetrics(this, _, _, result) }

  Location getLocation() { externalMetrics(this, _, result, _) }

  /** Gets a textual representation of this element. */
  string toString() {
    result = this.getQueryPath() + ": " + this.getLocation() + " - " + this.getValue()
  }
}

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

  /** Gets the value of the field at position `index` of this data item. */
  string getField(int index) { externalData(this, _, index, result) }

  /** Gets the integer value of the field at position `index` of this data item. */
  int getFieldAsInt(int index) { result = this.getField(index).toInt() }

  /** Gets the floating-point value of the field at position `index` of this data item. */
  float getFieldAsFloat(int index) { result = this.getField(index).toFloat() }

  /** Gets the value of the field at position `index` of this data item, interpreted as a date. */
  date getFieldAsDate(int index) { result = this.getField(index).toDate() }

  /** Gets a textual representation of this data item. */
  string toString() { result = this.getQueryPath() + ": " + this.buildTupleString(0) }

  /** Gets a textual representation of this data item, starting with the field at position `start`. */
  private string buildTupleString(int start) {
    start = this.getNumFields() - 1 and result = this.getField(start)
    or
    start < this.getNumFields() - 1 and
    result = this.getField(start) + "," + this.buildTupleString(start + 1)
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

  string getURL() { result = this.getField(0) }

  string getMessage() { result = this.getField(1) }
}
