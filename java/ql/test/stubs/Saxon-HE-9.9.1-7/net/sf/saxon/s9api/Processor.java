package net.sf.saxon.s9api;

import net.sf.saxon.Configuration;

public class Processor implements Configuration.ApiProvider {
  public Processor(boolean licensedEdition) {}

  public XsltCompiler newXsltCompiler() { return null; }
}
