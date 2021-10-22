package com.example;

import java.util.ArrayList;
import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlID;
import javax.xml.bind.annotation.XmlSchemaType;
import javax.xml.bind.annotation.XmlType;
import javax.xml.datatype.XMLGregorianCalendar;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ResponseType", propOrder = {
    "assertionOrEncryptedAssertion"
})
public class ResponseType {
    @XmlElements({
        @XmlElement(name = "EncryptedAssertion", namespace = "urn:oasis:names:tc:SAML:2.0:assertion", type = EncryptedDataType.class),
        @XmlElement(name = "Assertion", namespace = "urn:oasis:names:tc:SAML:2.0:assertion", type = AssertionType.class)
    })
    protected List<Object> assertionOrEncryptedAssertion;

    public List<Object> getAssertionOrEncryptedAssertion() {
        if (assertionOrEncryptedAssertion == null) {
            assertionOrEncryptedAssertion = new ArrayList<Object>();
        }
        return this.assertionOrEncryptedAssertion;
    }
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "EncryptedDataType")
class EncryptedDataType {
    // Leave as blank
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "NameIDType", propOrder = {
    "value"
})
class NameIDType {
    // Leave as blank
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SignatureType", propOrder = {
    "signedInfo",
    "signatureValue",
    "keyInfo",
    "object"
})
class SignatureType {
    // Leave as blank
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "SubjectType", propOrder = {
    "content"
})
class SubjectType {
    // Leave as blank
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "ConditionsType", propOrder = {
    "conditionOrAudienceRestrictionOrOneTimeUse"
})
class ConditionsType {
    // Leave as blank
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "StatementAbstractType")
class StatementAbstractType {
    // Leave as blank
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AdviceType", propOrder = {
    "assertionIDRefOrAssertionURIRefOrAssertion"
})
class AdviceType {
    // Leave as blank
}

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AssertionType", propOrder = {
    "issuer",
    "signature",
    "subject",
    "conditions",
    "advice",
    "statementOrAuthnStatementOrAuthzDecisionStatement"
})
class AssertionType {
    @XmlElement(name = "Issuer", required = true)
    protected NameIDType issuer;
    @XmlElement(name = "Signature", namespace = "http://www.w3.org/2000/09/xmldsig#")
    protected SignatureType signature;
    @XmlElement(name = "Subject")
    protected SubjectType subject;
    @XmlElement(name = "Conditions")
    protected ConditionsType conditions;
    @XmlElement(name = "Advice")
    protected AdviceType advice;
    @XmlElements({
        @XmlElement(name = "AuthnStatement", type = Object.class), // Not implemented
        @XmlElement(name = "Statement"),
        @XmlElement(name = "AttributeStatement", type = Object.class), // Not implemented
        @XmlElement(name = "AuthzDecisionStatement", type = Object.class) // Not implemented
    })
    protected List<StatementAbstractType> statementOrAuthnStatementOrAuthzDecisionStatement;
    @XmlAttribute(name = "Version", required = true)
    protected String version;
    @XmlAttribute(name = "ID", required = true)
    @XmlSchemaType(name = "ID")
    protected String id;
    @XmlAttribute(name = "IssueInstant", required = true)
    @XmlSchemaType(name = "dateTime")
    protected XMLGregorianCalendar issueInstant;

    public NameIDType getIssuer() {
        return issuer;
    }

    public void setIssuer(NameIDType value) {
        this.issuer = value;
    }

    public SignatureType getSignature() {
        return signature;
    }

    public void setSignature(SignatureType value) {
        this.signature = value;
    }

    public SubjectType getSubject() {
        return subject;
    }

    public void setSubject(SubjectType value) {
        this.subject = value;
    }

    public ConditionsType getConditions() {
        return conditions;
    }

    public void setConditions(ConditionsType value) {
        this.conditions = value;
    }

    public AdviceType getAdvice() {
        return advice;
    }

    public void setAdvice(AdviceType value) {
        this.advice = value;
    }

    public List<StatementAbstractType> getStatementOrAuthnStatementOrAuthzDecisionStatement() {
        if (statementOrAuthnStatementOrAuthzDecisionStatement == null) {
            statementOrAuthnStatementOrAuthzDecisionStatement = new ArrayList<StatementAbstractType>();
        }
        return this.statementOrAuthnStatementOrAuthzDecisionStatement;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String value) {
        this.version = value;
    }

    public String getID() {
        return id;
    }

    public void setID(String value) {
        this.id = value;
    }

    public XMLGregorianCalendar getIssueInstant() {
        return issueInstant;
    }

    public void setIssueInstant(XMLGregorianCalendar value) {
        this.issueInstant = value;
    }
}
