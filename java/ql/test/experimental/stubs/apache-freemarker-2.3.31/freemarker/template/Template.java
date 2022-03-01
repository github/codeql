package freemarker.template;

import java.io.Reader;
import java.lang.String;

public class Template {

  public Template(String name, Reader reader) {
  }

  public Template(String name, Reader reader, Configuration cfg) {
  }

  public Template(String name, Reader reader, Configuration cfg, String encoding) {
  }

  public Template(String name, String sourceCode, Configuration cfg) {
  }

  public Template(String name, String sourceName, Reader reader, Configuration cfg) {
  }

  public Template(
      String name,
      String sourceName,
      Reader reader,
      Configuration cfg,
      ParserConfiguration customParserConfiguration,
      String encoding) {
  }

  public Template(
      String name,
      String sourceName,
      Reader reader,
      Configuration cfg,
      String encoding) {
  }

  public void process(java.lang.Object dataModel, java.io.Writer out) {
  }

  public void process(
      java.lang.Object dataModel,
      java.io.Writer out,
      ObjectWrapper wrapper) {
  }

  public void process(
      java.lang.Object dataModel,
      java.io.Writer out,
      ObjectWrapper wrapper,
      TemplateNodeModel rootNode) {
  }
}
