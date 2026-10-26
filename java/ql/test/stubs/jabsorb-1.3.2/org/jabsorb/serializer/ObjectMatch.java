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

/**
 * <p>
 * This class is returned from the Serializer tryUnmarshall method to indicate
 * number of mismatched fields. This is used to handle ambiguities with
 * JavaScript's typeless objects combined with and Java's operator overloading.
 * </p>
 * TODO: wouldn't a better name for this class be ObjectMismatch as it's would
 * be more descriptive. The name ObjectMatch is a little confusing because it
 * implies the opposite of what the class actually stores (ObjectMismatch)
 * either that, or I'm not understanding something correctly... [WB: I agree!]
 */
public class ObjectMatch
{
  /**
   * Create a new ObjectMatch object with the given number of mismatches.
   * 
   * @param mismatch the number of mismatched fields that occured on a
   *          tryUnmarshall call.
   */
  public ObjectMatch(int mismatch)
  {
  }

  /**
   * Get the number of mismatched fields that occured on a tryUnmarshall call.
   * 
   * @return the number of mismatched fields that occured on a tryUnmarshall
   *         call.
   */
  public int getMismatch()
  {
    return -1;
  }

  /**
   * Set the mismatch on this ObjectMatch.
   * The ObjectMatch cannot be immutable anymore (at least in the current design--
   * because the same mismatch object must be maintained through recursive processing
   * to properly handle circular references detection)
   *
   * @param mismatch the mismatch value to set for this ObjectMatch.
   */
  public void setMismatch(int mismatch)
  {
  }

  /**
   * Compare another ObjectMatch with this ObjectMatch and return the one that
   * has the most mismatches.
   * 
   * @param m ObjectMatch to compare this ObjectMatch to.
   * 
   * @return this ObjectMatch if it has more mismatches, else the passed in
   *         ObjectMatch.
   */
  public ObjectMatch max(ObjectMatch m)
  {
    return null;
  }
}