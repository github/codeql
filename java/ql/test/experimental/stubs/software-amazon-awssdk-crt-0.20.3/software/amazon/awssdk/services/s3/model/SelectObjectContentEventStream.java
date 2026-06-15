// Generated automatically from software.amazon.awssdk.services.s3.model.SelectObjectContentEventStream for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Set;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ContinuationEvent;
import software.amazon.awssdk.services.s3.model.EndEvent;
import software.amazon.awssdk.services.s3.model.ProgressEvent;
import software.amazon.awssdk.services.s3.model.RecordsEvent;
import software.amazon.awssdk.services.s3.model.SelectObjectContentResponseHandler;
import software.amazon.awssdk.services.s3.model.StatsEvent;

public interface SelectObjectContentEventStream extends SdkPojo
{
    default SelectObjectContentEventStream.EventType sdkEventType(){ return null; }
    static ContinuationEvent.Builder contBuilder(){ return null; }
    static EndEvent.Builder endBuilder(){ return null; }
    static ProgressEvent.Builder progressBuilder(){ return null; }
    static RecordsEvent.Builder recordsBuilder(){ return null; }
    static SelectObjectContentEventStream UNKNOWN = null;
    static StatsEvent.Builder statsBuilder(){ return null; }
    static public enum EventType
    {
        CONT, END, PROGRESS, RECORDS, STATS, UNKNOWN_TO_SDK_VERSION;
        private EventType() {}
        public String toString(){ return null; }
        public static SelectObjectContentEventStream.EventType fromValue(String p0){ return null; }
        public static Set<SelectObjectContentEventStream.EventType> knownValues(){ return null; }
    }
    void accept(SelectObjectContentResponseHandler.Visitor p0);
}
