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

    string toString() { result = getQueryPath() + ": " + getLocation() + " - " + getMessage() }
}

class ExternalMetric extends @externalMetric {
    string getQueryPath() { externalMetrics(this, result, _, _) }

    float getValue() { externalMetrics(this, _, _, result) }

    Location getLocation() { externalMetrics(this, _, result, _) }

    string toString() { result = getQueryPath() + ": " + getLocation() + " - " + getValue() }
}

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
