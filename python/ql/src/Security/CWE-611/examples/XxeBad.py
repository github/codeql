from flask import Flask, request
import lxml.etree

app = Flask(__name__)

@app.post("/upload")
def upload():
    xml_src = request.get_data()
    doc = lxml.etree.fromstring(xml_src)
    return lxml.etree.tostring(doc)
