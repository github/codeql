/*
 * Copyright (C) 2011 The Android Open Source Project
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

package android.os;

import java.io.PrintWriter;

public final class UserHandle implements Parcelable {

  public static boolean isSameUser(int uid1, int uid2) {
    return false;
  }

  public static boolean isSameApp(int uid1, int uid2) {
    return false;
  }

  public static boolean isIsolated(int uid) {
    return false;
  }

  public static boolean isApp(int uid) {
    return false;
  }

  public static boolean isCore(int uid) {
    return false;
  }

  public static UserHandle getUserHandleForUid(int uid) {
    return null;
  }

  public static int getUserId(int uid) {
    return 0;
  }

  public static int getCallingUserId() {
    return 0;
  }

  public static int getCallingAppId() {
    return 0;
  }

  public static UserHandle of(int userId) {
    return null;
  }

  public static int getUid(int userId, int appId) {
    return 0;
  }

  public static int getAppId(int uid) {
    return 0;
  }

  public static int getUserGid(int userId) {
    return 0;
  }

  public static int getSharedAppGid(int uid) {
    return 0;
  }

  public static int getSharedAppGid(int userId, int appId) {
    return 0;
  }

  public static int getAppIdFromSharedAppGid(int gid) {
    return 0;
  }

  public static int getCacheAppGid(int uid) {
    return 0;
  }

  public static int getCacheAppGid(int userId, int appId) {
    return 0;
  }

  public static void formatUid(StringBuilder sb, int uid) {}

  public static String formatUid(int uid) {
    return null;
  }

  public static void formatUid(PrintWriter pw, int uid) {}

  public static int parseUserArg(String arg) {
    return 0;
  }

  public static int myUserId() {
    return 0;
  }

  public boolean isOwner() {
    return false;
  }

  public boolean isSystem() {
    return false;
  }

  public UserHandle(int h) {}

  public int getIdentifier() {
    return 0;
  }

  @Override
  public String toString() {
    return null;
  }

  @Override
  public boolean equals(Object obj) {
    return false;
  }

  @Override
  public int hashCode() {
    return 0;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel out, int flags) {}

  public static void writeToParcel(UserHandle h, Parcel out) {}

  public static UserHandle readFromParcel(Parcel in) {
    return null;
  }

  public UserHandle(Parcel in) {}

}
