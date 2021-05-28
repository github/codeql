/*
 * Copyright 2019 The Android Open Source Project
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
package androidx.security.crypto;

import android.content.Context;
import android.content.SharedPreferences;
import java.io.IOException;
import java.security.GeneralSecurityException;

import java.util.Map;
import java.util.Set;

/**
 * An implementation of {@link SharedPreferences} that encrypts keys and values.
 *
 * <pre>
 *  String masterKeyAlias = MasterKeys.getOrCreate(MasterKeys.AES256_GCM_SPEC);
 *
 *  SharedPreferences sharedPreferences = EncryptedSharedPreferences.create(
 *      "secret_shared_prefs",
 *      masterKeyAlias,
 *      context,
 *      EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
 *      EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
 *  );
 *
 *  // use the shared preferences and editor as you normally would
 *  SharedPreferences.Editor editor = sharedPreferences.edit();
 * </pre>
 */
public final class EncryptedSharedPreferences implements SharedPreferences {
    /**
     * Opens an instance of encrypted SharedPreferences
     *
     * @param fileName                  The name of the file to open; can not contain path
     *                                  separators.
     * @param masterKey                 The master key to use.
     * @param prefKeyEncryptionScheme   The scheme to use for encrypting keys.
     * @param prefValueEncryptionScheme The scheme to use for encrypting values.
     * @return The SharedPreferences instance that encrypts all data.
     * @throws GeneralSecurityException when a bad master key or keyset has been attempted
     * @throws IOException              when fileName can not be used
     */
    public static SharedPreferences create(Context context,
            String fileName,
            MasterKey masterKey,
            PrefKeyEncryptionScheme prefKeyEncryptionScheme,
            PrefValueEncryptionScheme prefValueEncryptionScheme)
            throws GeneralSecurityException, IOException {
        return null;
    }

    /**
     * Opens an instance of encrypted SharedPreferences
     *
     * @param fileName                  The name of the file to open; can not contain path
     *                                  separators.
     * @param masterKeyAlias            The alias of the master key to use.
     * @param context                   The context to use to open the preferences file.
     * @param prefKeyEncryptionScheme   The scheme to use for encrypting keys.
     * @param prefValueEncryptionScheme The scheme to use for encrypting values.
     * @return The SharedPreferences instance that encrypts all data.
     * @throws GeneralSecurityException when a bad master key or keyset has been attempted
     * @throws IOException              when fileName can not be used
     * @deprecated Use {@link #create(Context, String, MasterKey,
     * PrefKeyEncryptionScheme, PrefValueEncryptionScheme)} instead.
     */
    @Deprecated
    public static SharedPreferences create(String fileName,
            String masterKeyAlias,
            Context context,
            PrefKeyEncryptionScheme prefKeyEncryptionScheme,
            PrefValueEncryptionScheme prefValueEncryptionScheme)
            throws GeneralSecurityException, IOException {
        return null;
    }

    /**
     * The encryption scheme to encrypt keys.
     */
    public enum PrefKeyEncryptionScheme {
        /**
         * Pref keys are encrypted deterministically with AES256-SIV-CMAC (RFC 5297).
         *
         * For more information please see the Tink documentation:
         *
         * <a href="https://google.github.io/tink/javadoc/tink/1.4.0/com/google/crypto/tink/daead/AesSivKeyManager.html">AesSivKeyManager</a>.aes256SivTemplate()
         */
        AES256_SIV;
    }
    /**
     * The encryption scheme to encrypt values.
     */
    public enum PrefValueEncryptionScheme {
        /**
         * Pref values are encrypted with AES256-GCM. The associated data is the encrypted pref key.
         *
         * For more information please see the Tink documentation:
         *
         * <a href="https://google.github.io/tink/javadoc/tink/1.4.0/com/google/crypto/tink/aead/AesGcmKeyManager.html">AesGcmKeyManager</a>.aes256GcmTemplate()
         */
        AES256_GCM;
    }

    // SharedPreferences methods
    @Override
    public Map<String, ?> getAll() {
        return null;
    }

    @Override
    public String getString(String key, String defValue) {
        return null;
    }

    @Override
    public Set<String> getStringSet(String key, Set<String> defValues) {
        return null;
    }

    @Override
    public int getInt(String key, int defValue) {
        return -1;
    }

    @Override
    public long getLong(String key, long defValue) {
        return -1;
    }

    @Override
    public float getFloat(String key, float defValue) {
        return -1;
    }

    @Override
    public boolean getBoolean(String key, boolean defValue) {
        return false;
    }

    @Override
    public boolean contains(String key) {
        return false;
    }

    @Override
    public SharedPreferences.Editor edit() {
        return null;
    }

    @Override
    public void registerOnSharedPreferenceChangeListener(
            OnSharedPreferenceChangeListener listener) {
    }
    @Override
    public void unregisterOnSharedPreferenceChangeListener(
            OnSharedPreferenceChangeListener listener) {
    }
}
