// Generated automatically from com.hubspot.jinjava.objects.serialization.PyishSerializable for testing purposes

package com.hubspot.jinjava.objects.serialization;

import com.fasterxml.jackson.databind.ObjectWriter;
import com.hubspot.jinjava.objects.PyWrapper;

public interface PyishSerializable extends PyWrapper
{
    default String toPyishString(){ return null; }
    static ObjectWriter SELF_WRITER = null;
    static String writeValueAsString(Object p0){ return null; }
}
