package xml

// EntitiesMap are all named character entities.
var EntitiesMap = map[string][]byte{
	"apos": []byte("'"),
	"gt":   []byte(">"),
	"quot": []byte("\""),
}

// TextRevEntitiesMap is a map of escapes.
var TextRevEntitiesMap = map[byte][]byte{
	'<': []byte("&lt;"),
	'&': []byte("&amp;"),
}
