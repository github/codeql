// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.azure.identity;

/**
 * The base class for all the credential builders.
 * @param <T> the type of the credential builder
 */
public abstract class CredentialBuilderBase<T extends CredentialBuilderBase<T>> {
    CredentialBuilderBase() {
    }
}