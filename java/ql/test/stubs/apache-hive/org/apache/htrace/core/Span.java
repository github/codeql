// Generated automatically from org.apache.htrace.core.Span for testing purposes

package org.apache.htrace.core;

import java.util.List;
import java.util.Map;
import org.apache.htrace.core.SpanId;
import org.apache.htrace.core.TimelineAnnotation;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;

public interface Span
{
    List<TimelineAnnotation> getTimelineAnnotations();
    Map<String, String> getKVAnnotations();
    Span child(String p0);
    SpanId getSpanId();
    SpanId[] getParents();
    String getDescription();
    String getTracerId();
    String toJson();
    String toString();
    boolean isRunning();
    long getAccumulatedMillis();
    long getStartTimeMillis();
    long getStopTimeMillis();
    static public class SpanSerializer extends JsonSerializer<Span>
    {
        public SpanSerializer(){}
        public void serialize(Span p0, JsonGenerator p1, SerializerProvider p2){}
    }
    void addKVAnnotation(String p0, String p1);
    void addTimelineAnnotation(String p0);
    void setParents(SpanId[] p0);
    void setTracerId(String p0);
    void stop();
}
