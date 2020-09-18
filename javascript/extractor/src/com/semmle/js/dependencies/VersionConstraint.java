package com.semmle.js.dependencies;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VersionConstraint {
    private String operator;
    private SemVer version;

    public VersionConstraint(String operator, SemVer version) {
        this.operator = operator;
        this.version = version;
    }

    public String getOperator() {
        return operator;
    }

    public SemVer getVersion() {
        return version;
    }

    private static final Pattern pattern = Pattern.compile("([~^<>=]*)\\s*(\\d.*)");

    public static List<VersionConstraint> parseVersionConstraints(String str) {
        String[] parts = str.split(",");
        List<VersionConstraint> constraints = new ArrayList<>();
        for (String part : parts) {
            part = part.trim();
            if (part.equals("*")) {
                constraints.add(new VersionConstraint("*", null));
                continue;
            }
            Matcher matcher = pattern.matcher(str);
            if (matcher.matches()) {
                String operator = matcher.group(1);
                String versionStr = matcher.group(2);
                if (operator.isEmpty() && versionStr.contains("x")) {
                    // Treat "1.x" as ">= 1.0"
                    operator = ">=";
                    versionStr = versionStr.replaceAll("x", "0");
                }
                SemVer version = SemVer.tryParse(versionStr);
                if (version != null) {
                    constraints.add(new VersionConstraint(operator, version));
                }
            }
        }
        return constraints;
    }
}
