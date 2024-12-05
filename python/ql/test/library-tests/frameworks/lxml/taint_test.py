import lxml.etree as ET

def ensure_tainted(*args):
    pass 

TAINTED_STRING = "<a><b></b></a>"
src = TAINTED_STRING

def test():
    ensure_tainted(
        src, # $ tainted
        ET.fromstring(src),  # $ tainted
        ET.XML(src),  # $ tainted
        ET.HTML(src),  # $ tainted
        ET.fromstringlist([src]),  # $ tainted
        ET.XMLID(src),  # $ tainted
        ET.XMLDTD(src),  # $ tainted
    )


    parser = ET.XmlParser()
    parser.feed(src)
    ensure_tainted(parser.close()),  # $ tainted

    parser2 = ET.get_default_parser()
    parser.feed(data=src)
    ensure_tainted(parser2.close()),  # $ tainted

    elem = ET.XML(src)
    ensure_tainted(
        elem,  # $ tainted
        ET.tostring(elem),  # $ tainted
        ET.tostringlist(elem),  # $ tainted
        elem.attrib,  # $ tainted
        elem.base,  # $ tainted
        elem.nsmap,  # $ tainted
        elem.prefix,  # $ tainted
        elem.tag,  # $ tainted
        elem.tail,  # $ tainted
        elem.text,  # $ tainted
        elem[0],  # $ tainted
        elem[0].text,  # $ tainted
        elem.cssselect("b"),  # $ tainted
        elem.cssselect("b")[0].text,  # $ tainted
        elem.find("b").text,  # $ tainted
        elem.findall("b"),  # $ tainted
        list(elem.findall("b"))[0].text,  # $ tainted
        elem.get("at"),  # $ tainted
        elem.getchildren(),  # $ tainted
        list(elem.getchildren())[0].text,  # $ tainted,
        elem.getiterator(),  # $ tainted
        list(elem.getiterator())[0].text,  # $ tainted
        elem.getnext().text,  # $ tainted
        elem.getparent().text,  # $ tainted
        elem.getprevious().text,  # $ tainted
        elem.getroottree(),  # $ tainted
        elem.getroottree().getroot().text,  # $ tainted
        elem.items(),  # $ tainted
        list(elem.items())[0].text,  # $ tainted
        elem.iter(),  # $ tainted
        list(elem.iter())[0].text,  # $ tainted
        elem.iterancestors(),  # $ tainted
        list(elem.iterancestors())[0].text,  # $ tainted
        elem.iterchildren(), # $ tainted
        list(elem.iterchildren())[0].text,  # $ tainted
        elem.iterdecendants(),  # $ tainted
        list(elem.iterdecendants())[0].text,  # $ tainted
        elem.iterfind(),  # $ tainted
        list(elem.iterfind())[0].text,  # $ tainted
        elem.itersiblings(),  # $ tainted
        list(elem.itersiblings())[0].text,  # $ tainted
        elem.itertext(),  # $ tainted
        list(elem.itertext())[0].text,  # $ tainted
        elem.keys(),  # $ tainted
        elem.values(),  # $ tainted
        elem.xpath("b"),  # $ tainted
        list(elem.xpath("b"))[0].text,  # $ tainted
    )

    for ch in elem:
        ensure_tainted(
            ch,  # $ tainted
            ch.text  # $ tainted
        )

    tree = ET.parse(src)
    ensure_tainted(
        tree,  # $ tainted
        tree.getroot().text,  # $ tainted
        tree.find("a").text,  # $ tainted
        tree.findall("a"),  # $ tainted
        list(tree.findall("a"))[0].text,  # $ tainted
        tree.getiterator(),  # $ tainted
        list(tree.getiterator())[0].text,  # $ tainted
        tree.iter(),  # $ tainted
        list(tree.iter())[0].text,  # $ tainted
        tree.iterfind(),  # $ tainted
        list(tree.iterfind())[0].text,  # $ tainted
    )

    

test()