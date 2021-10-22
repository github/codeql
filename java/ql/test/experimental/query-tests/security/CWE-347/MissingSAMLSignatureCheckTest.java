package com.example;

import java.io.ByteArrayInputStream;
import java.security.Key;
import java.security.PublicKey;
import java.util.Base64;
import java.util.List;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.Unmarshaller;
import javax.xml.crypto.MarshalException;
import javax.xml.crypto.dsig.dom.DOMValidateContext;
import javax.xml.crypto.dsig.XMLSignature;
import javax.xml.crypto.dsig.XMLSignatureFactory;
import javax.xml.crypto.dsig.XMLSignatureException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

public class MissingSAMLSignatureCheckTest {
    private <T> T unmarshallFromDocument(Document document, Class<T> type) throws Exception {
        try {
            JAXBContext context = JAXBContext.newInstance(type);
            Unmarshaller unmarshaller = context.createUnmarshaller();
            JAXBElement<T> element = unmarshaller.unmarshal(document, type);
            return element.getValue();
        } catch (Exception e) {
            throw new Exception("Unable to unmarshall SAML response", e);
        }
    }

    private void verifySignature1(Document document, Key key) throws Exception {
        NodeList nl = document.getElementsByTagNameNS(XMLSignature.XMLNS, "Signature");
        // skip signature validation if there is no signature node.
        if (nl.getLength() == 0) {
            return;
        }

        for (int i = 0; i < nl.getLength(); i++) {
            DOMValidateContext validateContext = new DOMValidateContext(key, nl.item(i));
            XMLSignatureFactory factory = XMLSignatureFactory.getInstance("DOM");
            try {
                XMLSignature signature = factory.unmarshalXMLSignature(validateContext);
                boolean valid = signature.validate(validateContext);
                if (!valid) {
                    throw new Exception("Invalid SAML v2.0 authentication response. The signature is invalid.");
                }
            } catch (MarshalException e) {
                throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response because we couldn't unmarshall the XML Signature element", e);
            } catch (XMLSignatureException e) {
                throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response. The signature was unmarshalled we couldn't validate it for an unknown reason", e);
            }
        }
    }

    // BAD: allow SAMLv2 assertion with signature check skipped.
    public void parseResponse1(String encodedResponse, PublicKey key) throws Exception {
        byte[] decodedResponse = Base64.getDecoder().decode(encodedResponse);

        Document document = null;
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        documentBuilderFactory.setNamespaceAware(true);
        try {
            DocumentBuilder builder = documentBuilderFactory.newDocumentBuilder();
            document = builder.parse(new ByteArrayInputStream(decodedResponse));
        } catch (Exception e) {
            throw new Exception("Unable to parse SAML v2.0 authentication response", e);
        }

        verifySignature1(document, key);
    
        ResponseType jaxbResponse = unmarshallFromDocument(document, ResponseType.class);
        List<Object> assertions = jaxbResponse.getAssertionOrEncryptedAssertion();
    }

    // BAD: does not validate signature of SAMLv2 assertion.
    public void parseResponse2(String encodedResponse, PublicKey key) throws Exception {
        byte[] decodedResponse = Base64.getDecoder().decode(encodedResponse);

        Document document = null;
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        documentBuilderFactory.setNamespaceAware(true);
        try {
            DocumentBuilder builder = documentBuilderFactory.newDocumentBuilder();
            document = builder.parse(new ByteArrayInputStream(decodedResponse));
        } catch (Exception e) {
            throw new Exception("Unable to parse SAML v2.0 authentication response", e);
        }

        ResponseType jaxbResponse = unmarshallFromDocument(document, ResponseType.class);
        List<Object> assertions = jaxbResponse.getAssertionOrEncryptedAssertion();
    }

    private void verifySignature2(Document document, Key key) throws Exception {
        NodeList nl = document.getElementsByTagNameNS("http://www.w3.org/2000/09/xmldsig#", "Signature");
        if (nl.getLength() == 0) {
            throw new Exception("Invalid SAML v2.0 operation. The signature is missing from the XML but is required.");
        }

        for (int i = 0; i < nl.getLength(); i++) {
            DOMValidateContext validateContext = new DOMValidateContext(key, nl.item(i));
            XMLSignatureFactory factory = XMLSignatureFactory.getInstance("DOM");
            try {
                XMLSignature signature = factory.unmarshalXMLSignature(validateContext);
                boolean valid = signature.validate(validateContext);
                // throw an exception if the signature is not valid.
                if (!valid) {
                    throw new Exception("Invalid SAML v2.0 authentication response. The signature is invalid.");
                }
            } catch (MarshalException e) {
                throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response because we couldn't unmarshall the XML Signature element", e);
            } catch (XMLSignatureException e) {
                throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response. The signature was unmarshalled we couldn't validate it for an unknown reason", e);
            }
        }
    }

    // GOOD: handle SAMLv2 assertion with proper signature verification.
    public void parseResponse3(String encodedResponse, PublicKey key) throws Exception {
        byte[] decodedResponse = Base64.getDecoder().decode(encodedResponse);

        Document document = null;
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        documentBuilderFactory.setNamespaceAware(true);
        try {
            DocumentBuilder builder = documentBuilderFactory.newDocumentBuilder();
            document = builder.parse(new ByteArrayInputStream(decodedResponse));
        } catch (Exception e) {
            throw new Exception("Unable to parse SAML v2.0 authentication response", e);
        }

        verifySignature2(document, key);

        ResponseType jaxbResponse = unmarshallFromDocument(document, ResponseType.class);
        List<Object> assertions = jaxbResponse.getAssertionOrEncryptedAssertion();
    }

    private boolean hasValidSignature(Document document, Key key) throws Exception {
        boolean hasValidSignature = false;

        NodeList nl = document.getElementsByTagNameNS("http://www.w3.org/2000/09/xmldsig#", "Signature");
        for (int i = 0; i < nl.getLength(); i++) {
            DOMValidateContext validateContext = new DOMValidateContext(key, nl.item(i));
            XMLSignatureFactory factory = XMLSignatureFactory.getInstance("DOM");
            try {
                XMLSignature signature = factory.unmarshalXMLSignature(validateContext);
                hasValidSignature = signature.validate(validateContext);
                // verification fails as long as one signature is invalid.
                if (!hasValidSignature) {
                    break;
                }
            } catch (MarshalException e) {
                throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response because we couldn't unmarshall the XML Signature element", e);
            } catch (XMLSignatureException e) {
                throw new Exception("Unable to verify XML signature in the SAML v2.0 authentication response. The signature was unmarshalled we couldn't validate it for an unknown reason", e);
            }
        }

        return hasValidSignature;
    }

    // GOOD: handle SAMLv2 assertion with proper signature verification.
    public void parseResponse4(String encodedResponse, PublicKey key) throws Exception {
        byte[] decodedResponse = Base64.getDecoder().decode(encodedResponse);

        Document document = null;
        DocumentBuilderFactory documentBuilderFactory = DocumentBuilderFactory.newInstance();
        documentBuilderFactory.setNamespaceAware(true);
        try {
            DocumentBuilder builder = documentBuilderFactory.newDocumentBuilder();
            document = builder.parse(new ByteArrayInputStream(decodedResponse));
        } catch (Exception e) {
            throw new Exception("Unable to parse SAML v2.0 authentication response", e);
        }

        if (hasValidSignature(document, key)) {
            ResponseType jaxbResponse = unmarshallFromDocument(document, ResponseType.class);
            List<Object> assertions = jaxbResponse.getAssertionOrEncryptedAssertion();
        }
    }
}
