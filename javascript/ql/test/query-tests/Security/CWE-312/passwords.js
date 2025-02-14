(function() {
    console.log(password); // NOT OK
    console.log(o.password); // NOT OK
    console.log(getPassword()); // NOT OK
    console.log(o.getPassword()); // NOT OK

    function myLog(x) {
        console.log(x); // NOT OK
    }
    myLog(password);

    console.info(password); // NOT OK

    console.log(name + ", " + password); // NOT OK

    console.log(`${name}, ${password}`); // NOT OK

    var obj1 = {
        password: x
    };
    console.log(obj1); // NOT OK

    var obj2 = {
        x: password
    };
    console.log(obj2); // NOT OK

    var obj3 = {};
    console.log(obj3); // OK
    obj3.x = password;

    var fixed_password = "123";
    console.log(fixed_password); // OK

    console.log(messages.IncorrectPasswordError); // OK

    console.log(this.hashed_password); // OK
    console.log(login.wrappedJSObject.encryptedPassword); // OK
    console.log(HTML5QQ.encodedPassword); // OK

    console.log({password: crypt(pw)}); // OK
    var actually_secure_password = crypt(password); // OK
    console.log(actually_secure_password); // OK

    var user1 = {};
    user1.crypted_password = x();
    console.log(user1); // OK

    var user2 = {};
    user2.password = hash();
    console.log(user2); // OK

    var user3 = {
        password: encryptLib.encryptPassword(req.body.password)
    };
    console.log(user3); // OK

    var actually_ok_password_1 = hashed1();
    console.log(actually_ok_password_1);
    var hashed2 = actually_ok_password_2();
    console.log(hashed2); // OK

    console.log(this._passwordMD5); // OK
    console.log(this._password_sha); // OK

    var utilityObject = {
        passwordSet: function(){}
    }
    console.log(utilityObject); // OK

    var displayedPassword = password? null: "(hidden)";
    var config = {
        password: displayedPassword
    };
    console.log(config); // OK

    var temp = { encryptedPassword: req.body.password };
    console.log(temp.encryptedPassword); // OK XXX

    var secret = password;
    console.log(`pw: ${secret}`); // NOT OK

    function redact(kind, value) {
        if (value && kind == 'password') {
            return "********"
        }
        return value;
    }

    console.log("Password is: " + redact('password', password));

    if (environment.isTestEnv()) {
        console.log("Password is: " + password); // OK, but still flagged [INCONSISTENCY]
    }

    if (environment.is(TEST)) {
        // NB: for security reasons, we only log passwords in test environments
        console.log("Password is: " + password); // OK, but still flagged [INCONSISTENCY]
    }


    if (x.test(y)) {
        f();
        // ...
        console.log("Password is: " + password); // NOT OK
        // ...
    }

    if (environment.isTestEnv())
        console.log("Password is: " + password); // OK, but still flagged [INCONSISTENCY]

    if (x.test(y)) {
        if (f()) {
            console.log("Password is: " + password); // NOT OK
        }
    }

    if (!environment.isProduction()) {
        console.log("Password is: " + password); // OK, but still flagged [INCONSISTENCY]
    }

    console.log(name + ", " + password.toString()); // NOT OK
    console.log(name + ", " + password.valueOf()); // NOT OK
});

(function() {
    var config = {
        password: x,
        hostname: "tarski",
        x: password,
        y: getPassword()
    };
    var cfg = x? config: config;
    console.log(config.hostname); // OK
    console.log(config); // NOT OK
    console.log(config.x); // NOT OK
    console.log(config.y); // NOT OK
    console.log(config[x]); // OK (probably)
});

function indirectLogCall() {
	console.log.apply(this, arguments);
}
var Util = require('util');
(function() {
    var config = {
        x: password
    };
    indirectLogCall(config.x); // NOT OK
    indirectLogCall(process.env); // NOT OK

    var procdesc = Util.inspect(process.env).replace(/\n/g, '')

    indirectLogCall(procdesc); // NOT OK

    console.log(process.env); // NOT OK
    console.log(process.env.PATH); // OK.
    console.log(process.env["foo" + "bar"]); // OK.
});

(function () {
	console.log(password.replace(/./g, "*")); // OK!
	console.log(password.replace(/\./g, "*")); // NOT OK!
	console.log(password.replace(/foo/g, "*")); // NOT OK!
})();

const debug = require('debug')('test');
(function () {
    console.log(password.replace(/foo/g, "*")); // NOT OK
    debug(password.replace(/foo/g, "*")); // NOT OK

    const myPassword = foo();
    console.log(myPassword); // NOT OK

    const myPasscode = foo();
    console.log(myPasscode); // NOT OK
});

(function () {
    console.log(password.replace(/./g, "*")); // OK
	console.log(password.replace(new RegExp(".", "g"), "*")); // OK
	console.log(password.replace(new RegExp("."), "*")); // NOT OK
	console.log(password.replace(new RegExp(".", unknownFlags()), "*")); // OK -- Most likely not a problem.
    console.log(password.replace(new RegExp("pre_._suf", "g"), "*")); // OK
})();

(function () {
  console.log(JSON.stringify(process.env)); // NOT OK
  console.log(process.env.PATH); // OK.
});
