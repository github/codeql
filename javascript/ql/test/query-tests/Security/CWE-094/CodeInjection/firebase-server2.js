function globalFirebaseUsage() {
  var usersRef = firebase.database().ref('users');
  usersRef.on('child_added', function(snapshot) {
    eval(snapshot.val()); // $ MISSING: Alert[js/code-injection]
    var followUserRef = firebase.database().ref('followers/' + uid + '/' + this.currentUid);

    followUserRef.on('value', function(followSnapshot) {
        eval(followSnapshot.val()); // $ MISSING: Alert[js/code-injection]
    });
  });
};
