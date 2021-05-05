/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package android.util;

public interface AttributeSet {
    public int getAttributeCount();

    default String getAttributeNamespace (int index) {
      return null;
    }

    public String getAttributeName(int index);

    public String getAttributeValue(int index);

    public String getAttributeValue(String namespace, String name);

    public String getPositionDescription();

    public int getAttributeNameResource(int index);

    public int getAttributeListValue(String namespace, String attribute,
                                     String[] options, int defaultValue);

    public boolean getAttributeBooleanValue(String namespace, String attribute,
                                            boolean defaultValue);

    public int getAttributeResourceValue(String namespace, String attribute,
                                         int defaultValue);

    public int getAttributeIntValue(String namespace, String attribute,
                                    int defaultValue);

    public int getAttributeUnsignedIntValue(String namespace, String attribute,
                                            int defaultValue);

    public float getAttributeFloatValue(String namespace, String attribute,
                                        float defaultValue);

    public int getAttributeListValue(int index, String[] options, int defaultValue);

    public boolean getAttributeBooleanValue(int index, boolean defaultValue);

    public int getAttributeResourceValue(int index, int defaultValue);

    public int getAttributeIntValue(int index, int defaultValue);

    public int getAttributeUnsignedIntValue(int index, int defaultValue);

    public float getAttributeFloatValue(int index, float defaultValue);

    public String getIdAttribute();

    public String getClassAttribute();

    public int getIdAttributeResourceValue(int defaultValue);

    public int getStyleAttribute();

}
