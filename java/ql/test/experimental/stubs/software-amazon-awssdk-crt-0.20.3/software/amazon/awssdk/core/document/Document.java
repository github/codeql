// Generated automatically from software.amazon.awssdk.core.document.Document for testing purposes

package software.amazon.awssdk.core.document;

import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkNumber;
import software.amazon.awssdk.core.document.DocumentVisitor;
import software.amazon.awssdk.core.document.VoidDocumentVisitor;

public interface Document extends Serializable
{
    <R> R accept(DocumentVisitor<? extends R> p0);
    List<Document> asList();
    Map<String, Document> asMap();
    Object unwrap();
    SdkNumber asNumber();
    String asString();
    boolean asBoolean();
    default boolean isBoolean(){ return false; }
    default boolean isList(){ return false; }
    default boolean isMap(){ return false; }
    default boolean isNull(){ return false; }
    default boolean isNumber(){ return false; }
    default boolean isString(){ return false; }
    static Document fromBoolean(boolean p0){ return null; }
    static Document fromList(List<Document> p0){ return null; }
    static Document fromMap(Map<String, Document> p0){ return null; }
    static Document fromNull(){ return null; }
    static Document fromNumber(BigDecimal p0){ return null; }
    static Document fromNumber(BigInteger p0){ return null; }
    static Document fromNumber(SdkNumber p0){ return null; }
    static Document fromNumber(String p0){ return null; }
    static Document fromNumber(double p0){ return null; }
    static Document fromNumber(float p0){ return null; }
    static Document fromNumber(int p0){ return null; }
    static Document fromNumber(long p0){ return null; }
    static Document fromString(String p0){ return null; }
    static Document.ListBuilder listBuilder(){ return null; }
    static Document.MapBuilder mapBuilder(){ return null; }
    static public interface ListBuilder
    {
        Document build();
        Document.ListBuilder addBoolean(boolean p0);
        Document.ListBuilder addDocument(Document p0);
        Document.ListBuilder addMap(Consumer<Document.MapBuilder> p0);
        Document.ListBuilder addNull();
        Document.ListBuilder addNumber(BigDecimal p0);
        Document.ListBuilder addNumber(BigInteger p0);
        Document.ListBuilder addNumber(SdkNumber p0);
        Document.ListBuilder addNumber(String p0);
        Document.ListBuilder addNumber(double p0);
        Document.ListBuilder addNumber(float p0);
        Document.ListBuilder addNumber(int p0);
        Document.ListBuilder addNumber(long p0);
        Document.ListBuilder addString(String p0);
    }
    static public interface MapBuilder
    {
        Document build();
        Document.MapBuilder putBoolean(String p0, boolean p1);
        Document.MapBuilder putDocument(String p0, Document p1);
        Document.MapBuilder putList(String p0, Consumer<Document.ListBuilder> p1);
        Document.MapBuilder putList(String p0, List<Document> p1);
        Document.MapBuilder putMap(String p0, Consumer<Document.MapBuilder> p1);
        Document.MapBuilder putMap(String p0, Map<String, Document> p1);
        Document.MapBuilder putNull(String p0);
        Document.MapBuilder putNumber(String p0, BigDecimal p1);
        Document.MapBuilder putNumber(String p0, BigInteger p1);
        Document.MapBuilder putNumber(String p0, SdkNumber p1);
        Document.MapBuilder putNumber(String p0, String p1);
        Document.MapBuilder putNumber(String p0, double p1);
        Document.MapBuilder putNumber(String p0, float p1);
        Document.MapBuilder putNumber(String p0, int p1);
        Document.MapBuilder putNumber(String p0, long p1);
        Document.MapBuilder putString(String p0, String p1);
    }
    void accept(VoidDocumentVisitor p0);
}
