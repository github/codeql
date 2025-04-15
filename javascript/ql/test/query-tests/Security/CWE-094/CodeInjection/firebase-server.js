const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

functions.database.ref('x').onCreate(x => {
    eval(x.val()); // $ Alert[js/code-injection]
    eval(x.exportVal()); // $ Alert[js/code-injection]
    x.ref.parent.once('value', parentSnapshot => {
        eval(parentSnapshot.val()); // $ Alert[js/code-injection]
    });
});
functions.database.ref('x').onUpdate(x => {
    eval(x.before.val()); // $ Alert[js/code-injection]
    eval(x.after.val()); // $ Alert[js/code-injection]
    x.ref.parent.parent.once('value', grandParentSnapshot => {
        eval(grandParentSnapshot.val()); // $ Alert[js/code-injection]
    });
});
