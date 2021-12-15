// External test case from SAMATE's Juliet Test Suite for C/C++
// (http://samate.nist.gov/SRD/testsuite.php)
// Associated with CWE-134: Uncontrolled format string. http://cwe.mitre.org/data/definitions/134.html
// This is a snippet with added declarations, not the entire test case.

typedef unsigned long size_t;

typedef void *va_list;
#define va_start(ap, parmN)
#define va_end(ap)
#define va_arg(ap, type) ((type)0)

int vsnprintf(char *s, size_t n, const char *format, va_list arg);

size_t strlen(const char *s);

#define SOCKET int
#define INVALID_SOCKET (0)
#define SOCKET_ERROR (1)
#define AF_INET (2)
#define SOCK_STREAM (3)
#define IPPROTO_TCP (4)
#define IP_ADDRESS (5)
#define TCP_PORT (6)
typedef int in_addr_t;
struct in_addr {
	in_addr_t s_addr;
};
struct sockaddr_in {
	int sin_family;
	int sin_port;
	struct in_addr sin_addr;
};
in_addr_t inet_addr(const char *cp);

#define IP_ADDRESS "0.0.0.0"

void printLine(char *);

static void badVaSink(char * data, ...)
{
    {
        char dest[100] = "";
        va_list args;
        va_start(args, data);
        /* POTENTIAL FLAW: Do not specify the format allowing a possible format string vulnerability */
        vsnprintf(dest, 100-1, data, args);
        va_end(args);
        printLine(dest);
    }
}

void CWE134_Uncontrolled_Format_String__char_connect_socket_w32_vsnprintf_01_bad()
{
    char * data;
    char dataBuffer[100] = "";
    data = dataBuffer;
    {
#ifdef _WIN32
        WSADATA wsaData;
        int wsaDataInit = 0;
#endif
        int recvResult;
        struct sockaddr_in service;
        char *replace;
        SOCKET connectSocket = INVALID_SOCKET;
        size_t dataLen = strlen(data);
        do
        {
#ifdef _WIN32
            if (WSAStartup(MAKEWORD(2,2), &wsaData) != NO_ERROR)
            {
                break;
            }
            wsaDataInit = 1;
#endif
            /* POTENTIAL FLAW: Read data using a connect socket */
            connectSocket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
            if (connectSocket == INVALID_SOCKET)
            {
                break;
            }
            memset(&service, 0, sizeof(service));
            service.sin_family = AF_INET;
            service.sin_addr.s_addr = inet_addr(IP_ADDRESS);
            service.sin_port = htons(TCP_PORT);
            if (connect(connectSocket, (struct sockaddr*)&service, sizeof(service)) == SOCKET_ERROR)
            {
                break;
            }
            /* Abort on error or the connection was closed, make sure to recv one
             * less char than is in the recv_buf in order to append a terminator */
            /* Abort on error or the connection was closed */
            recvResult = recv(connectSocket, (char *)(data + dataLen), sizeof(char) * (100 - dataLen - 1), 0);
            if (recvResult == SOCKET_ERROR || recvResult == 0)
            {
                break;
            }
            /* Append null terminator */
            data[dataLen + recvResult / sizeof(char)] = '\0';
            /* Eliminate CRLF */
            replace = strchr(data, '\r');
            if (replace)
            {
                *replace = '\0';
            }
            replace = strchr(data, '\n');
            if (replace)
            {
                *replace = '\0';
            }
        }
        while (0);
        if (connectSocket != INVALID_SOCKET)
        {
            CLOSE_SOCKET(connectSocket);
        }
#ifdef _WIN32
        if (wsaDataInit)
        {
            WSACleanup();
        }
#endif
    }
    badVaSink(data, data);
}
