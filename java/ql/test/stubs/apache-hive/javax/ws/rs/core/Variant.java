// Generated automatically from javax.ws.rs.core.Variant for testing purposes

package javax.ws.rs.core;

import java.util.List;
import java.util.Locale;
import javax.ws.rs.core.MediaType;

public class Variant
{
    protected Variant() {}
    abstract static public class VariantListBuilder
    {
        protected VariantListBuilder(){}
        public abstract List<Variant> build();
        public abstract Variant.VariantListBuilder add();
        public abstract Variant.VariantListBuilder encodings(String... p0);
        public abstract Variant.VariantListBuilder languages(Locale... p0);
        public abstract Variant.VariantListBuilder mediaTypes(MediaType... p0);
        public static Variant.VariantListBuilder newInstance(){ return null; }
    }
    public Locale getLanguage(){ return null; }
    public MediaType getMediaType(){ return null; }
    public String getEncoding(){ return null; }
    public String getLanguageString(){ return null; }
    public String toString(){ return null; }
    public Variant(MediaType p0, Locale p1, String p2){}
    public Variant(MediaType p0, String p1, String p2){}
    public Variant(MediaType p0, String p1, String p2, String p3){}
    public Variant(MediaType p0, String p1, String p2, String p3, String p4){}
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static Variant.VariantListBuilder encodings(String... p0){ return null; }
    public static Variant.VariantListBuilder languages(Locale... p0){ return null; }
    public static Variant.VariantListBuilder mediaTypes(MediaType... p0){ return null; }
}
