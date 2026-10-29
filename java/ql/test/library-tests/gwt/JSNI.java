class JSNI {
    class Element {}

    // this is a JSNI comment
    public native void scrollTo1(Element elem) /*-{
        elem.scrollIntoView(true);
    }-*/;

    // this is not a JSNI comment: method is not declared `native`
    public void scrollTo2(Element elem) /*-{
        elem.scrollIntoView(true);
    }-*/ {}

    // this is not a JSNI comment: comment must be part of the method definition
    public native void scrollTo3(Element elem);
    /*-{
    elem.scrollIntoView(true);
    }-*/

    // this is not a JSNI comment: extra content
    public native void scrollTo4(Element elem) /* hi -{
        elem.scrollIntoView(true);
    }-*/;

    // this is not a JSNI comment: extra content
    public native void scrollTo5(Element elem) /* -{
        elem.scrollIntoView(true);
    }- ho*/;

    // this is not a JSNI comment: no closing delimiter
    public native void scrollTo6(Element elem) /*-{
        elem.scrollIntoView(true);
    }*/;
}