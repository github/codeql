// Generated automatically from org.openhealthtools.mdht.uml.cda.Component5 for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Section;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.ActRelationship;
import org.openhealthtools.mdht.uml.hl7.vocab.ActRelationshipHasComponent;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Component5 extends ActRelationship
{
    ActRelationshipHasComponent getTypeCode();
    Boolean getContextConductionInd();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Section getSection();
    boolean isSetContextConductionInd();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateContextConductionInd(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setContextConductionInd(Boolean p0);
    void setNullFlavor(NullFlavor p0);
    void setSection(Section p0);
    void setTypeCode(ActRelationshipHasComponent p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetContextConductionInd();
    void unsetNullFlavor();
    void unsetTypeCode();
}
