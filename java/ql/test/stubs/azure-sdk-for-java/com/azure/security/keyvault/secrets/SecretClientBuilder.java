// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.azure.security.keyvault.secrets;

import com.azure.core.credential.TokenCredential;

/**
 * This class provides a fluent builder API to help aid the configuration and instantiation of the {@link
 * SecretAsyncClient secret async client} and {@link SecretClient secret client},
 * by calling {@link SecretClientBuilder#buildAsyncClient() buildAsyncClient} and {@link
 * SecretClientBuilder#buildClient() buildClient} respectively.
 * It constructs an instance of the desired client.
 *
 * <p> The minimal configuration options required by {@link SecretClientBuilder secretClientBuilder} to build
 * {@link SecretAsyncClient} are {@link String vaultUrl} and {@link TokenCredential credential}. </p>
 *
 * {@codesnippet com.azure.security.keyvault.secrets.async.secretclient.construct}
 *
 * <p><strong>Samples to construct the sync client</strong></p>
 * {@codesnippet com.azure.security.keyvault.secretclient.sync.construct}
 *
 * <p>The {@link HttpLogDetailLevel log detail level}, multiple custom {@link HttpLoggingPolicy policies} and custom
 * {@link HttpClient http client} can be optionally configured in the {@link SecretClientBuilder}.</p>
 *
 * {@codesnippet com.azure.security.keyvault.secrets.async.secretclient.withhttpclient.instantiation}
 *
 * <p>Alternatively, custom {@link HttpPipeline http pipeline} with custom {@link HttpPipelinePolicy} policies and
 * {@link String vaultUrl}
 * can be specified. It provides finer control over the construction of {@link SecretAsyncClient client}</p>
 *
 * {@codesnippet com.azure.security.keyvault.secrets.async.secretclient.pipeline.instantiation}
 *
 * @see SecretClient
 * @see SecretAsyncClient
 */
public final class SecretClientBuilder {
    /**
     * The constructor with defaults.
     */
    public SecretClientBuilder() {
    }

    /**
     * Creates a {@link SecretClient} based on options set in the builder.
     * Every time {@code buildClient()} is called, a new instance of {@link SecretClient} is created.
     *
     * <p>If {@link SecretClientBuilder#pipeline(HttpPipeline) pipeline} is set, then the {@code pipeline} and
     * {@link SecretClientBuilder#vaultUrl(String) serviceEndpoint} are used to create the
     * {@link SecretClientBuilder client}. All other builder settings are ignored. If {@code pipeline} is not set,
     * then {@link SecretClientBuilder#credential(TokenCredential) key vault credential}, and
     * {@link SecretClientBuilder#vaultUrl(String)} key vault url are required to build the {@link SecretClient
     * client}.</p>
     *
     * @return A {@link SecretClient} with the options set from the builder.
     *
     * @throws IllegalStateException If {@link SecretClientBuilder#credential(TokenCredential)} or
     * {@link SecretClientBuilder#vaultUrl(String)} have not been set.
     */
    public SecretClient buildClient() {
        return null;
    }

    /**
     * Sets the vault URL to send HTTP requests to.
     *
     * @param vaultUrl The vault url is used as destination on Azure to send requests to. If you have a secret
     * identifier, create a new {@link KeyVaultSecretIdentifier} to parse it and obtain the {@code vaultUrl} and
     * other information.
     *
     * @return The updated {@link SecretClientBuilder} object.
     *
     * @throws IllegalArgumentException If {@code vaultUrl} is null or it cannot be parsed into a valid URL.
     * @throws NullPointerException If {@code vaultUrl} is {@code null}.
     */
    public SecretClientBuilder vaultUrl(String vaultUrl) {
        return null;
    }

    /**
     * Sets the credential to use when authenticating HTTP requests.
     *
     * @param credential The credential to use for authenticating HTTP requests.
     *
     * @return The updated {@link SecretClientBuilder} object.
     *
     * @throws NullPointerException If {@code credential} is {@code null}.
     */
    public SecretClientBuilder credential(TokenCredential credential) {
        return null;
    }
}
