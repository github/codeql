from flask import Flask, request
import lxml.etree

app = Flask(__name__)

@app.post("/upload")
def upload():
    xml_src = request.get_data()
    parser = lxml.etree.XMLParser(resolve_entities=False)
    doc = lxml.etree.fromstring(xml_src, parser=parser)
    return lxml.etree.tostring(doc)
