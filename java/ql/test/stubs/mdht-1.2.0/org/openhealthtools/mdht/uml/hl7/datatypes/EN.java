// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.EN for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.util.FeatureMap;
import org.openhealthtools.mdht.uml.hl7.datatypes.ANY;
import org.openhealthtools.mdht.uml.hl7.datatypes.ENXP;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.vocab.EntityNameUse;

public interface EN extends ANY
{
    EList<ENXP> getDelimiters();
    EList<ENXP> getFamilies();
    EList<ENXP> getGivens();
    EList<ENXP> getPrefixes();
    EList<ENXP> getSuffixes();
    EList<EntityNameUse> getUses();
    EN addDelimiter(String p0);
    EN addFamily(String p0);
    EN addGiven(String p0);
    EN addPrefix(String p0);
    EN addSuffix(String p0);
    EN addText(String p0);
    FeatureMap getMixed();
    FeatureMap getParts();
    IVL_TS getValidTime();
    String getText();
    String getText(boolean p0);
    boolean isSetUses();
    boolean validateDelimiter(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateFamily(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateGiven(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validatePrefix(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateSuffix(DiagnosticChain p0, Map<Object, Object> p1);
    void setValidTime(IVL_TS p0);
    void unsetUses();
}
