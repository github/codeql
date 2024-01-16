package org.owasp.esapi.reference;

import org.owasp.esapi.Encoder;

public class DefaultEncoder implements Encoder {
  public static Encoder getInstance() { return null; }
  public String encodeForLDAP(String input) { return null; }
  public String encodeForHTML(String untrustedData) { return null; }
}
