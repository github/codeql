import csharp

class ExternalElement extends @external_element {
  /** Gets a textual representation of this element. */
  string toString() { none() }

  /** Gets the location of this element. */
  Location getLocation() { none() }

  /** Gets the file containing this element. */
  File getFile() { result = getLocation().getFile() }
}

class ExternalDefect extends ExternalElement, @externalDefect {
  string getQueryPath() {
    exists(string path |
      externalDefects(this, path, _, _, _) and
      result = path.replaceAll("\\", "/")
    )
  }

  string getMessage() { externalDefects(this, _, _, result, _) }

  float getSeverity() { externalDefects(this, _, _, _, result) }

  override Location getLocation() { externalDefects(this, _, result, _, _) }

  override string toString() {
    result = getQueryPath() + ": " + getLocation() + " - " + getMessage()
  }
}

class ExternalMetric extends ExternalElement, @externalMetric {
  string getQueryPath() { externalMetrics(this, result, _, _) }

  float getValue() { externalMetrics(this, _, _, result) }

  override Location getLocation() { externalMetrics(this, _, result, _) }

  override string toString() { result = getQueryPath() + ": " + getLocation() + " - " + getValue() }
}

class ExternalData extends ExternalElement, @externalDataElement {
  string getDataPath() { externalData(this, result, _, _) }

  string getQueryPath() { result = getDataPath().regexpReplaceAll("\\.[^.]*$", ".ql") }

  int getNumFields() { result = 1 + max(int i | externalData(this, _, i, _) | i) }

  string getField(int index) { externalData(this, _, index, result) }

  int getFieldAsInt(int index) { result = getField(index).toInt() }

  float getFieldAsFloat(int index) { result = getField(index).toFloat() }

  date getFieldAsDate(int index) { result = getField(index).toDate() }

  override string toString() { result = getQueryPath() + ": " + buildTupleString(0) }

  private string buildTupleString(int start) {
    start = getNumFields() - 1 and result = getField(start)
    or
    start < getNumFields() - 1 and result = getField(start) + "," + buildTupleString(start + 1)
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

  string getURL() { result = getField(0) }

  string getMessage() { result = getField(1) }
}
