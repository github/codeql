/*
 * Jackson JSON-processor.
 *
 * Copyright (c) 2007- Tatu Saloranta, tatu.saloranta@iki.fi
 */

package com.fasterxml.jackson.core;

public class JsonGenerationException extends JsonProcessingException {
  public JsonGenerationException(Throwable rootCause) {}

  public JsonGenerationException(String msg) {}

  public JsonGenerationException(String msg, Throwable rootCause) {}

  public JsonGenerationException(Throwable rootCause, JsonGenerator g) {}

  public JsonGenerationException(String msg, JsonGenerator g) {}

  public JsonGenerationException(String msg, Throwable rootCause, JsonGenerator g) {}

  public JsonGenerationException withGenerator(JsonGenerator g) {
    return null;
  }

  @Override
  public JsonGenerator getProcessor() {
    return null;
  }

}
