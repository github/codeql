// Generated automatically from org.openhealthtools.mdht.uml.cda.ClinicalStatement for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.AssignedEntity;
import org.openhealthtools.mdht.uml.cda.ClinicalDocument;
import org.openhealthtools.mdht.uml.cda.Encounter;
import org.openhealthtools.mdht.uml.cda.Observation;
import org.openhealthtools.mdht.uml.cda.ObservationMedia;
import org.openhealthtools.mdht.uml.cda.Organizer;
import org.openhealthtools.mdht.uml.cda.ParticipantRole;
import org.openhealthtools.mdht.uml.cda.Procedure;
import org.openhealthtools.mdht.uml.cda.RegionOfInterest;
import org.openhealthtools.mdht.uml.cda.Section;
import org.openhealthtools.mdht.uml.cda.SubstanceAdministration;
import org.openhealthtools.mdht.uml.cda.Supply;
import org.openhealthtools.mdht.uml.hl7.vocab.x_ActRelationshipEntryRelationship;

public interface ClinicalStatement extends org.openhealthtools.mdht.uml.hl7.rim.Act
{
    ClinicalDocument getClinicalDocument();
    EList<AssignedEntity> getAssignedEntities();
    EList<ClinicalStatement> getEntryRelationshipTargets(Object p0);
    EList<ClinicalStatement> getEntryRelationshipTargets(x_ActRelationshipEntryRelationship p0, Object p1);
    EList<Encounter> getEncounters();
    EList<Observation> getObservations();
    EList<ObservationMedia> getObservationMedia();
    EList<Organizer> getOrganizers();
    EList<ParticipantRole> getParticipantRoles();
    EList<Procedure> getProcedures();
    EList<RegionOfInterest> getRegionsOfInterest();
    EList<SubstanceAdministration> getSubstanceAdministrations();
    EList<Supply> getSupplies();
    EList<org.openhealthtools.mdht.uml.cda.Act> getActs();
    Section getSection();
    boolean hasActTemplate(String p0);
    boolean hasCode(String p0, String p1, String p2);
    boolean hasEncounterTemplate(String p0);
    boolean hasObservationMediaTemplate(String p0);
    boolean hasObservationTemplate(String p0);
    boolean hasOrganizerTemplate(String p0);
    boolean hasProcedureTemplate(String p0);
    boolean hasRegionOfInterestTemplate(String p0);
    boolean hasSubstanceAdministrationTemplate(String p0);
    boolean hasSupplyTemplate(String p0);
    boolean hasTemplateId(String p0);
    void addAct(org.openhealthtools.mdht.uml.cda.Act p0);
    void addEncounter(Encounter p0);
    void addObservation(Observation p0);
    void addObservationMedia(ObservationMedia p0);
    void addOrganizer(Organizer p0);
    void addProcedure(Procedure p0);
    void addRegionOfInterest(RegionOfInterest p0);
    void addSubstanceAdministration(SubstanceAdministration p0);
    void addSupply(Supply p0);
}
