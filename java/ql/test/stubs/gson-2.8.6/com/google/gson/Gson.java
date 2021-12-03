package com.google.gson;

import java.lang.reflect.Type;
import java.io.Reader;
import com.google.gson.stream.JsonReader;

public final class Gson {
    public Gson() {
    }

    public String toJson(Object src) {
        return null;
    }

    public String toJson(Object src, Type typeOfSrc) {
        return null;
      }

      public <T> T fromJson(String json, Class<T> classOfT) throws JsonSyntaxException {
        return null;
      }

      public <T> T fromJson(String json, Type typeOfT) throws JsonSyntaxException {
        return null;
      }

      public <T> T fromJson(Reader json, Class<T> classOfT) throws JsonSyntaxException, JsonIOException {
        return null;
      }

      public <T> T fromJson(Reader json, Type typeOfT) throws JsonIOException, JsonSyntaxException {
        return null;
      }

      public <T> T fromJson(JsonReader reader, Type typeOfT) throws JsonIOException, JsonSyntaxException {
        return null;
      }
}
