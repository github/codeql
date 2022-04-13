
XercesDOMParser *parser = new XercesDOMParser();

parser->parse(data); // BAD (parser is not correctly configured, may expand external entity references)
