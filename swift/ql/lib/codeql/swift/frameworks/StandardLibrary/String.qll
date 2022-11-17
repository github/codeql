import swift
private import codeql.swift.dataflow.ExternalFlow

private class StringSource extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        // String(contentsOf:) is a remote flow source
        ";String;true;init(contentsOf:);(URL);;ReturnValue;remote",
        ";String;true;init(contentsOf:encoding:);(URL,String.Encoding);;ReturnValue;remote",
        ";String;true;init(contentsOf:usedEncoding:);(URL,String.Encoding);;ReturnValue;remote",
        // String(contentsOfFile:) is a local flow source
        ";String;true;init(contentsOfFile:);(String);;ReturnValue;local",
        ";String;true;init(contentsOfFile:encoding:);(String,String.Encoding);;ReturnValue;local",
        ";String;true;init(contentsOfFile:usedEncoding:);(String,String.Encoding);;ReturnValue;local"
      ]
  }
}
