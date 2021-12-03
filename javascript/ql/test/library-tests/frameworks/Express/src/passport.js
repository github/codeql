var express = require("express");
var passport = require('passport');
var twitter = require('passport-twitter');

passport.use(new twitter.Strategy({
	consumerKey : "foo",
	consumerSecret : "bar",
	callbackURL : "baz"
}, function(accessToken, refreshToken, profile, done) {
	accessToken.body; // Not tainted. No passReqToCallback flag.
}));

passport.use(new twitter.Strategy({
	consumerKey : "foo",
	consumerSecret : "bar",
	callbackURL : "baz",
	passReqToCallback : false
}, function(accessToken, refreshToken, profile, done) {
	accessToken.body; // Not tainted. No passReqToCallback set to false.
}));

passport.use(new twitter.Strategy({
	consumerKey : "foo",
	consumerSecret : "bar",
	callbackURL : "baz",
	passReqToCallback : true
}, function(req, accessToken, refreshToken, profile, done) {
	req.body; // `passReqToCallback` is `true`, so `req` is assumed to be an Express request object, causing this to be a `RequestInputAccss`
}));
