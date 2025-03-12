const parseTorrent = require('parse-torrent'),
      express = require('express');

express().get('/user/:id', function(req, res) {
	let torrent = parseTorrent(unknown),
	    name = torrent.name; // $ Source
	res.send(name); // $ Alert
});
