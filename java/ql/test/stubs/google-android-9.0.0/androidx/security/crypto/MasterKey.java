/*
 * Copyright 2020 The Android Open Source Project
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

import java.io.IOException;
import java.security.GeneralSecurityException;

/**
 * Wrapper for a master key used in the library.
 *
 * On Android M (API 23) and above, this is class references a key that's stored in the
 * Android Keystore. On Android L (API 21, 22), there isn't a master key.
 */
public final class MasterKey {
    static final String KEYSTORE_PATH_URI = "android-keystore://";
    /**
     * The default master key alias.
     */
    public static final String DEFAULT_MASTER_KEY_ALIAS = "_androidx_security_master_key_";

    /**
     * The default and recommended size for the master key.
     */
    public static final int DEFAULT_AES_GCM_MASTER_KEY_SIZE = 256;

    /**
     * Algorithm/Cipher choices used for the master key.
     */
    public enum KeyScheme {
        AES256_GCM
    }

    /**
     * The default validity period for authentication in seconds.
     */
    public static int getDefaultAuthenticationValidityDurationSeconds() {
        return -1;
    }

    /* package */ MasterKey(String keyAlias, Object keyGenParameterSpec) {
    }

    /**
     * Checks if this key is backed by the Android Keystore.
     *
     * @return {@code true} if the key is in Android Keystore, {@code false} otherwise. This
     * method always returns false when called on Android Lollipop (API 21 and 22).
     */
    public boolean isKeyStoreBacked() {
        return false;
    }

    /**
     * Gets whether user authentication is required to use this key.
     *
     * This method always returns {@code false} on Android L (API 21 + 22).
     */
    public boolean isUserAuthenticationRequired() {
        return false;
    }

    /**
     * Gets the duration in seconds that the key is unlocked for following user authentication.
     *
     * The value returned for this method is only meaningful on Android M+ (API 23) when
     * {@link #isUserAuthenticationRequired()} returns {@code true}.
     *
     * @return The duration the key is unlocked for in seconds.
     */
    public int getUserAuthenticationValidityDurationSeconds() {
        return -1;
    }

    /**
     * Gets whether the key is backed by strong box.
     */
    public boolean isStrongBoxBacked() {
        return false;
    }

    /* package */ String getKeyAlias() {
        return null;
    }

    /**
     * Builder for generating a {@link MasterKey}.
     */
    public static final class Builder {
        /**
         * Creates a builder for a {@link MasterKey} using the default alias of
         * {@link #DEFAULT_MASTER_KEY_ALIAS}.
         *
         * @param context The context to use with this master key.
         */
        public Builder(Context context) {
        }

        /**
         * Creates a builder for a {@link MasterKey}.
         *
         * @param context The context to use with this master key.
         */
        public Builder(Context context, String keyAlias) {
        }

        /**
         * Sets a {@link KeyScheme} to be used for the master key.
         * This uses a default {@link KeyGenParameterSpec} associated with the provided
         * {@code KeyScheme}.
         * NOTE: Either this method OR {@link #setKeyGenParameterSpec} should be used to set
         * the parameters to use for building the master key. Calling either function after
         * the other will throw an {@link IllegalArgumentException}.
         *
         * @param keyScheme The KeyScheme to use.
         * @return This builder.
         */
        public Builder setKeyScheme(KeyScheme keyScheme) {
            return null;
        }

        /**
         * When used with {@link #setKeyScheme(KeyScheme)}, sets that the built master key should
         * require the user to authenticate before it's unlocked, probably using the
         * androidx.biometric library.
         *
         * This method sets the validity duration of the key to
         * {@link #getDefaultAuthenticationValidityDurationSeconds()}.
         *
         * @param authenticationRequired Whether user authentication should be required to use
         *                               the key.
         * @return This builder.
         */
        public Builder setUserAuthenticationRequired(boolean authenticationRequired) {
            return null;
        }

        /**
         * When used with {@link #setKeyScheme(KeyScheme)}, sets that the built master key should
         * require the user to authenticate before it's unlocked, probably using the
         * androidx.biometric library, and that the key should remain unlocked for the provided
         * duration.
         *
         * @param authenticationRequired                    Whether user authentication should be
         *                                                  required to use the key.
         * @param userAuthenticationValidityDurationSeconds Duration in seconds that the key
         *                                                  should remain unlocked following user
         *                                                  authentication.
         * @return This builder.
         */
        public Builder setUserAuthenticationRequired(boolean authenticationRequired,
                int userAuthenticationValidityDurationSeconds) {
            return null;
        }

        /**
         * Sets whether or not to request this key is strong box backed. This setting is only
         * applicable on {@link Build.VERSION_CODES#P} and above, and only on devices that
         * support Strongbox.
         *
         * @param requestStrongBoxBacked Whether to request to use strongbox
         * @return This builder.
         */
        public Builder setRequestStrongBoxBacked(boolean requestStrongBoxBacked) {
            return null;
        }

        /**
         * Builds a {@link MasterKey} from this builder.
         *
         * @return The master key.
         */
        public MasterKey build() throws GeneralSecurityException, IOException {
            return null;
        }
    }
}