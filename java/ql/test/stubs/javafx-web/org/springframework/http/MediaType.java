// Generated automatically from org.springframework.http.MediaType for testing purposes

package org.springframework.http;

import java.io.Serializable;
import java.nio.charset.Charset;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import org.springframework.util.MimeType;

public class MediaType extends MimeType implements Serializable
{
    protected MediaType() {}
    protected void checkParameters(String p0, String p1){}
    public MediaType copyQualityValue(MediaType p0){ return null; }
    public MediaType removeQualityValue(){ return null; }
    public MediaType(MediaType p0, Charset p1){}
    public MediaType(MediaType p0, Map<String, String> p1){}
    public MediaType(MimeType p0){}
    public MediaType(String p0){}
    public MediaType(String p0, String p1){}
    public MediaType(String p0, String p1, Charset p2){}
    public MediaType(String p0, String p1, Map<String, String> p2){}
    public MediaType(String p0, String p1, double p2){}
    public boolean includes(MediaType p0){ return false; }
    public boolean isCompatibleWith(MediaType p0){ return false; }
    public double getQualityValue(){ return 0; }
    public static Comparator<MediaType> QUALITY_VALUE_COMPARATOR = null;
    public static Comparator<MediaType> SPECIFICITY_COMPARATOR = null;
    public static List<MediaType> asMediaTypes(List<MimeType> p0){ return null; }
    public static List<MediaType> parseMediaTypes(List<String> p0){ return null; }
    public static List<MediaType> parseMediaTypes(String p0){ return null; }
    public static MediaType ALL = null;
    public static MediaType APPLICATION_ATOM_XML = null;
    public static MediaType APPLICATION_CBOR = null;
    public static MediaType APPLICATION_FORM_URLENCODED = null;
    public static MediaType APPLICATION_JSON = null;
    public static MediaType APPLICATION_JSON_UTF8 = null;
    public static MediaType APPLICATION_NDJSON = null;
    public static MediaType APPLICATION_OCTET_STREAM = null;
    public static MediaType APPLICATION_PDF = null;
    public static MediaType APPLICATION_PROBLEM_JSON = null;
    public static MediaType APPLICATION_PROBLEM_JSON_UTF8 = null;
    public static MediaType APPLICATION_PROBLEM_XML = null;
    public static MediaType APPLICATION_RSS_XML = null;
    public static MediaType APPLICATION_STREAM_JSON = null;
    public static MediaType APPLICATION_XHTML_XML = null;
    public static MediaType APPLICATION_XML = null;
    public static MediaType IMAGE_GIF = null;
    public static MediaType IMAGE_JPEG = null;
    public static MediaType IMAGE_PNG = null;
    public static MediaType MULTIPART_FORM_DATA = null;
    public static MediaType MULTIPART_MIXED = null;
    public static MediaType MULTIPART_RELATED = null;
    public static MediaType TEXT_EVENT_STREAM = null;
    public static MediaType TEXT_HTML = null;
    public static MediaType TEXT_MARKDOWN = null;
    public static MediaType TEXT_PLAIN = null;
    public static MediaType TEXT_XML = null;
    public static MediaType asMediaType(MimeType p0){ return null; }
    public static MediaType parseMediaType(String p0){ return null; }
    public static MediaType valueOf(String p0){ return null; }
    public static String ALL_VALUE = null;
    public static String APPLICATION_ATOM_XML_VALUE = null;
    public static String APPLICATION_CBOR_VALUE = null;
    public static String APPLICATION_FORM_URLENCODED_VALUE = null;
    public static String APPLICATION_JSON_UTF8_VALUE = null;
    public static String APPLICATION_JSON_VALUE = null;
    public static String APPLICATION_NDJSON_VALUE = null;
    public static String APPLICATION_OCTET_STREAM_VALUE = null;
    public static String APPLICATION_PDF_VALUE = null;
    public static String APPLICATION_PROBLEM_JSON_UTF8_VALUE = null;
    public static String APPLICATION_PROBLEM_JSON_VALUE = null;
    public static String APPLICATION_PROBLEM_XML_VALUE = null;
    public static String APPLICATION_RSS_XML_VALUE = null;
    public static String APPLICATION_STREAM_JSON_VALUE = null;
    public static String APPLICATION_XHTML_XML_VALUE = null;
    public static String APPLICATION_XML_VALUE = null;
    public static String IMAGE_GIF_VALUE = null;
    public static String IMAGE_JPEG_VALUE = null;
    public static String IMAGE_PNG_VALUE = null;
    public static String MULTIPART_FORM_DATA_VALUE = null;
    public static String MULTIPART_MIXED_VALUE = null;
    public static String MULTIPART_RELATED_VALUE = null;
    public static String TEXT_EVENT_STREAM_VALUE = null;
    public static String TEXT_HTML_VALUE = null;
    public static String TEXT_MARKDOWN_VALUE = null;
    public static String TEXT_PLAIN_VALUE = null;
    public static String TEXT_XML_VALUE = null;
    public static String toString(Collection<MediaType> p0){ return null; }
    public static void sortByQualityValue(List<MediaType> p0){}
    public static void sortBySpecificity(List<MediaType> p0){}
    public static void sortBySpecificityAndQuality(List<MediaType> p0){}
}
