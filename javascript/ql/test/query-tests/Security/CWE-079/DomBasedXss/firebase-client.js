import firebase from 'firebase/app';
import 'firebase/database';


firebase.database().ref("/userMessages/message1").once("value")
  .then((x) => {
    document.getElementById("messageDisplay").innerHTML = x.val(); // $ Alert
    document.getElementById("messageDisplay").innerHTML = x.exportVal().message; // $ Alert
    x.ref.parent.parent.once('value', parentSnapshot => {
        document.getElementById("messageDisplay").innerHTML = parentSnapshot.val(); // $ Alert
    });

    x.ref.parent.child('bio').once('value', (bioSnapshot) => {
      document.getElementById('userBio').innerHTML = bioSnapshot.val(); // $ Alert
    });

    x.forEach((childSnapshot) => {
      const data = childSnapshot.val(); // $ Source
      document.getElementById("userList").innerHTML += `<div>${data.username}</div>`; // $ Alert
    });
  })
  .catch();

firebase.database().ref('/users').on('value', (x) => {
    document.getElementById("messageDisplay").innerHTML = x.val(); // $ Alert
    document.getElementById("messageDisplay").innerHTML = x.exportVal().message; // $ Alert
    x.ref.parent.parent.once('value', parentSnapshot => {
        document.getElementById("messageDisplay").innerHTML = parentSnapshot.val(); // $ Alert
    });
});

firebase.database().refFromURL("https://example.com").once("value", (snapshot) => {
    document.getElementById("content").innerHTML = snapshot.val(); // $ Alert
});

firebase.database().ref("users").child("12345").once("value", (snapshot) => {
    const userData = snapshot.val(); // $ Source
    document.getElementById("userProfile").innerHTML = userData.bio; // $ Alert
});

firebase.database().ref("users/12345/profile").once("value", (snapshot) => {
    const rootref = snapshot.ref.root;
    rootref.once("value", (parentSnapshot) => {
      document.getElementById("userData").innerHTML = parentSnapshot.val(); // $ Alert
    });
});

function fun2(category){
    dbPath = 'users/' + firebase.auth().currentUser.uid;
    dbRef = firebase.database().ref(dbPath);
    dbRef.set({'test': randomString}).then(function() {return dbRef.once('value');}).then(function(snapshot) {
        document.getElementById("userData").innerHTML = snapshot.val(); // $ Alert
        return dbRef.remove();
    }); 
}
