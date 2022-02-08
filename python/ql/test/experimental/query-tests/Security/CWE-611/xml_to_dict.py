from flask import request, Flask
from io import StringIO, BytesIO
import xmltodict

app = Flask(__name__)

@app.route("/xmltodict.parse")
def xmltodict_parse():
    xml_content = request.args['xml_content']

    return xmltodict.parse(xml_content)

@app.route("/xmltodict.parse2")
def xmltodict_parse2():
    xml_content = request.args['xml_content']

    return xmltodict.parse(xml_content, disable_entities=False)