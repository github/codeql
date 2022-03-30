package org.apache.commons.digester3;

import java.io.File;
import org.xml.sax.InputSource;
import java.io.Reader;
import java.net.URL;
import java.io.InputStream;
import java.io.IOException;
import org.xml.sax.SAXException;
import javax.xml.parsers.SAXParser;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.DefaultHandler;
import javax.xml.parsers.ParserConfigurationException;
import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;

public class Digester extends DefaultHandler {

	public Digester() { }

    public Digester(SAXParser parser) { }

    public Digester(XMLReader reader) { }

    public <T> T parse(InputStream input) throws IOException, SAXException {
        return null;
    }

    public <T> T parse(File file) throws IOException, SAXException {
        return null;
    }

    public <T> T parse(InputSource input) throws IOException, SAXException {
        return null;
    }

    public <T> T parse(Reader reader) throws IOException, SAXException {
        return null;
    }

    public <T> T parse(String uri) throws IOException, SAXException {
        return null;
    }

    public <T> T parse(URL url) throws IOException, SAXException {
        return null;
    }

    public void setFeature(String feature, boolean value) throws ParserConfigurationException, SAXNotRecognizedException, SAXNotSupportedException { }
}