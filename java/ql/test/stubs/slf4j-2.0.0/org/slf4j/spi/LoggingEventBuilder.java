/**
 * Copyright (c) 2004-2021 QOS.ch All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute,
 * sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or
 * substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */
package org.slf4j.spi;

import java.util.function.Supplier;
import org.slf4j.Marker;

public interface LoggingEventBuilder {
    LoggingEventBuilder setCause(Throwable cause);

    LoggingEventBuilder addMarker(Marker marker);

    LoggingEventBuilder addArgument(Object p);

    LoggingEventBuilder addArgument(Supplier<?> objectSupplier);

    LoggingEventBuilder addKeyValue(String key, Object value);

    LoggingEventBuilder addKeyValue(String key, Supplier<Object> value);

    void log(String message);

    void log(String message, Object arg);

    void log(String message, Object arg0, Object arg1);

    void log(String message, Object... args);

    void log(Supplier<String> messageSupplier);

}
