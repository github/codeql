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
functions.database.ref('/messages/{messageId}').onWrite((change, context) => {
    eval(change.after.val()); // $ Alert[js/code-injection]
    eval(change.before.val()); // $ Alert[js/code-injection]
});

functions.database.ref('/messages/{messageId}').onDelete((change, context) => {
    eval(change.val()); // $ Alert[js/code-injection]
    eval(change.val()); // $ Alert[js/code-injection]
});

functions.database.ref('/status/{uid}').onUpdate(async (change, context) => {
    const eventStatus = change.after.val();
    const statusSnapshot = await change.after.ref.once('value');
    const status = eval(statusSnapshot.val()); // $ Alert[js/code-injection]
    return null;
});
  
function fun(category){
    let query = admin.database().ref(`/users/messages`);
    query = query.orderByChild('category').equalTo(category);
    const snapshot = query.once('value');
    let messages = [];
    snapshot.forEach((childSnapshot) => {
      messages.push({key: childSnapshot.key, message: childSnapshot.val().message});
      eval(childSnapshot.val()); // $ Alert[js/code-injection]
    });
}
  
async function fun3(uid, postId, size) {
    let app;
    const config = JSON.parse(process.env.FIREBASE_CONFIG);
    config.databaseAuthVariableOverride = {uid: uid};
    app = admin.initializeApp(config, uid);
    const imageUrlRef = app.database().ref(`/posts`);
    const snap = await imageUrlRef.once('value');
    eval(snap.val()); // $ Alert[js/code-injection]
}

exports.sendFollowerNotification = functions.database.ref('/followers/{followedUid}/{followerUid}').onWrite(async (change, context) => {
      const followerUid = context.params.followerUid;
      const followedUid = context.params.followedUid;
      const getDeviceTokensPromise = admin.database().ref(`/users/${followedUid}/notificationTokens`).once('value');

      const getFollowerProfilePromise = admin.auth().getUser(followerUid);

      const results = await Promise.all([getDeviceTokensPromise, getFollowerProfilePromise]);
      let tokensSnapshot = results[0];
      const follower = results[1];
      eval(tokensSnapshot.val()); // $ Alert[js/code-injection]
      let snap = await getDeviceTokensPromise;
      eval(snap.val()); // $ Alert[js/code-injection]
      return follower;
});
