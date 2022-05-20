// library/common functions for rule CWE-611

#define NULL (0)

class SecurityManager;
class InputSource;

class AbstractDOMParser {
public:
	AbstractDOMParser();

	void setDisableDefaultEntityResolution(bool); // default is false
	void setCreateEntityReferenceNodes(bool); // default is true
	void setSecurityManager(SecurityManager *const manager);
	void parse(const InputSource &data);
};

typedef unsigned int XMLCh;

class XMLUni
{
public:
	static const XMLCh fgXercesDisableDefaultEntityResolution[];
	static const XMLCh fgXercesHarmlessOption[];
};

