package com.semmle.js.dependencies.packument;

import java.util.Map;

public class PackageJson {
    private String name;
    private String version;
    private Map<String, String> dependencies;
    private Map<String, String> devDependencies;
    private Map<String, String> peerDependencies;
    private String types;
    private String typings;
    private String main;
    private Dist dist;

    public static class Dist {
        private String tarball;
    
        public String getTarball() {
            return tarball;
        }
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public Map<String, String> getDependencies() {
        return dependencies;
    }

    public void setDependencies(Map<String, String> dependencies) {
        this.dependencies = dependencies;
    }

    public Map<String, String> getDevDependencies() {
        return devDependencies;
    }

    public void setDevDependencies(Map<String, String> devDependencies) {
        this.devDependencies = devDependencies;
    }

    public Map<String, String> getPeerDependencies() {
        return peerDependencies;
    }

    public void setPeerDependencies(Map<String, String> peerDependencies) {
        this.peerDependencies = peerDependencies;
    }

    public String getTypes() {
        return types;
    }

    public void setTypes(String types) {
        this.types = types;
    }

    public String getTypings() {
        return typings;
    }

    public void setTypings(String typings) {
        this.typings = typings;
    }

    public String getMain() {
        return main;
    }

    public void setMain(String main) {
        this.main = main;
    }

    public Dist getDist() {
        return dist;
    }

    public void setDist(Dist dist) {
        this.dist = dist;
    }
}
