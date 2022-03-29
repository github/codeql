import xmltodict

x = "some xml"

xmltodict.parse(x) # $ decodeFormat=XML decodeInput=x decodeOutput=xmltodict.parse(..)
xmltodict.parse(xml_input=x) # $ decodeFormat=XML decodeInput=x decodeOutput=xmltodict.parse(..)

xmltodict.parse(x, disable_entities=False) # $ decodeFormat=XML decodeInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup' decodeOutput=xmltodict.parse(..)
