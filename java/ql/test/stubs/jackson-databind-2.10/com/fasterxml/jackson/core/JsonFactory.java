package com.fasterxml.jackson.core;

import java.io.Writer;

public class JsonFactory {
  public JsonFactory() {
  }

  public JsonGenerator createGenerator(Writer writer) {
    return new JsonGenerator();
  }
}
