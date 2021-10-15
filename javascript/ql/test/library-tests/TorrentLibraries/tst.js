const parseTorrent = require('parse-torrent');

(function(){
	let parsed = parseTorrent();

	parsed.name;
	parsed.length;
	parsed.pieceLength;

	let indirection1 = {
		parsed: parsed
	};

	indirection1.parsed.name;
	indirection2(parsed);

});

function indirection2(t) {
	t.name;
}
