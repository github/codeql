package com.mitchellbosecke.pebble;

import com.mitchellbosecke.pebble.template.*;

public class PebbleEngine {
    public static class Builder {
        public Builder() {
        };

        public PebbleEngine build() {
            return new PebbleEngine();
        }
    };

    PebbleEngine() {
    }

    public PebbleTemplate getLiteralTemplate(String templateName) {
        return new PebbleTemplate() {
        };
    }

    public PebbleTemplate getTemplate(String templateName) {
        return new PebbleTemplate() {
        };
    }
}
