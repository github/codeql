package com.semmle.js.dependencies;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SemVer implements Comparable<SemVer> {
    private int major, minor, patch;
    private String preRelease;

    public SemVer(int major, int minor, int patch, String preRelease) {
        this.major = major;
        this.minor = minor;
        this.patch = patch;
        if (preRelease == null) {
            preRelease = "";
        }
        this.preRelease = preRelease;
    }

    public int getMajor() {
        return major;
    }

    public int getMinor() {
        return minor;
    }

    public int getPatch() {
        return patch;
    }

    public String getPreRelease() {
        return preRelease;
    }

    private static final Pattern pattern = Pattern.compile("(\\d+)(?:\\.(\\d+)(?:\\.(\\d+))?)?(-[0-9A-Za-z.-]*)?(\\+.*)?");

    public static SemVer tryParse(String str) {
        Matcher m = pattern.matcher(str);
        if (m.matches()) {
            int major = Integer.parseInt(m.group(1));
            int minor = m.group(2) == null ? 0 : Integer.parseInt(m.group(2));
            int patch = m.group(3) == null ? 0 : Integer.parseInt(m.group(3));
            String preRelease = m.group(4);
            return new SemVer(major, minor, patch, preRelease);
        } else {
            return null;
        }
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + major;
        result = prime * result + minor;
        result = prime * result + patch;
        result = prime * result + ((preRelease == null) ? 0 : preRelease.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        SemVer other = (SemVer) obj;
        if (major != other.major)
            return false;
        if (minor != other.minor)
            return false;
        if (patch != other.patch)
            return false;
        if (preRelease == null) {
            if (other.preRelease != null)
                return false;
        } else if (!preRelease.equals(other.preRelease))
            return false;
        return true;
    }

    @Override
    public int compareTo(SemVer other) {
        if (major != other.major) {
            return Integer.compare(major, other.major);
        }
        if (minor != other.minor) {
            return Integer.compare(minor, other.minor);
        }
        if (patch != other.patch) {
            return Integer.compare(patch, other.patch);
        }
        if (!preRelease.equals(other.preRelease)) {
            return preRelease.compareTo(other.preRelease);
        }
        return 0;
    }

    @Override
    public String toString() {
        return major + "." + minor + "." + patch + (preRelease.isEmpty() ? "" : "-" + preRelease);
    }
}
