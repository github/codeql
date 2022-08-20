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

package org.jabsorb;

import java.io.Serializable;

import org.jabsorb.serializer.MarshallException;
import org.jabsorb.serializer.ObjectMatch;
import org.jabsorb.serializer.Serializer;
import org.jabsorb.serializer.SerializerState;
import org.jabsorb.serializer.UnmarshallException;

/**
 * This class is the public entry point to the serialization code and provides
 * methods for marshalling Java objects into JSON objects and unmarshalling JSON
 * objects into Java objects.
 */
public class JSONSerializer implements Serializable
{
  /**
   * Determine if this serializer considers the given Object to be a primitive
   * wrapper type Object.  This is used to determine which types of Objects
   * should be fixed up as duplicates if the fixupDuplicatePrimitives flag
   * is false.
   *
   * @param o Object to test for primitive.
   */
  public boolean isPrimitive(Object o)
  {
    return false;
  }

  /**
   * Get the fixupCircRefs flag.  If true, FixUps are generated to handle circular
   * references found during marshalling.  If false, an exception is thrown if a
   * circular reference is found during serialization.
   *
   * @return the fixupCircRefs flag.
   */
  public boolean getFixupCircRefs()
  {
    return false;
  }

  /**
   * Set the fixupCircRefs flag.  If true, FixUps are generated to handle circular
   * references found during marshalling.  If false, an exception is thrown if a
   * circular reference is found during serialization.
   *
   * @param fixupCircRefs  the fixupCircRefs flag.
   */
  public void setFixupCircRefs(boolean fixupCircRefs)
  {
  }

  /**
   * Get the fixupDuplicates flag.  If true, FixUps are generated for duplicate
   * objects found during marshalling. If false, the duplicates are re-serialized.
   *
   * @return the fixupDuplicates flag.
   */
  public boolean getFixupDuplicates()
  {
    return false;
  }

  /**
   * Set the fixupDuplicates flag.  If true, FixUps are generated for duplicate
   * objects found during marshalling. If false, the duplicates are re-serialized.
   *
   * @param fixupDuplicates the fixupDuplicates flag.
   */
  public void setFixupDuplicates(boolean fixupDuplicates)
  {
  }

  /**
   * Get the fixupDuplicatePrimitives flag.  If true (and fixupDuplicates is
   * also true), FixUps are generated for duplicate primitive objects found
   * during marshalling.  If false, the duplicates are re-serialized.
   *
   * @return the fixupDuplicatePrimitives flag.
   */
  public boolean getFixupDuplicatePrimitives()
  {
    return false;
  }

  /**
   * Set the fixupDuplicatePrimitives flag.  If true (and fixupDuplicates is
   * also true), FixUps are generated for duplicate primitive objects found
   * during marshalling. If false, the duplicates are re-serialized.
   *
   * @param fixupDuplicatePrimitives the fixupDuplicatePrimitives flag.
   */
  public void setFixupDuplicatePrimitives(boolean fixupDuplicatePrimitives)
  {
  }

  /**
   * Convert a string in JSON format into Java objects.
   *
   * @param jsonString The JSON format string.
   * @return An object (or tree of objects) representing the data in the JSON
   *         format string.
   * @throws UnmarshallException If unmarshalling fails
   */
  public Object fromJSON(String jsonString) throws UnmarshallException
  {
    return null;
  }

  /**
   * Should serializers defined in this object include the fully qualified class
   * name of objects being serialized? This can be helpful when unmarshalling,
   * though if not needed can be left out in favor of increased performance and
   * smaller size of marshalled String. Default is true.
   *
   * @return whether Java Class hints are included in the serialised JSON
   *         objects
   */
  public boolean getMarshallClassHints()
  {
    return false;
  }

  /**
   * Returns true if attributes will null values should still be included in the
   * serialized JSON object. Defaults to true. Set to false for performance
   * gains and small JSON serialized size. Useful because null and undefined for
   * JSON object attributes is virtually the same thing.
   *
   * @return boolean value as to whether null attributes will be in the
   *         serialized JSON objects
   */
  public boolean getMarshallNullAttributes()
  {
    return false;
  }

  /**
   * Marshall java into an equivalent json representation (JSONObject or
   * JSONArray.) <p/> This involves finding the correct Serializer for the class
   * of the given java object and then invoking it to marshall the java object
   * into json. <p/> The Serializer will invoke this method recursively while
   * marshalling complex object graphs.
   *
   * @param state can be used by the underlying Serializer objects to hold state
   *          while marshalling.
   *
   * @param parent parent object of the object being converted.  this can be null if
   *               it's the root object being converted.
   * @param java java object to convert into json.
   *
   * @param ref reference within the parent's point of view of the object being serialized.
   *            this will be a String for JSONObjects and an Integer for JSONArrays.
   *
   * @return the JSONObject or JSONArray (or primitive object) containing the json
   *         for the marshalled java object or the special token Object,
   *         JSONSerializer.CIRC_REF_OR_DUP to indicate to the caller that the
   *         given Object has already been serialized and so therefore the result
   *         should be ignored.
   *
   * @throws MarshallException if there is a problem marshalling java to json.
   */
  public Object marshall(SerializerState state, Object parent, Object java, Object ref)
      throws MarshallException
  {
      return null;
  }

  /**
   * Register all of the provided standard serializers.
   *
   * @throws Exception If a serialiser has already been registered for a class.
   *
   * TODO: Should this be thrown: This can only happen if there is an internal
   * problem with the code
   */
  public void registerDefaultSerializers() throws Exception
  {
  }

  /**
   * Register a new type specific serializer. The order of registration is
   * important. More specific serializers should be added after less specific
   * serializers. This is because when the JSONSerializer is trying to find a
   * serializer, if it can't find the serializer by a direct match, it will
   * search for a serializer in the reverse order that they were registered.
   *
   * @param s A class implementing the Serializer interface (usually derived
   *          from AbstractSerializer).
   */
  public void registerSerializer(Serializer s)
  {
  }

  /**
   * Should serializers defined in this object include the fully qualified class
   * name of objects being serialized? This can be helpful when unmarshalling,
   * though if not needed can be left out in favor of increased performance and
   * smaller size of marshalled String. Default is true.
   *
   * @param marshallClassHints flag to enable/disable inclusion of Java class
   *          hints in the serialized JSON objects
   */
  public void setMarshallClassHints(boolean marshallClassHints)
  {
  }

  /**
   * Returns true if attributes will null values should still be included in the
   * serialized JSON object. Defaults to true. Set to false for performance
   * gains and small JSON serialized size. Useful because null and undefined for
   * JSON object attributes is virtually the same thing.
   *
   * @param marshallNullAttributes flag to enable/disable marshalling of null
   *          attributes in the serialized JSON objects
   */
  public void setMarshallNullAttributes(boolean marshallNullAttributes)
  {
  }

  /**
   * Convert a Java objects (or tree of Java objects) into a string in JSON
   * format.  Note that this method will remove any circular references / duplicates
   * and not handle the potential fixups that could be generated.  (unless duplicates/circular
   * references are turned off.
   *
   * todo: have some way to transmit the fixups back to the caller of this method.
   *
   * @param obj the object to be converted to JSON.
   * @return the JSON format string representing the data in the the Java
   *         object.
   * @throws MarshallException If marshalling fails.
   */
  public String toJSON(Object obj) throws MarshallException
  {
    return null;
  }

  /**
   * <p>
   * Determine if a given JSON object matches a given class type, and to what
   * degree it matches.  An ObjectMatch instance is returned which contains a
   * number indicating the number of fields that did not match.  Therefore when a given
   * parameter could potentially match in more that one way, this is a metric
   * to compare these ObjectMatches to determine which one matches more closely.
   * </p><p>
   * This is only used when there are overloaded method names that are being called
   * from JSON-RPC to determine which call signature the method call matches most
   * closely and therefore which method is the intended target method to call.
   * </p>
   * @param state used by the underlying Serializer objects to hold state
   *          while unmarshalling for detecting circular references and duplicates.
   *
   * @param clazz optional java class to unmarshall to- if set to null then it
   *        will be looked for via the javaClass hinting mechanism.
   *
   * @param json JSONObject or JSONArray or primitive Object wrapper that contains the json to unmarshall.
   *
   * @return an ObjectMatch indicating the degree to which the object matched the class,
   * @throws UnmarshallException if getClassFromHint() fails
   */
  public ObjectMatch tryUnmarshall(SerializerState state, Class clazz,
    Object json) throws UnmarshallException
  {
    return null;
  }

  /**
   * Unmarshall json into an equivalent java object. <p/> This involves finding
   * the correct Serializer to use and then delegating to that Serializer to
   * unmarshall for us. This method will be invoked recursively as Serializers
   * unmarshall complex object graphs.
   *
   * @param state used by the underlying Serializer objects to hold state
   *          while unmarshalling for detecting circular references and duplicates.
   *
   * @param clazz optional java class to unmarshall to- if set to null then it
   *          will be looked for via the javaClass hinting mechanism.
   *
   * @param json JSONObject or JSONArray or primitive Object wrapper that contains the json to unmarshall.
   *
   * @return the java object representing the json that was unmarshalled.
   *
   * @throws UnmarshallException if there is a problem unmarshalling json to
   *           java.
   */
  public Object unmarshall(SerializerState state, Class clazz, Object json)
      throws UnmarshallException
  {
      return null;
  }
}