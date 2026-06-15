from genshi.template.text import TextTemplate, NewTextTemplate, OldTextTemplate
from genshi.template.markup import MarkupTemplate

def test():
    a = TextTemplate("abc") # $ templateConstruction="abc"
    a = OldTextTemplate("abc") # $ templateConstruction="abc"
    a = NewTextTemplate("abc") # $ templateConstruction="abc"
    a = MarkupTemplate("abc") # $ templateConstruction="abc"
    return a