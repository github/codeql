import * as fb from 'firebase/app';
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

fb.database().ref('x').once('value', x => { // $firebaseSnapshot $firebaseRef
  x.val(); // $firebaseVal
  x.ref.parent; // $firebaseRef
}); // $firebaseRef $firebaseSnapshot

admin.database().ref('x').once('value', x => { // $firebaseSnapshot $firebaseRef
  x.val(); // $firebaseVal
  x.ref.parent; // $firebaseRef
}); // $firebaseRef $firebaseSnapshot

functions.database.ref('x').onCreate(x => {// $firebaseSnapshot $firebaseRef
  x.val(); // $firebaseVal
  x.ref.parent; // $firebaseRef
});

functions.database.ref('x').onUpdate(x => { // $firebaseSnapshot $firebaseRef
  x.before.val(); // $firebaseRef $firebaseSnapshot $firebaseVal
  x.after.val(); // $firebaseRef $firebaseSnapshot $firebaseVal
  x.ref.parent; // $firebaseRef
});

class FirebaseWrapper {
  constructor(firebase) {
    this.firebase = firebase;
  }

  getRef(x) {
    return this.firebase.database().ref(x); // $firebaseRef
  }
}

class FirebaseWrapper2 {
  constructor() {
    this.init();
  }

  init() {
    this.firebase = fb.initializeApp();
  }

  getRef(x) {
    return this.firebase.database().ref(x); // $firebaseRef
  }

  getNewsItem(x) {
    return this.getRef(x).child(x).once('value'); // $firebaseRef $firebaseSnapshot
  }

  adjustValue(fn) {
    this.firebase.database().ref('x').transaction(fn); // $firebaseRef
  }
}

new FirebaseWrapper(firebase.initializeApp()).getRef('/news');
new FirebaseWrapper2().getRef('/news');
new FirebaseWrapper2().getNewsItem('x');
new FirebaseWrapper2().adjustValue(x => x + 1); // $firebaseSnapshot $firebaseVal

class Box {
  constructor(x) {
    this.x = x;
  }
}
let box1 = new Box(fb.database());
let box2 = new Box(whatever());
box2.x.ref(); // not a firebase ref

functions.https.onRequest((req, res) => { res.send(req.params.foo); }); // $routeHandler $requestInputAccess $responseSendArgument
