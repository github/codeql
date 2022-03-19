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

package androidx.security.crypto;

import android.content.Context;
import androidx.annotation.NonNull;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.GeneralSecurityException;

public final class EncryptedFile {
  public enum FileEncryptionScheme {
    AES256_GCM_HKDF_4KB;
  }
  public static final class Builder {
    public Builder(@NonNull File file, @NonNull Context context, @NonNull String masterKeyAlias,
        @NonNull FileEncryptionScheme fileEncryptionScheme) {}

    public Builder(@NonNull Context context, @NonNull File file, @NonNull MasterKey masterKey,
        @NonNull FileEncryptionScheme fileEncryptionScheme) {}

    public Builder setKeysetPrefName(@NonNull String keysetPrefName) {
      return null;
    }

    public Builder setKeysetAlias(@NonNull String keysetAlias) {
      return null;
    }

    public EncryptedFile build() throws GeneralSecurityException, IOException {
      return null;
    }

  }

  public FileOutputStream openFileOutput() throws GeneralSecurityException, IOException {
    return null;
  }

  public FileInputStream openFileInput()
      throws GeneralSecurityException, IOException, FileNotFoundException {
    return null;
  }

}
