package org.owasp.esapi;

public interface Encoder {
  String encodeForLDAP(String input);

  String encodeForHTML(String untrustedData);
}
