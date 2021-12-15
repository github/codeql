/*
 * Jackson JSON-processor.
 *
 * Copyright (c) 2007- Tatu Saloranta, tatu.saloranta@iki.fi
 */

package com.fasterxml.jackson.core;

public class JsonProcessingException extends JacksonException {

  public void clearLocation() {}

  @Override
  public String getOriginalMessage() {
    return super.getMessage();
  }

  @Override
  public Object getProcessor() {
    return null;
  }

  @Override
  public String getMessage() {
    return null;
  }

}
