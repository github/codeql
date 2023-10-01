// Generated automatically from org.openhealthtools.mdht.uml.cda.Component4 for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.Encounter;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Observation;
import org.openhealthtools.mdht.uml.cda.ObservationMedia;
import org.openhealthtools.mdht.uml.cda.Organizer;
import org.openhealthtools.mdht.uml.cda.Procedure;
import org.openhealthtools.mdht.uml.cda.RegionOfInterest;
import org.openhealthtools.mdht.uml.cda.SubstanceAdministration;
import org.openhealthtools.mdht.uml.cda.Supply;
import org.openhealthtools.mdht.uml.hl7.datatypes.BL;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.INT;
import org.openhealthtools.mdht.uml.hl7.rim.ActRelationship;
import org.openhealthtools.mdht.uml.hl7.vocab.ActRelationshipHasComponent;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Component4 extends ActRelationship
{
    ActRelationshipHasComponent getTypeCode();
    BL getSeperatableInd();
    Boolean getContextConductionInd();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    Encounter getEncounter();
    INT getSequenceNumber();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Observation getObservation();
    ObservationMedia getObservationMedia();
    Organizer getOrganizer();
    Procedure getProcedure();
    RegionOfInterest getRegionOfInterest();
    SubstanceAdministration getSubstanceAdministration();
    Supply getSupply();
    boolean isSetContextConductionInd();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateClinicalStatement(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateContextConductionInd(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    org.openhealthtools.mdht.uml.cda.Act getAct();
    void setAct(org.openhealthtools.mdht.uml.cda.Act p0);
    void setContextConductionInd(Boolean p0);
    void setEncounter(Encounter p0);
    void setNullFlavor(NullFlavor p0);
    void setObservation(Observation p0);
    void setObservationMedia(ObservationMedia p0);
    void setOrganizer(Organizer p0);
    void setProcedure(Procedure p0);
    void setRegionOfInterest(RegionOfInterest p0);
    void setSeperatableInd(BL p0);
    void setSequenceNumber(INT p0);
    void setSubstanceAdministration(SubstanceAdministration p0);
    void setSupply(Supply p0);
    void setTypeCode(ActRelationshipHasComponent p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetContextConductionInd();
    void unsetNullFlavor();
    void unsetTypeCode();
}
