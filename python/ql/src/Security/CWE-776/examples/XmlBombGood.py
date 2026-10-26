from flask import Flask, request
import defusedxml.ElementTree as ET

app = Flask(__name__)

@app.post("/upload")
def upload():
    xml_src = request.get_data()
    doc = ET.fromstring(xml_src)
    return ET.tostring(doc)
