// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.azure.security.keyvault.secrets.models;

import java.util.Map;

import com.azure.security.keyvault.secrets.SecretClient;

/**
 * SecretProperties is the resource containing all the properties of the secret except its value.
 * It is managed by the Secret Service.
 *
 *  @see SecretClient
 *  @see SecretAsyncClient
 */
public class SecretProperties {
    SecretProperties(String secretName) {
    }

    /**
     * Creates empty instance of SecretProperties.
     */
    public SecretProperties() { }

    /**
     * Get the secret name.
     *
     * @return the name of the secret.
     */
    public String getName() {
        return null;
    }

    /**
     * Get the recovery level of the secret.

     * @return the recoveryLevel of the secret.
     */
    public String getRecoveryLevel() {
        return null;
    }

    /**
     * Get the enabled value.
     *
     * @return the enabled value
     */
    public Boolean isEnabled() {
        return false;
    }

    /**
     * Set the enabled value.
     *
     * @param enabled The enabled value to set
     * @throws NullPointerException if {@code enabled} is null.
     * @return the SecretProperties object itself.
     */
    public SecretProperties setEnabled(Boolean enabled) {
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
     * Get the content type.
     *
     * @return the content type.
     */
    public String getContentType() {
        return null;
    }

    /**
     * Set the contentType.
     *
     * @param contentType The contentType to set
     * @return the updated SecretProperties object itself.
     */
    public SecretProperties setContentType(String contentType) {
        return null;
    }

    /**
     * Get the tags associated with the secret.
     *
     * @return the value of the tags.
     */
    public Map<String, String> getTags() {
        return null;
    }

    /**
     * Set the tags to be associated with the secret.
     *
     * @param tags The tags to set
     * @return the updated SecretProperties object itself.
     */
    public SecretProperties setTags(Map<String, String> tags) {
        return null;
    }

    /**
     * Get the keyId identifier.
     *
     * @return the keyId identifier.
     */
    public String getKeyId() {
        return null;
    }

    /**
     * Get the managed value.
     *
     * @return the managed value
     */
    public Boolean isManaged() {
        return null;
    }

    /**
     * Get the version of the secret.
     *
     * @return the version of the secret.
     */
    public String getVersion() {
        return null;
    }

    /**
     * Gets the number of days a secret is retained before being deleted for a soft delete-enabled Key Vault.
     * @return the recoverable days.
     */
    public Integer getRecoverableDays() {
        return null;
    }
}
