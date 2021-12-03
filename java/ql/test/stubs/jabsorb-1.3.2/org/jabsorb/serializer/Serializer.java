/*
 * jabsorb - a Java to JavaScript Advanced Object Request Broker
 * http://www.jabsorb.org
 *
 * Copyright 2007-2009 The jabsorb team
 *
 * based on original code from
 * JSON-RPC-Java - a JSON-RPC to Java Bridge with dynamic invocation
 *
 * Copyright Metaparadigm Pte. Ltd. 2004.
 * Michael Clark <michael@metaparadigm.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package org.jabsorb.serializer;

import java.io.Serializable;

import org.jabsorb.JSONSerializer;

/**
 * Interface to be implemented by custom serializer objects that convert to and
 * from Java objects and JSON objects.
 */
public interface Serializer extends Serializable
{

  /**
   * Determine if the given java,json class pair can be handled by this
   * serializer. Both for serialzing from java => json and deserializing from
   * json => java.
   * 
   * @param clazz java Class type.
   * @param jsonClazz json Class wrapper type.
   * @return true if this serializer can serialize/deserialize the given pair.
   */
  public boolean canSerialize(Class clazz, Class jsonClazz);

  /**
   * Get the json java classes that this Serializer is able to serialize from
   * json into java and deserialize into json from java. <p/> These will
   * typically be primitive class type wrappers or JSONObject, JSONArray.
   * 
   * @return json side java classes that can be serialized/deserialized by this
   *         serializer.
   */
  public Class[] getJSONClasses();

  /**
   * Get the java classes that this Serializer is able to serialize from java
   * into json and deserialize into java from json.
   * 
   * @return java side classes that can be serialized/deserialized by this
   *         serializer.
   */
  public Class[] getSerializableClasses();

  /**
   * Marshall a java object into an equivalent json object.
   * 
   * @param state can be used to hold state while unmarshalling through
   *          recursive levels.
   * @param p parent of java object being marshalled into json (can be null if the object is the root object being marshalled.
   * @param o java object to marhsall into json.
   * @return that JSONObject or JSONArray that contains the json representation
   *         of the java object that was marshalled.
   * @throws MarshallException if there is a problem marshalling java to json.
   */
  public Object marshall(SerializerState state, Object p, Object o)
      throws MarshallException;

  /**
   * Set the owning JSONSerializer of this Serializer instance.
   * 
   * @param ser the owning JSONSerializer of this Serializer instance.
   */
  public void setOwner(JSONSerializer ser);

  /**
   * Attempts to unmarshal a javascript object
   * 
   * @param state The state of the serialiser
   * @param clazz The class to unmarhall to
   * @param json The object to unmarshal
   * @return An ObjectMatch denoting whether the object matches the class (?)
   * @throws UnmarshallException
   */
  public ObjectMatch tryUnmarshall(SerializerState state, Class clazz,
      Object json) throws UnmarshallException;

  /**
   * Unmarshall json into an equivalent java object.
   * 
   * @param state can be used to hold state while unmarshalling through
   *          recursive levels.
   * @param clazz optional java class to unmarshall to.
   * @param json JSONObject or JSONArray that contains the json to unmarshall.
   * @return the java object representing the json that was unmarshalled.
   * @throws UnmarshallException if there is a problem unmarshalling json to
   *           java.
   */
  public Object unmarshall(SerializerState state, Class clazz, Object json)
      throws UnmarshallException;
}