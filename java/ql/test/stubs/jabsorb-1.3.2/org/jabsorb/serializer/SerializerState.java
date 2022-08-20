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

import java.util.List;

/**
 * Used by Serializers to hold state during marshalling and
 * unmarshalling.  It keeps track of all Objects encountered
 * during processing for the purpose of detecting circular
 * references and/or duplicates.
 */
public class SerializerState
{
  /**
   * Add a fixup entry.  Assumes that the SerializerState is in the correct scope for the
   * fix up location.
   *
   * @param originalLocation original json path location where the object was first encountered.
   * @param ref additional reference (String|Integer) to add on to the scope's current location.
   * @throws MarshallException if a scope error occurs (this won't normally occur.
   */
  public void addFixUp(List originalLocation, Object ref) throws MarshallException
  {
  }

  /**
   * Get the List of all FixUp objects created during processing.
   * @return List of FixUps to circular references and duplicates found during processing.
   */
  public List getFixUps()
  {
    return null;
  }

  /**
   * Pop off one level from the scope stack of the current location during processing.
   * If we are already at the lowest level of scope, then this has no action.
   * @throws MarshallException If called when currentLocation is empty
   */
  public void pop() throws MarshallException
  {
  }

  /**
   * Record the given object as a ProcessedObject and push into onto the scope stack.  This is only
   * used for marshalling.  The store method should be used for unmarshalling.
   *
   * @param parent parent of object to process.  Can be null if it's the root object being processed.
   *               it should be an object that was already processed via a previous call to processObject.
   *
   * @param obj    object being processed
   * @param ref    reference to object within parent-- should be a String if parent is an object, and Integer
   *               if parent is an array.  Can be null if this is the root object that is being pushed/processed.
   */
  public void push(Object parent, Object obj, Object ref)
  {
  }

  /**
   * Associate the incoming source object being serialized to it's serialized representation.
   * Currently only used within tryUnmarshall and unmarshall.  This MUST be called before a given unmarshall
   * or tryUnmarshall recurses into child objects to unmarshall them.
   * The purpose is to stop the recursion that can take place when circular references/duplicates are in the
   * input json being unmarshalled.
   *
   * @param source source object being unmarshalled.
   * @param target target serialized representation of the object that the source object is being unmarshalled to.
   * @throws UnmarshallException if the source object is null, or is not already stored within a ProcessedObject.
   */
  public void setSerialized(Object source, Object target) throws UnmarshallException
  {
  }
}