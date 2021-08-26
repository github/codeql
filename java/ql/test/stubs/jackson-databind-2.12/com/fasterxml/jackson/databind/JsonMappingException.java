package com.fasterxml.jackson.databind;

import java.io.Closeable;
import java.io.IOException;
import java.io.Serializable;
import java.util.*;
import com.fasterxml.jackson.core.*;

public class JsonMappingException extends JsonProcessingException {
  public static class Reference implements Serializable {
    public Reference(Object from) {}

    public Reference(Object from, String fieldName) {}

    public Reference(Object from, int index) {}

    public Object getFrom() {
      return null;
    }

    public String getFieldName() {
      return null;
    }

    public int getIndex() {
      return 0;
    }

    public String getDescription() {
      return null;
    }

    @Override
    public String toString() {
      return null;
    }

  }

  public JsonMappingException(String msg) {}

  public JsonMappingException(String msg, Throwable rootCause) {}

  public JsonMappingException(Closeable processor, String msg) {}

  public JsonMappingException(Closeable processor, String msg, Throwable problem) {}

  public static JsonMappingException from(JsonParser p, String msg) {
    return null;
  }

  public static JsonMappingException from(JsonParser p, String msg, Throwable problem) {
    return null;
  }

  public static JsonMappingException from(JsonGenerator g, String msg) {
    return null;
  }

  public static JsonMappingException from(JsonGenerator g, String msg, Throwable problem) {
    return null;
  }

  public static JsonMappingException fromUnexpectedIOE(IOException src) {
    return null;
  }

  public static JsonMappingException wrapWithPath(Throwable src, Object refFrom,
      String refFieldName) {
    return null;
  }

  public static JsonMappingException wrapWithPath(Throwable src, Object refFrom, int index) {
    return null;
  }

  public static JsonMappingException wrapWithPath(Throwable src, Reference ref) {
    return null;
  }

  public List<Reference> getPath() {
    return null;
  }

  public String getPathReference() {
    return null;
  }

  public StringBuilder getPathReference(StringBuilder sb) {
    return null;
  }

  public void prependPath(Object referrer, String fieldName) {}

  public void prependPath(Object referrer, int index) {}

  public void prependPath(Reference r) {}

  @Override
  public Object getProcessor() {
    return null;
  }

  @Override
  public String getLocalizedMessage() {
    return null;
  }

  @Override
  public String getMessage() {
    return null;
  }

  @Override
  public String toString() {
    return null;
  }

}
