function A() {}
function B(x) {}
function C(x, y) {}
var f = function() {};
!function(x) {};
(function(x, y) {});
var g = function h() {};

function k(arguments) {}
function l() { var arguments; }
function m() { { var arguments; } }
function n() { try { } catch(arguments) {} }

function p() { return arguments[0]; }