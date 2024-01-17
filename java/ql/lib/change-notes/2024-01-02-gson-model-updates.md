---
category: minorAnalysis
---
* Added taint tracking for the following GSON methods:
  * `com.google.gson.stream.JsonReader` constructor
  * `com.google.gson.stream.JsonWriter` constructor
  * `com.google.gson.JsonObject.getAsJsonArray`
  * `com.google.gson.JsonObject.getAsJsonObject`
  * `com.google.gson.JsonObject.getAsJsonPrimitive`
  * `com.google.gson.JsonParser.parseReader`
  * `com.google.gson.JsonParser.parseString`
