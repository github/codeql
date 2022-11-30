package com.semmle.js.extractor;

import com.semmle.util.process.Env;

public class ExtractorOptionsUtil {
    public static String readExtractorOption(String... option) {
        StringBuilder name = new StringBuilder("CODEQL_EXTRACTOR_JAVASCRIPT_OPTION");
        for (String segment : option)
            name.append("_").append(segment.toUpperCase());
        return Env.systemEnv().getNonEmpty(name.toString());
    }
}
