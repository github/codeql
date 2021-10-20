/*
 * Copyright (C) 2007 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package android.view;

import org.xmlpull.v1.XmlPullParser;
import android.content.Context;
import android.util.AttributeSet;

public abstract class LayoutInflater {
  public interface Filter {
    boolean onLoadClass(Class clazz);

  }
  public interface Factory {
    View onCreateView(String name, Context context, AttributeSet attrs);

  }
  public interface Factory2 extends Factory {
    View onCreateView(View parent, String name, Context context, AttributeSet attrs);

  }

  public static LayoutInflater from(Context context) {
    return null;
  }

  public abstract LayoutInflater cloneInContext(Context newContext);

  public Context getContext() {
    return null;
  }

  public final Factory getFactory() {
    return null;
  }

  public final Factory2 getFactory2() {
    return null;
  }

  public void setFactory(Factory factory) {}

  public void setFactory2(Factory2 factory) {}

  public void setPrivateFactory(Factory2 factory) {}

  public Filter getFilter() {
    return null;
  }

  public void setFilter(Filter filter) {}

  public void setPrecompiledLayoutsEnabledForTesting(boolean enablePrecompiledLayouts) {}

  public View inflate(int resource, ViewGroup root) {
    return null;
  }

  public View inflate(XmlPullParser parser, ViewGroup root) {
    return null;
  }

  public View inflate(int resource, ViewGroup root, boolean attachToRoot) {
    return null;
  }

  public View inflate(XmlPullParser parser, ViewGroup root, boolean attachToRoot) {
    return null;
  }

  public final View createView(String name, String prefix, AttributeSet attrs)
      throws ClassNotFoundException {
    return null;
  }

  public final View createView(Context viewContext, String name, String prefix, AttributeSet attrs)
      throws ClassNotFoundException {
    return null;
  }

  public View onCreateView(Context viewContext, View parent, String name, AttributeSet attrs)
      throws ClassNotFoundException {
    return null;
  }

  public final View tryCreateView(View parent, String name, Context context, AttributeSet attrs) {
    return null;
  }

}
