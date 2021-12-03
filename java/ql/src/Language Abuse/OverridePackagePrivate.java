// File 1
package gui;

abstract class Widget
{
    // ...

    // Return the width (in pixels) of this widget
    int width() {
        // ...
    }

    // ...
}

// File 2
package gui.extras;

class PhotoResizerWidget extends Widget
{
    // ...
 
    // Return the new width (of the photo when resized)
    public int width() {
        // ...
    }
   
    // ...
}