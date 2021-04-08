from lxml import etree
from io import StringIO

from django.urls import path
from django.http import HttpResponse
from django.template import Template, Context, Engine, engines


def a(request):
    xslt_root = etree.XML('''\
        <xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
            <xsl:template match="/">
                <foo><xsl:value-of select="/a/b/text()" /></foo>
            </xsl:template>
        </xsl:stylesheet>''')
    transform = etree.XSLT(xslt_root)


def b(request):
    xslt_root = etree.XML('''\
        <xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
            <xsl:template match="/">
                <foo><xsl:value-of select="/a/b/text()" /></foo>
            </xsl:template>
        </xsl:stylesheet>''')
    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result_tree = tree.xslt(xslt_root)


def c(request):
    xslt_root = etree.XML('''\
        <xsl:stylesheet version="1.0"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
            <xsl:template match="/">
                <foo><xsl:value-of select="/a/b/text()" /></foo>
            </xsl:template>
        </xsl:stylesheet>''')

    f = StringIO('<foo><bar></bar></foo>')
    tree = etree.parse(f)
    result = tree.xslt(xslt_root, a="'A'")


urlpatterns = [
    path('a', a),
    path('b', b),
    path('c', c)
]

if __name__ == "__main__":
    a(None)
    b(None)
    c(None)
