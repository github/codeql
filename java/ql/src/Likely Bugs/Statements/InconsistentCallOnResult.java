DataOutputStream outValue = null;
try {
    outValue = writer.prepareAppendValue(6);
    outValue.write("value0".getBytes());
}
catch (IOException e) {
}
finally {
    if (outValue != null) {
        outValue.close();
    }
}
