import javascript

query DataFlow::Node test_CheerioRef() { result = Cheerio::cheerioRef() }

query Cheerio::CheerioObjectCreation test_CheerioObjectCreation() { any() }

query DOM::AttributeDefinition test_AttributeDefinition() { any() }

query DataFlow::Node test_CheerioObjectRef() { result = Cheerio::cheerioObjectRef() }

query Cheerio::XssSink test_XssSink() { any() }
