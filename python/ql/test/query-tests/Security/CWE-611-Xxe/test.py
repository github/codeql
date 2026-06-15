from flask import Flask, request
import lxml.etree
import markupsafe

app = Flask(__name__)

@app.route("/vuln-handler")
def vuln_handler():
    xml_content = request.args['xml_content']
    return lxml.etree.fromstring(xml_content).text

@app.route("/safe-handler")
def safe_handler():
    xml_content = request.args['xml_content']
    parser = lxml.etree.XMLParser(resolve_entities=False)
    return lxml.etree.fromstring(xml_content, parser=parser).text

@app.route("/super-vuln-handler")
def super_vuln_handler():
    xml_content = request.args['xml_content']
    parser = lxml.etree.XMLParser(
        # allows XXE
        resolve_entities=True,
        # allows remote XXE
        no_network=False,
        # together with `no_network=False`, allows DTD-retrival
        load_dtd=True,
        # allows DoS attacks
        huge_tree=True,
    )
    return lxml.etree.fromstring(xml_content, parser=parser).text

@app.route("/sanitized-handler")
def sanitized_handler():
    xml_content = request.args['xml_content']
    xml_content = markupsafe.escape(xml_content)
    return lxml.etree.fromstring(xml_content).text