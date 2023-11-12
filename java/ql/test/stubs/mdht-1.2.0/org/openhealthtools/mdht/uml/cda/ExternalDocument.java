// Generated automatically from org.openhealthtools.mdht.uml.cda.ExternalDocument for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.INT;
import org.openhealthtools.mdht.uml.hl7.vocab.ActClassDocument;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface ExternalDocument extends org.openhealthtools.mdht.uml.hl7.rim.Act
{
    ActClassDocument getClassCode();
    ActMood getMoodCode();
    CD getCode();
    ED getText();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    II getSetId();
    INT getVersionNumber();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNullFlavor();
    boolean validateMoodCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(ActClassDocument p0);
    void setCode(CD p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setSetId(II p0);
    void setText(ED p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void setVersionNumber(INT p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
}
