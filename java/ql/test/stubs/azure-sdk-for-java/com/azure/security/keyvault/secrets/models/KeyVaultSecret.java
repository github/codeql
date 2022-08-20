// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.azure.security.keyvault.secrets.models;

import com.azure.security.keyvault.secrets.SecretClient;

import java.util.Map;
import java.util.Objects;

/**
 *  Secret is the resource consisting of name, value and its attributes specified in {@link SecretProperties}.
 *  It is managed by Secret Service.
 *
 *  @see SecretClient
 *  @see SecretAsyncClient
 */
public class KeyVaultSecret {
    /**
     * Creates an empty instance of the Secret.
     */
    KeyVaultSecret() {
    }

    /**
     * Creates a Secret with {@code name} and {@code value}.
     *
     * @param name The name of the secret.
     * @param value the value of the secret.
     */
    public KeyVaultSecret(String name, String value) {
    }

    /**
     * Get the value of the secret.
     *
     * @return the secret value
     */
    public String getValue() {
        return null;
    }

    /**
     * Get the secret identifier.
     *
     * @return the secret identifier.
     */
    public String getId() {
        return null;
    }

    /**
     * Get the secret name.
     *
     * @return the secret name.
     */
    public String getName() {
        return null;
    }

    /**
     * Get the secret properties
     * @return the Secret properties
     */
    public SecretProperties getProperties() {
        return null;
    }

    /**
     * Set the secret properties
     * @param properties The Secret properties
     * @throws NullPointerException if {@code properties} is null.
     * @return the updated secret object
     */
    public KeyVaultSecret setProperties(SecretProperties properties) {
        return null;
    }
}
