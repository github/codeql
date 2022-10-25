// Generated automatically from com.hubspot.jinjava.loader.ResourceLocator for testing purposes

package com.hubspot.jinjava.loader;

import com.hubspot.jinjava.interpret.JinjavaInterpreter;
import com.hubspot.jinjava.loader.LocationResolver;
import java.nio.charset.Charset;
import java.util.Optional;

public interface ResourceLocator
{
    String getString(String p0, Charset p1, JinjavaInterpreter p2);
    default Optional<LocationResolver> getLocationResolver(){ return null; }
}
