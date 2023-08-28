// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.ED for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.ecore.util.FeatureMap;
import org.openhealthtools.mdht.uml.hl7.datatypes.BIN;
import org.openhealthtools.mdht.uml.hl7.datatypes.TEL;
import org.openhealthtools.mdht.uml.hl7.vocab.CompressionAlgorithm;
import org.openhealthtools.mdht.uml.hl7.vocab.IntegrityCheckAlgorithm;

public interface ED extends BIN
{
    CompressionAlgorithm getCompression();
    ED addText(String p0);
    ED getThumbnail();
    FeatureMap getMixed();
    IntegrityCheckAlgorithm getIntegrityCheckAlgorithm();
    String getLanguage();
    String getMediaType();
    String getText();
    TEL getReference();
    boolean isSetCompression();
    boolean isSetIntegrityCheckAlgorithm();
    boolean isSetMediaType();
    boolean matches(String p0);
    boolean validateThumbnailThumbnail(DiagnosticChain p0, Map<Object, Object> p1);
    byte[] getIntegrityCheck();
    void setCompression(CompressionAlgorithm p0);
    void setIntegrityCheck(byte[] p0);
    void setIntegrityCheckAlgorithm(IntegrityCheckAlgorithm p0);
    void setLanguage(String p0);
    void setMediaType(String p0);
    void setReference(TEL p0);
    void setThumbnail(ED p0);
    void unsetCompression();
    void unsetIntegrityCheckAlgorithm();
    void unsetMediaType();
}
