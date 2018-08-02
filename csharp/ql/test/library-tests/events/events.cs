using System;
using System.IO;
using System.Collections.Generic;

namespace Events
{
    public delegate void EventHandler(object sender, object e);


    public class Button
    {

        public event EventHandler Click;

        protected void OnClick(object e)
        {
            if (Click != null)
                Click(this, e);
        }

        public void Reset()
        {
            Click = null;
        }
    }

    public class LoginDialog
    {

        Button OkButton;
        Button CancelButton;

        public LoginDialog()
        {
            OkButton = new Button();
            OkButton.Click += new EventHandler(OkButtonClick);
            CancelButton = new Button();
            CancelButton.Click -= new EventHandler(CancelButtonClick);
        }

        void OkButtonClick(object sender, object e)
        { // Handle OkButton.Click event
        }

        void CancelButtonClick(object sender, object e)
        { // Handle CancelButton.Click event
        }

    }

    class Control
    {
        // Unique keys for events
        static readonly object mouseDownEventKey = new object();
        static readonly object mouseUpEventKey = new object();

        // Return event handler associated with key
        protected Delegate GetEventHandler(object key) { return null; }

        // Add event handler associated with key
        protected void AddEventHandler(object key, Delegate handler) { }

        // Remove event handler associated with key
        protected void RemoveEventHandler(object key, Delegate handler) { }

        // MouseDown event
        public event EventHandler MouseDown
        {
            add { AddEventHandler(mouseDownEventKey, value); }
            remove { RemoveEventHandler(mouseDownEventKey, value); }
        }

        // MouseUp event
        public event EventHandler MouseUp
        {
            add { AddEventHandler(mouseUpEventKey, value); }
            remove { RemoveEventHandler(mouseUpEventKey, value); }
        }

        // Invoke the MouseUp event
        protected void OnMouseUp(object args)
        {
            EventHandler handler;
            handler = (EventHandler)GetEventHandler(mouseUpEventKey);
            if (handler != null)
                handler(this, args);
        }
    }

}
