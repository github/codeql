// Generated automatically from software.amazon.awssdk.core.document.VoidDocumentVisitor for testing purposes

package software.amazon.awssdk.core.document;

import java.util.List;
import java.util.Map;
import software.amazon.awssdk.core.SdkNumber;
import software.amazon.awssdk.core.document.Document;

public interface VoidDocumentVisitor
{
    default void visitBoolean(Boolean p0){}
    default void visitList(List<Document> p0){}
    default void visitMap(Map<String, Document> p0){}
    default void visitNull(){}
    default void visitNumber(SdkNumber p0){}
    default void visitString(String p0){}
}
