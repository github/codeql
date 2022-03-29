import xmltodict

x = "some xml"

xmltodict.parse(x) # $ xmlInput=x
xmltodict.parse(xml_input=x) # $ xmlInput=x

xmltodict.parse(x, disable_entities=False) # $ xmlInput=x xmlVuln='Billion Laughs' xmlVuln='Quadratic Blowup'
