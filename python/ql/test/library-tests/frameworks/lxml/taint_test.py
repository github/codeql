import lxml.etree as ET
import io
import typing

def ensure_tainted(*args):
    print("ensure_tainted: ", *args)

TAINTED_STRING = "<a><b></b><c></c></a>"
src = TAINTED_STRING

def test():
    ensure_tainted(
        src, # $ tainted
        ET.fromstring(src),  # $ tainted decodeFormat=XML decodeInput=src xmlVuln='XXE' decodeOutput=ET.fromstring(..)
        ET.XML(src),  # $ tainted decodeFormat=XML decodeInput=src xmlVuln='XXE' decodeOutput=ET.XML(..)
        ET.HTML(src),  # $ tainted decodeFormat=XML decodeInput=src decodeOutput=ET.HTML(..)
        ET.fromstringlist([src]),  # $ tainted decodeFormat=XML decodeInput=List xmlVuln='XXE' decodeOutput=ET.fromstringlist(..)
        ET.XMLID(src),  # $ tainted decodeFormat=XML decodeInput=src xmlVuln='XXE' decodeOutput=ET.XMLID(..)
        ET.XMLDTDID(src),  # $ tainted decodeFormat=XML decodeInput=src xmlVuln='XXE' decodeOutput=ET.XMLDTDID(..)
    )


    parser = ET.XMLParser()
    parser.feed(src) # $ decodeFormat=XML decodeInput=src xmlVuln='XXE'
    ensure_tainted(parser.close()),  # $ tainted decodeOutput=parser.close()

    parser2 = ET.get_default_parser()
    parser2.feed(data=src) # $ decodeFormat=XML decodeInput=src xmlVuln='XXE'
    ensure_tainted(parser2.close()),  # $ tainted decodeOutput=parser2.close()

    elem = ET.XML(src) # $ decodeFormat=XML decodeInput=src xmlVuln='XXE' decodeOutput=ET.XML(..)
    ensure_tainted(
        elem,  # $ tainted
        ET.tostring(elem),  # $ tainted encodeFormat=XML encodeInput=elem encodeOutput=ET.tostring(..)
        ET.tostringlist(elem),  # $ tainted encodeFormat=XML encodeInput=elem encodeOutput=ET.tostringlist(..)
        ET.tounicode(elem), # $ tainted encodeFormat=XML encodeInput=elem encodeOutput=ET.tounicode(..)
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
        elem.findall("b")[0].text,   # $ tainted 
        list(elem.findall("b"))[0].text,  # $ MISSING:tainted # Type tracking is not followed through call to `list`, 
        elem.get("at"),  # $ tainted
        elem.getchildren()[0].text,  # $ tainted
        elem.getiterator(),  # $ tainted
        next(elem.getiterator()).text,  # $ MISSING:tainted
        elem[0].getnext().text,  # $ tainted
        elem[0].getparent().text,  # $ tainted
        elem[1].getprevious().text,  # $ tainted
        elem.getroottree(),  # $ tainted
        elem.getroottree().getroot().text,  # $ tainted
        elem.items(),  # $ tainted
        elem.iter(),  # $ tainted
        next(elem.iter()).text,  # $ MISSING:tainted
        elem.iterancestors(),  # $ tainted
        next(elem[0].iterancestors()).text,  # $ MISSING:tainted
        elem.iterchildren(),  # $ tainted
        next(elem.iterchildren()).text, # $ MISSING:tainted
        elem.iterdescendants(),  # $ tainted
        next(elem.iterdescendants()).text,  # $ MISSING:tainted
        elem.iterfind("b"),  # $ tainted
        next(elem.iterfind("b")).text,  # $ MISSING:tainted
        elem[0].itersiblings(),  # $ tainted
        next(elem[0].itersiblings()).text,  # $ MISSING:tainted
        elem.itertext(),  # $ tainted
        elem.keys(),  # $ tainted
        elem.values(),  # $ tainted
        elem.xpath("b")[0].text,  # $ tainted getXPath="b"
    )

    for ch in elem:
        ensure_tainted(
            ch,  # $ tainted
            ch.text  # $ MISSING: tainted # API node getASubscript() appears to not consider things like for loops 
        )

    buf = io.StringIO(src)
    tree = ET.parse(buf) # $ decodeFormat=XML decodeInput=buf xmlVuln='XXE' decodeOutput=ET.parse(..) SPURIOUS:getAPathArgument=buf # Spurious as this is used as a file-like object, not a path 
    ensure_tainted(
        tree,  # $ tainted
        tree.getroot().text,  # $ tainted
        tree.find("b").text,  # $ tainted
        tree.findall("b")[0].text,  # $ tainted
        tree.getiterator(),  # $ tainted
        next(tree.getiterator()).text,  # $ MISSING:tainted
        tree.iter(),  # $ tainted
        next(tree.iter()).text,  # $ MISSING:tainted
        tree.iterfind("b"),  # $ tainted
        next(tree.iterfind("b")).text,  # $ MISSING:tainted
        tree.xpath("b")[0].text,  # $ tainted getXPath="b"
    )

    (elem2, ids) = ET.XMLID(src) # $ decodeFormat=XML decodeInput=src xmlVuln='XXE' decodeOutput=ET.XMLID(..)
    (elem3, ids2) = ET.XMLDTDID(src) # $ decodeFormat=XML decodeInput=src xmlVuln='XXE' decodeOutput=ET.XMLDTDID(..)

    ensure_tainted(
        elem2,  # $ tainted
        elem3,  # $ tainted
        ids,  # $ tainted
        ids2,  # $ tainted
        elem2.text,  # $ MISSING:tainted # Type is not tracked to the tuple return value
        elem3.text,  # $ MISSING:tainted
    )

    buf = io.StringIO(src)
    (tree2,ids3) = ET.parseid(buf)  # $ decodeFormat=XML decodeInput=buf xmlVuln='XXE' decodeOutput=ET.parseid(..) SPURIOUS:getAPathArgument=buf

    ensure_tainted(
        tree2, # $ tainted
        ids3, # $ tainted
        tree2.getroot() # $ MISSING:tainted
    )

    buf = io.BytesIO(bytes(src, "utf8"))
    for ev, el in ET.iterparse(buf):  # $ decodeFormat=XML decodeInput=buf xmlVuln='XXE' decodeOutput=ET.iterparse(..) SPURIOUS:getAPathArgument=buf
        ensure_tainted(
            el, # $ tainted
            el.text, # $ MISSING:tainted
        )

    def func(tree_arg: ET.ElementTree):
        ensure_tainted(
            tree_arg, # $ tainted
            tree_arg.getroot().text # $ tainted # Type tracking from the type hint
        )

    func(tree2)

    def func2(x):
        return x 

    def func3(x) -> ET.ElementTree:
        return x

    ensure_tainted(
        func2(tree), # $ tainted
        func2(tree).getroot().text, # $ MISSING:tainted - type tracking not tracked through flow preserving calls
        func3(tree).getroot().text, # $ MISSING:tainted - this includes if there is a type hint annotation on the return
        typing.cast(ET.ElementTree, tree), # $ tainted
        typing.cast(ET.ElementTree, tree).getroot().text, # $ MISSING:tainted - this includes for flow summary models

    )
    

test()