// Generated automatically from org.springframework.http.ContentDisposition for testing purposes

package org.springframework.http;

import java.nio.charset.Charset;
import java.time.ZonedDateTime;

public class ContentDisposition
{
    protected ContentDisposition() {}
    public Charset getCharset(){ return null; }
    public Long getSize(){ return null; }
    public String getFilename(){ return null; }
    public String getName(){ return null; }
    public String getType(){ return null; }
    public String toString(){ return null; }
    public ZonedDateTime getCreationDate(){ return null; }
    public ZonedDateTime getModificationDate(){ return null; }
    public ZonedDateTime getReadDate(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isAttachment(){ return false; }
    public boolean isFormData(){ return false; }
    public boolean isInline(){ return false; }
    public int hashCode(){ return 0; }
    public static ContentDisposition empty(){ return null; }
    public static ContentDisposition parse(String p0){ return null; }
    public static ContentDisposition.Builder attachment(){ return null; }
    public static ContentDisposition.Builder builder(String p0){ return null; }
    public static ContentDisposition.Builder formData(){ return null; }
    public static ContentDisposition.Builder inline(){ return null; }
    static public interface Builder
    {
        ContentDisposition build();
        ContentDisposition.Builder creationDate(ZonedDateTime p0);
        ContentDisposition.Builder filename(String p0);
        ContentDisposition.Builder filename(String p0, Charset p1);
        ContentDisposition.Builder modificationDate(ZonedDateTime p0);
        ContentDisposition.Builder name(String p0);
        ContentDisposition.Builder readDate(ZonedDateTime p0);
        ContentDisposition.Builder size(Long p0);
    }
}
