package net.sf.saxon.s9api;

import javax.xml.transform.Source;

public class Xslt30Transformer extends AbstractXsltTransformer {
  public void transform(Source source, Destination destination) throws SaxonApiException {}
  public void applyTemplates(Source source, Destination destination) throws SaxonApiException {}
  public XdmValue applyTemplates(Source source) throws SaxonApiException { return null; }
  public void applyTemplates(XdmValue selection, Destination destination) throws SaxonApiException {}
  public XdmValue applyTemplates(XdmValue selection) throws SaxonApiException { return null; }
  public XdmValue callFunction(QName function, XdmValue[] arguments) throws SaxonApiException { return null; }
  public void callFunction(QName function, XdmValue[] arguments, Destination destination) throws SaxonApiException {}
  public XdmValue callTemplate(QName templateName) throws SaxonApiException { return null; }
  public void callTemplate(QName templateName, Destination destination) throws SaxonApiException {}
}
