let MongoClient = require('mongodb').MongoClient;

function injectionExample(injectedInput) {
  // using mongodb v2.2 API (this is the version the NoSQL QL library is modelled on)
  MongoClient.connect("mongodb://someHost:somePort/", (err, db) => {
    if (err) throw err;
    // The intention of this is for injectedInput to be a string.  However, if it
    // is { "$ne": "not_the_password" } for example, the query will succeed without
    // the user knowing the password.
    db.collection("someCollection").find({ password: injectedInput }).toArray((err, result) => {
      if (err) throw err;
      console.log(result);
      client.close();
    });
  });
}

function getUserControlledData() {
  // The user controlled data must be an object.
  return JSON.parse(window.name);
}

function run() {
  injectionExample(getUserControlledData());
}

run();
