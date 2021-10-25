import java

class ExternalData extends @externalDataElement {
  string getDataPath() { externalData(this, result, _, _) }

  string getQueryPath() { result = getDataPath().regexpReplaceAll("\\.[^.]*$", ".ql") }

  int getNumFields() { result = 1 + max(int i | externalData(this, _, i, _) | i) }

  string getField(int index) { externalData(this, _, index, result) }

  int getFieldAsInt(int index) { result = getField(index).toInt() }

  float getFieldAsFloat(int index) { result = getField(index).toFloat() }

  date getFieldAsDate(int index) { result = getField(index).toDate() }

  string toString() { result = getQueryPath() + ": " + buildTupleString(0) }

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
