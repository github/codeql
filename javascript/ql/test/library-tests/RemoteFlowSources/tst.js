window.user.name;        // RemoteFlowSource: user input
window.user.address;     // RemoteFlowSource: user input
window.dob;              // RemoteFlowSource: user input
window.upload;           // RemoteFlowSource: uncontrolled path

this.user.name;          // RemoteFlowSource: user input
this.user.address;       // RemoteFlowSource: user input
this.dob;                // RemoteFlowSource: user input
this.upload;             // RemoteFlowSource: uncontrolled path

user.name;               // RemoteFlowSource: user input
user.address;            // RemoteFlowSource: user input
dob;                     // RemoteFlowSource: user input
upload;                  // RemoteFlowSource: uncontrolled path

(function (global) {
    global.user.name;    // RemoteFlowSource: user input
    global.user.address; // RemoteFlowSource: user input
    global.dob;          // RemoteFlowSource: user input
    global.upload;       // RemoteFlowSource: uncontrolled path
})(this);
