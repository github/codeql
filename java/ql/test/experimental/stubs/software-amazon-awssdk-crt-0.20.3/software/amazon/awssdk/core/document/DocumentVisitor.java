// Generated automatically from software.amazon.awssdk.core.document.DocumentVisitor for testing purposes

package software.amazon.awssdk.core.document;

import java.util.List;
import java.util.Map;
import software.amazon.awssdk.core.SdkNumber;
import software.amazon.awssdk.core.document.Document;

public interface DocumentVisitor<R>
{
    R visitBoolean(Boolean p0);
    R visitList(List<Document> p0);
    R visitMap(Map<String, Document> p0);
    R visitNull();
    R visitNumber(SdkNumber p0);
    R visitString(String p0);
}
