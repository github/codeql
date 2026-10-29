/*
 * Copyright 2018 The Android Open Source Project
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

package androidx.activity;

import android.content.Context;
import android.content.Intent;
import android.content.IntentSender;
import android.os.Bundle;
import android.view.View;


public class ComponentActivity extends androidx.core.app.ComponentActivity {
  public ComponentActivity() {}

  public ComponentActivity(int contentLayoutId) {}

  public final Object onRetainNonConfigurationInstance() {
    return null;
  }

  public Object onRetainCustomNonConfigurationInstance() {
    return null;
  }

  public Object getLastCustomNonConfigurationInstance() {
    return null;
  }

  @Override
  public void setContentView(int layoutResID) {}

  @Override
  public void setContentView(View view) {}

  public Context peekAvailableContext() {
    return null;
  }

  public void onBackPressed() {}

  @Override
  public void startActivityForResult(Intent intent, int requestCode) {}

  public void startActivityForResult(Intent intent, int requestCode, Bundle options) {}

  public void startIntentSenderForResult(IntentSender intent, int requestCode, Intent fillInIntent,
      int flagsMask, int flagsValues, int extraFlags) throws IntentSender.SendIntentException {}

  public void startIntentSenderForResult(IntentSender intent, int requestCode, Intent fillInIntent,
      int flagsMask, int flagsValues, int extraFlags, Bundle options)
      throws IntentSender.SendIntentException {}

  public void onRequestPermissionsResult(int requestCode, String[] permissions,
      int[] grantResults) {}


  public void reportFullyDrawn() {}

}
