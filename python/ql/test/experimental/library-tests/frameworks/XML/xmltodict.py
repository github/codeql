import xmltodict

x = "some xml"

xmltodict.parse(x) # $ input=x
xmltodict.parse(xml_input=x) # $ input=x

xmltodict.parse(x, disable_entities=False) # $ input=x vuln='Billion Laughs' vuln='Quadratic Blowup'
