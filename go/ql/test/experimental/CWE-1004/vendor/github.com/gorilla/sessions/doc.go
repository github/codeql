// Copyright 2012 The Gorilla Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/*
Package sessions provides cookie and filesystem sessions and
infrastructure for custom session backends.

The key features are:

	* Simple API: use it as an easy way to set signed (and optionally
	  encrypted) cookies.
	* Built-in backends to store sessions in cookies or the filesystem.
	* Flash messages: session values that last until read.
	* Convenient way to switch session persistency (aka "remember me") and set
	  other attributes.
	* Mechanism to rotate authentication and encryption keys.
	* Multiple sessions per request, even using different backends.
	* Interfaces and infrastructure for custom session backends: sessions from
	  different stores can be retrieved and batch-saved using a common API.

Let's start with an example that shows the sessions API in a nutshell:

	import (
		"net/http"
		"github.com/gorilla/sessions"
	)

	// Note: Don't store your key in your source code. Pass it via an
	// environmental variable, or flag (or both), and don't accidentally commit it
	// alongside your code. Ensure your key is sufficiently random - i.e. use Go's
	// crypto/rand or securecookie.GenerateRandomKey(32) and persist the result.
	// Ensure SESSION_KEY exists in the environment, or sessions will fail.
	var store = sessions.NewCookieStore([]byte(os.Getenv("SESSION_KEY")))

	func MyHandler(w http.ResponseWriter, r *http.Request) {
		// Get a session. Get() always returns a session, even if empty.
		session, err := store.Get(r, "session-name")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		// Set some session values.
		session.Values["foo"] = "bar"
		session.Values[42] = 43
		// Save it before we write to the response/return from the handler.
		err = session.Save(r, w)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

First we initialize a session store calling NewCookieStore() and passing a
secret key used to authenticate the session. Inside the handler, we call
store.Get() to retrieve an existing session or a new one. Then we set some
session values in session.Values, which is a map[interface{}]interface{}.
And finally we call session.Save() to save the session in the response.

Note that in production code, we should check for errors when calling
session.Save(r, w), and either display an error message or otherwise handle it.

Save must be called before writing to the response, otherwise the session
cookie will not be sent to the client.

That's all you need to know for the basic usage. Let's take a look at other
options, starting with flash messages.

Flash messages are session values that last until read. The term appeared with
Ruby On Rails a few years back. When we request a flash message, it is removed
from the session. To add a flash, call session.AddFlash(), and to get all
flashes, call session.Flashes(). Here is an example:

	func MyHandler(w http.ResponseWriter, r *http.Request) {
		// Get a session.
		session, err := store.Get(r, "session-name")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		// Get the previous flashes, if any.
		if flashes := session.Flashes(); len(flashes) > 0 {
			// Use the flash values.
		} else {
			// Set a new flash.
			session.AddFlash("Hello, flash messages world!")
		}
		err = session.Save(r, w)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

Flash messages are useful to set information to be read after a redirection,
like after form submissions.

There may also be cases where you want to store a complex datatype within a
session, such as a struct. Sessions are serialised using the encoding/gob package,
so it is easy to register new datatypes for storage in sessions:

	import(
		"encoding/gob"
		"github.com/gorilla/sessions"
	)

	type Person struct {
		FirstName	string
		LastName 	string
		Email		string
		Age			int
	}

	type M map[string]interface{}

	func init() {

		gob.Register(&Person{})
		gob.Register(&M{})
	}

As it's not possible to pass a raw type as a parameter to a function, gob.Register()
relies on us passing it a value of the desired type. In the example above we've passed
it a pointer to a struct and a pointer to a custom type representing a
map[string]interface. (We could have passed non-pointer values if we wished.) This will
then allow us to serialise/deserialise values of those types to and from our sessions.

Note that because session values are stored in a map[string]interface{}, there's
a need to type-assert data when retrieving it. We'll use the Person struct we registered above:

	func MyHandler(w http.ResponseWriter, r *http.Request) {
		session, err := store.Get(r, "session-name")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		// Retrieve our struct and type-assert it
		val := session.Values["person"]
		var person = &Person{}
		if person, ok := val.(*Person); !ok {
			// Handle the case that it's not an expected type
		}

		// Now we can use our person object
	}

By default, session cookies last for a month. This is probably too long for
some cases, but it is easy to change this and other attributes during
runtime. Sessions can be configured individually or the store can be
configured and then all sessions saved using it will use that configuration.
We access session.Options or store.Options to set a new configuration. The
fields are basically a subset of http.Cookie fields. Let's change the
maximum age of a session to one week:

	session.Options = &sessions.Options{
		Path:     "/",
		MaxAge:   86400 * 7,
		HttpOnly: true,
	}

Sometimes we may want to change authentication and/or encryption keys without
breaking existing sessions. The CookieStore supports key rotation, and to use
it you just need to set multiple authentication and encryption keys, in pairs,
to be tested in order:

	var store = sessions.NewCookieStore(
		[]byte("new-authentication-key"),
		[]byte("new-encryption-key"),
		[]byte("old-authentication-key"),
		[]byte("old-encryption-key"),
	)

New sessions will be saved using the first pair. Old sessions can still be
read because the first pair will fail, and the second will be tested. This
makes it easy to "rotate" secret keys and still be able to validate existing
sessions. Note: for all pairs the encryption key is optional; set it to nil
or omit it and and encryption won't be used.

Multiple sessions can be used in the same request, even with different
session backends. When this happens, calling Save() on each session
individually would be cumbersome, so we have a way to save all sessions
at once: it's sessions.Save(). Here's an example:

	var store = sessions.NewCookieStore([]byte("something-very-secret"))

	func MyHandler(w http.ResponseWriter, r *http.Request) {
		// Get a session and set a value.
		session1, _ := store.Get(r, "session-one")
		session1.Values["foo"] = "bar"
		// Get another session and set another value.
		session2, _ := store.Get(r, "session-two")
		session2.Values[42] = 43
		// Save all sessions.
		err = sessions.Save(r, w)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}

This is possible because when we call Get() from a session store, it adds the
session to a common registry. Save() uses it to save all registered sessions.
*/
package sessions
