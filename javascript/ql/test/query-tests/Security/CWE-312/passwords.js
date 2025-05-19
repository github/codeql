(function() {
    console.log(password); // $ Alert[js/clear-text-logging]
    console.log(o.password); // $ Alert[js/clear-text-logging]
    console.log(getPassword()); // $ Alert[js/clear-text-logging]
    console.log(o.getPassword()); // $ Alert[js/clear-text-logging]

    function myLog(x) {
        console.log(x); // $ Alert[js/clear-text-logging]
    }
    myLog(password); // $ Source[js/clear-text-logging]

    console.info(password); // $ Alert[js/clear-text-logging]

    console.log(name + ", " + password); // $ Alert[js/clear-text-logging]

    console.log(`${name}, ${password}`); // $ Alert[js/clear-text-logging]

    var obj1 = {
        password: x // $ Source[js/clear-text-logging]
    };
    console.log(obj1); // $ Alert[js/clear-text-logging]

    var obj2 = {
        x: password // $ Source[js/clear-text-logging]
    };
    console.log(obj2); // $ Alert[js/clear-text-logging]

    var obj3 = {};
    console.log(obj3);
    obj3.x = password;

    var fixed_password = "123";
    console.log(fixed_password);

    console.log(messages.IncorrectPasswordError);

    console.log(this.hashed_password);
    console.log(login.wrappedJSObject.encryptedPassword);
    console.log(HTML5QQ.encodedPassword);

    console.log({password: crypt(pw)});
    var actually_secure_password = crypt(password);
    console.log(actually_secure_password);

    var user1 = {};
    user1.crypted_password = x();
    console.log(user1);

    var user2 = {};
    user2.password = hash();
    console.log(user2);

    var user3 = {
        password: encryptLib.encryptPassword(req.body.password)
    };
    console.log(user3);

    var actually_ok_password_1 = hashed1();
    console.log(actually_ok_password_1);
    var hashed2 = actually_ok_password_2();
    console.log(hashed2);

    console.log(this._passwordMD5);
    console.log(this._password_sha);

    var utilityObject = {
        passwordSet: function(){}
    }
    console.log(utilityObject);

    var displayedPassword = password? null: "(hidden)";
    var config = {
        password: displayedPassword
    };
    console.log(config);

    var temp = { encryptedPassword: req.body.password }; // $ Source[js/clear-text-logging]
    console.log(temp.encryptedPassword); // $ SPURIOUS: Alert[js/clear-text-logging]

    var secret = password; // $ Source[js/clear-text-logging]
    console.log(`pw: ${secret}`); // $ Alert[js/clear-text-logging]

    function redact(kind, value) {
        if (value && kind == 'password') {
            return "********"
        }
        return value;
    }

    console.log("Password is: " + redact('password', password));

    if (environment.isTestEnv()) {
        console.log("Password is: " + password); // $ SPURIOUS: Alert[js/clear-text-logging]
    }

    if (environment.is(TEST)) {
        // NB: for security reasons, we only log passwords in test environments
        console.log("Password is: " + password); // $ SPURIOUS: Alert[js/clear-text-logging]
    }


    if (x.test(y)) {
        f();
        // ...
        console.log("Password is: " + password); // $ Alert[js/clear-text-logging]
        // ...
    }

    if (environment.isTestEnv())
        console.log("Password is: " + password); // $ SPURIOUS: Alert[js/clear-text-logging]

    if (x.test(y)) {
        if (f()) {
            console.log("Password is: " + password); // $ Alert[js/clear-text-logging]
        }
    }

    if (!environment.isProduction()) {
        console.log("Password is: " + password); // $ SPURIOUS: Alert[js/clear-text-logging]
    }

    console.log(name + ", " + password.toString()); // $ Alert[js/clear-text-logging]
    console.log(name + ", " + password.valueOf()); // $ Alert[js/clear-text-logging]
});

(function() {
    var config = {
        password: x, // $ Source[js/clear-text-logging]
        hostname: "tarski",
        x: password, // $ Source[js/clear-text-logging]
        y: getPassword() // $ Source[js/clear-text-logging]
    };
    var cfg = x? config: config;
    console.log(config.hostname);
    console.log(config); // $ Alert[js/clear-text-logging]
    console.log(config.x); // $ Alert[js/clear-text-logging]
    console.log(config.y); // $ Alert[js/clear-text-logging]
    console.log(config[x]); // OK - probably
});

function indirectLogCall() {
	console.log.apply(this, arguments); // $ Alert[js/clear-text-logging]
}
var Util = require('util');
(function() {
    var config = {
        x: password // $ Source[js/clear-text-logging]
    };
    indirectLogCall(config.x);
    indirectLogCall(process.env); // $ Source[js/clear-text-logging]

    var procdesc = Util.inspect(process.env).replace(/\n/g, '') // $ Source[js/clear-text-logging]

    indirectLogCall(procdesc);

    console.log(process.env); // $ Alert[js/clear-text-logging]
    console.log(process.env.PATH);
    console.log(process.env["foo" + "bar"]);
});

(function () {
	console.log(password.replace(/./g, "*"));
	console.log(password.replace(/\./g, "*")); // $ Alert[js/clear-text-logging]
	console.log(password.replace(/foo/g, "*")); // $ Alert[js/clear-text-logging]
})();

const debug = require('debug')('test');
(function () {
    console.log(password.replace(/foo/g, "*")); // $ Alert[js/clear-text-logging]
    debug(password.replace(/foo/g, "*")); // $ Alert[js/clear-text-logging]

    const myPassword = foo();
    console.log(myPassword); // $ Alert[js/clear-text-logging]

    const myPasscode = foo();
    console.log(myPasscode); // $ Alert[js/clear-text-logging]
});

(function () {
    console.log(password.replace(/./g, "*"));
	console.log(password.replace(new RegExp(".", "g"), "*"));
	console.log(password.replace(new RegExp("."), "*")); // $ Alert[js/clear-text-logging]
	console.log(password.replace(new RegExp(".", unknownFlags()), "*")); // OK - Most likely not a problem.
    console.log(password.replace(new RegExp("pre_._suf", "g"), "*"));
})();

(function () {
  console.log(JSON.stringify(process.env)); // $ Alert[js/clear-text-logging]
  console.log(process.env.PATH);
});
