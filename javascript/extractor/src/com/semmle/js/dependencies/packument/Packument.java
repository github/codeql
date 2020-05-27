package com.semmle.js.dependencies.packument;

import java.util.Map;

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
