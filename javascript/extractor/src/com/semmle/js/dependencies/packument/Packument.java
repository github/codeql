package com.semmle.js.dependencies.packument;

import java.util.Map;

/**
 * A package metadata object, informally known as a "packument".
 *
 * see https://github.com/npm/registry/blob/master/docs/REGISTRY-API.md#getpackage
 * see https://github.com/npm/registry/blob/master/docs/responses/package-metadata.md
 */
public class Packument {
    private String name;
    private Map<String, PackageJson> versions;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Map<String, PackageJson> getVersions() {
        return versions;
    }

    public void setVersions(Map<String, PackageJson> versions) {
        this.versions = versions;
    }
}
