// Generated automatically from org.springframework.web.reactive.function.client.ClientRequestObservationConvention for testing purposes

package org.springframework.web.reactive.function.client;

import io.micrometer.observation.Context;

public interface ClientRequestObservationConvention
{
    default boolean supportsContext(Context p0){ return false; }
}
