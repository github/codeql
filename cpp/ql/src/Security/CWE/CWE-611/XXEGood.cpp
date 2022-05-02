
XercesDOMParser *parser = new XercesDOMParser();

parser->setDisableDefaultEntityResolution(true);
parser->parse(data);
