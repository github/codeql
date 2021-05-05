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

package android.content;

import android.net.Uri;
import android.os.Bundle;

import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.util.Set;

public class Intent implements Cloneable {

  public static Intent createChooser(Intent target, CharSequence title) {
    return null;
  }

  public Intent() {
  }

  public Intent(Intent o) {
  }

  @Override
  public Object clone() {
    return null;
  }

  public Intent(String action) {
  }

  public Intent(String action, Uri uri) {
  }

  public Intent(Context packageContext, Class<?> cls) {
  }

  public Intent(String action, Uri uri, Context packageContext, Class<?> cls) {
  }

  public static Intent makeMainSelectorActivity(String selectorAction, String selectorCategory) {
    return null;
  }

  public static Intent getIntent(String uri) throws URISyntaxException {
    return null;
  }

  public static Intent getIntentOld(String uri) throws URISyntaxException {
    return null;
  }

  public static void printIntentArgsHelp(PrintWriter pw, String prefix) {
  }

  public boolean hasCategory(String category) {
    return false;
  }

  public Set<String> getCategories() {
    return null;
  }

  public int getContentUserHint() {
    return 0;
  }

  public String getLaunchToken() {
    return null;
  }

  public void setLaunchToken(String launchToken) {
  }

  public boolean hasExtra(String name) {
    return false;
  }

  public boolean hasFileDescriptors() {
    return false;
  }

  public void setAllowFds(boolean allowFds) {
  }

  public void setDefusable(boolean defusable) {
  }

  public Object getExtra(String name) {
    return null;
  }

  public boolean getBooleanExtra(String name, boolean defaultValue) {
    return false;
  }

  public byte getByteExtra(String name, byte defaultValue) {
    return 0;
  }

  public short getShortExtra(String name, short defaultValue) {
    return 0;
  }

  public char getCharExtra(String name, char defaultValue) {
    return '0';
  }

  public int getIntExtra(String name, int defaultValue) {
    return 0;
  }

  public long getLongExtra(String name, long defaultValue) {
    return 0;
  }

  public float getFloatExtra(String name, float defaultValue) {
    return 0;
  }

  public double getDoubleExtra(String name, double defaultValue) {
    return 0;
  }

  public String getStringExtra(String string) {
    return null;
  }

  public void removeUnsafeExtras() {
  }

  public boolean canStripForHistory() {
    return false;
  }

  public Intent maybeStripForHistory() {
    return null;
  }

  public boolean isExcludingStopped() {
    return false;
  }

  public void removeCategory(String category) {
  }

  public void prepareToLeaveUser(int userId) {
  }

  public boolean filterEquals(Intent other) {
    return false;
  }

  public int filterHashCode() {
    return 0;
  }

  @Override
  public String toString() {
    return null;
  }

  public String toInsecureString() {
    return null;
  }

  public String toInsecureStringWithClip() {
    return null;
  }

  public String toShortString(boolean secure, boolean comp, boolean extras, boolean clip) {
    return null;
  }

  public void toShortString(StringBuilder b, boolean secure, boolean comp, boolean extras, boolean clip) {
  }

  public Bundle getExtras() {
    return null;
  }

}
