// Generated automatically from org.openhealthtools.mdht.uml.cda.Reference for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.ExternalAct;
import org.openhealthtools.mdht.uml.cda.ExternalDocument;
import org.openhealthtools.mdht.uml.cda.ExternalObservation;
import org.openhealthtools.mdht.uml.cda.ExternalProcedure;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.BL;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.rim.ActRelationship;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_ActRelationshipExternalReference;

public interface Reference extends ActRelationship
{
    BL getSeperatableInd();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    ExternalAct getExternalAct();
    ExternalDocument getExternalDocument();
    ExternalObservation getExternalObservation();
    ExternalProcedure getExternalProcedure();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateExternalActChoice(DiagnosticChain p0, Map<Object, Object> p1);
    void setExternalAct(ExternalAct p0);
    void setExternalDocument(ExternalDocument p0);
    void setExternalObservation(ExternalObservation p0);
    void setExternalProcedure(ExternalProcedure p0);
    void setNullFlavor(NullFlavor p0);
    void setSeperatableInd(BL p0);
    void setTypeCode(x_ActRelationshipExternalReference p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
    void unsetTypeCode();
    x_ActRelationshipExternalReference getTypeCode();
}
