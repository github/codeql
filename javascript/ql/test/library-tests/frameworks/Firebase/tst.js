import * as fb from 'firebase/app';
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

fb.database().ref('x').once('value', x => {
  x.val();
  x.ref.parent;
});

admin.database().ref('x').once('value', x => {
  x.val();
  x.ref.parent;
});

functions.database.ref('x').onCreate(x => {
  x.val();
  x.ref.parent;
});

functions.database.ref('x').onUpdate(x => {
  x.before.val();
  x.after.val();
  x.ref.parent;
});

class FirebaseWrapper {
  constructor(firebase) {
    this.firebase = firebase;
  }

  getRef(x) {
    return this.firebase.database().ref(x);
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
    return this.firebase.database().ref(x);
  }

  getNewsItem(x) {
    return this.getRef(x).child(x).once('value');
  }

  adjustValue(fn) {
    this.firebase.database().ref('x').transaction(fn);
  }
}

new FirebaseWrapper(firebase.initializeApp()).getRef('/news');
new FirebaseWrapper2().getRef('/news');
new FirebaseWrapper2().getNewsItem('x');
new FirebaseWrapper2().adjustValue(x => x + 1);

class Box {
  constructor(x) {
    this.x = x;
  }
}
let box1 = new Box(fb.database());
let box2 = new Box(whatever());
box2.x.ref(); // not a firebase ref

functions.https.onRequest((req, res) => { res.send(req.params.foo); });
