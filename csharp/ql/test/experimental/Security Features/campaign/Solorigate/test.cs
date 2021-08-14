using System;
using System.Text;

class FalsePositiveCases
{
	// regular FVN
	ulong GetRegularFvnHash(string s)
	{
		ulong num = 14695981039346656037UL; /* FNV base offset */

		foreach (byte b in Encoding.UTF8.GetBytes(s))
		{
			num ^= (ulong)b;
			num *= 1099511628211UL; /* FNV prime */
		}

		return num;
	}
}

class TestCases
{
	ulong GetRegularFvnHash(string s)
	{
		ulong num = 14695981039346656037UL;
		try
		{
			foreach (byte b in Encoding.UTF8.GetBytes(s))
			{
				num ^= (ulong)b;
				num *= 1099511628211UL;
			}
		}
		catch // BUG : SwallowEverythingExceptionHandler
		{

		}

		return num ^ 6605813339339102567UL; // BUG (ModifiedFnvFunctionDetection.ql)
	}

	enum JobEngine
	{
		Idle,
		Exit,
		SetTime,
		CollectSystemDescription,
		UploadSystemDescription,
		RunTask,
		GetProcessByDescription,
		KillTask,
		GetFileSystemEntries,
		WriteFile,
		FileExists,
		DeleteFile,
		GetFileHash,
		ReadRegistryValue,
		SetRegistryValue,
		DeleteRegistryValue,
		GetRegistrySubKeyAndValueNames,
		Reboot,
		None
	}

	void Abort() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void AddFileExecutionEngine() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void AddRegistryExecutionEngine() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void AdjustTokenPrivileges() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Base64Decode() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Base64Encode() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ByteArrayToHexString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CheckServerConnection() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Close() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CloseHandle() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CollectSystemDescription() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Compress() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateSecureString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateUploadRequest() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateUploadRequestImpl() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Decompress() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DecryptShort() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Deflate() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DelayMin() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DelayMs() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DeleteFile() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DeleteRegistryValue() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DeleteValue() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ExecuteEngine() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void FileExists() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetAddresses() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetAddressFamily() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetArgumentIndex() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetBaseUri() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetBaseUriImpl() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetCache() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetCurrentProcess() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetCurrentString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetDescriptionId() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetFileHash() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetFileSystemEntries() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetHash() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetHive() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetIntArray() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetIPHostEntry() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetManagementObjectProperty() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNetworkAdapterConfiguration() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNewOwnerName() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNextString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNextStringEx() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetOrCreateUserID() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetOrionImprovementCustomerId() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetOSVersion() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetPreviousString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetProcessByDescription() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetRegistrySubKeyAndValueNames() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetStatus() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetStringHash() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetSubKeyAndValueNames() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetUserAgent() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetValue() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetWebProxy() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void HexStringToByteArray() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Inflate() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Initialize() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void InitiateSystemShutdownExW() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void IsNullOrInvalidName() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void IsSynchronized() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void KillTask() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void LookupPrivilegeValueW() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void OpenProcessToken() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ParseServiceResponse() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Quote() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadConfig() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadDeviceInfo() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadRegistryValue() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadReportStatus() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadServiceStatus() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void RebootComputer() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void RunTask() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SearchAssemblies() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SearchConfigurations() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SearchServices() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetAutomaticMode() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetKeyOwner() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetKeyOwnerWithPrivileges() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetKeyPermissions() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetManualMode() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetProcessPrivilege() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetRegistryValue() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetTime() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetValue() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SplitString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ToString() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void TrackEvent() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void TrackProcesses() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Unquote() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Unzip() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Update() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void UpdateBuffer() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void UpdateNotification() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void UploadSystemDescription() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Valid() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteConfig() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteFile() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteReportStatus() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteServiceStatus() { } // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Zip() { } // BUG : NumberOfKnownMethodNamesAboveThreshold

	void Hashes() {
		ulong[] hashes = { // BUG : NumberOfKnownHashesAboveThreshold
		  10063651499895178962, 10235971842993272939, 10296494671777307979,
		  10336842116636872171, 10374841591685794123, 10393903804869831898,
		  10463926208560207521, 10484659978517092504, 10501212300031893463,
		  10545868833523019926, 10657751674541025650, 106672141413120087, 10734127004244879770,
		  10829648878147112121, 1099511628211, 11073283311104541690, 1109067043404435916,
		  11109294216876344399, 11266044540366291518, 11385275378891906608,
		  11771945869106552231, 11801746708619571308, 11818825521849580123,
		  11913842725949116895, 12027963942392743532, 12094027092655598256,
		  12343334044036541897, 12445177985737237804, 12445232961318634374,
		  12574535824074203265, 12679195163651834776, 12709986806548166638,
		  12718416789200275332, 12785322942775634499, 12790084614253405985,
		  12969190449276002545, 13014156621614176974, 13029357933491444455,
		  13135068273077306806, 13260224381505715848, 13316211011159594063,
		  13464308873961738403, 13544031715334011032, 13581776705111912829,
		  13599785766252827703, 13611051401579634621, 13611814135072561278,
		  13655261125244647696, 1367627386496056834, 1368907909245890092, 13693525876560827283,
		  13783346438774742614, 13799353263187722717, 13825071784440082496,
		  13852439084267373191, 13876356431472225791, 14055243717250701608,
		  14079676299181301772, 14095938998438966337, 14111374107076822891,
		  14193859431895170587, 14226582801651130532, 14243671177281069512,
		  14256853800858727521, 14480775929210717493, 14482658293117931546,
		  14513577387099045298, 14630721578341374856, 14695981039346656037,
		  14710585101020280896, 1475579823244607677, 14868920869169964081, 14968320160131875803,
		  14971809093655817917, 15039834196857999838, 15092207615430402812,
		  15114163911481793350, 15194901817027173566, 15267980678929160412,
		  15457732070353984570, 15514036435533858158, 15535773470978271326,
		  15587050164583443069, 155978580751494388, 15695338751700748390, 15997665423159927228,
		  16066522799090129502, 16066651430762394116, 16112751343173365533,
		  16130138450758310172, 1614465773938842903, 16292685861617888592, 16335643316870329598,
		  16423314183614230717, 16570804352575357627, 1682585410644922036, 16858955978146406642,
		  16990567851129491937, 17017923349298346219, 17097380490166623672,
		  17109238199226571972, 17204844226884380288, 17291806236368054941,
		  17351543633914244545, 17439059603042731363, 17574002783607647274,
		  17624147599670377042, 17633734304611248415, 17683972236092287897,
		  17849680105131524334, 17939405613729073960, 17956969551821596225,
		  17978774977754553159, 17984632978012874803, 17997967489723066537,
		  18147627057830191163, 18150909006539876521, 18159703063075866524,
		  18246404330670877335, 18294908219222222902, 18392881921099771407,
		  18446744073709551613, 191060519014405309, 2032008861530788751, 2128122064571842954,
		  2147483647, 2147745794, 2380224015317016190, 2478231962306073784,
		  2532538262737333146, 2589926981877829912, 2597124982561782591, 2600364143812063535,
		  2717025511528702475, 2734787258623754862, 27407921587843457, 2760663353550280147,
		  2797129108883749491, 2810460305047003196, 292198192373389586, 2934149816356927366,
		  3045986759481489935, 3178468437029279937, 3200333496547938354, 3320026265773918739,
		  3320767229281015341, 3341747963119755850, 3407972863931386250, 3413052607651207697,
		  3413886037471417852, 3421197789791424393, 3421213182954201407, 3425260965299690882,
		  3538022140597504361, 3575761800716667678, 3588624367609827560, 3626142665768487764,
		  3642525650883269872, 3656637464651387014, 3660705254426876796, 3769837838875367802,
		  3778500091710709090, 3796405623695665524, 3869935012404164040, 3890769468012566366,
		  3890794756780010537, 397780960855462669, 4030236413975199654, 4088976323439621041,
		  4454255944391929578, 4501656691368064027, 4578480846255629462, 4821863173800309721,
		  4931721628717906635, 506634811745884560, 5132256620104998637, 5183687599225757871,
		  521157249538507889, 5219431737322569038, 541172992193764396, 5415426428750045503,
		  5449730069165757263, 5587557070429522647, 5614586596107908838, 576626207276463000,
		  5942282052525294911, 5945487981219695001, 5984963105389676759, 607197993339007484,
		  6088115528707848728, 6116246686670134098, 6180361713414290679, 6195833633417633900,
		  6274014997237900919, 640589622539783622, 6461429591783621719, 6491986958834001955,
		  6508141243778577344, 6605813339339102567, 682250828679635420, 6827032273910657891,
		  6943102301517884811, 700598796416086955, 7080175711202577138, 7175363135479931834,
		  7315838824213522000, 7412338704062093516, 7516148236133302073, 7574774749059321801,
		  7701683279824397773, 7775177810774851294, 7810436520414958497, 7878537243757499832,
		  79089792725215063, 7982848972385914508, 8052533790968282297, 8129411991672431889,
		  8146185202538899243, 835151375515278827, 8381292265993977266, 8408095252303317471,
		  8473756179280619170, 8478833628889826985, 8612208440357175863, 8697424601205169055,
		  8698326794961817906, 8709004393777297355, 8727477769544302060, 8760312338504300643,
		  8799118153397725683, 8873858923435176895, 8994091295115840290, 9007106680104765185,
		  9061219083560670602, 9149947745824492274, 917638920165491138, 9234894663364701749,
		  9333057603143916814, 9384605490088500348, 9531326785919727076, 9555688264681862794,
		  9559632696372799208, 9903758755917170407
		};
	}

	void Literals() {
		string[] literals = { // BUG : NumberOfKnownLiteralsAboveThreshold
			"(?i)([^a-z]|^)(test)([^a-z]|$)", "(?i)(solarwinds)", "[{0,5}] {1,-16} {2}\t{3,5} {4}\\{5}\n",
			"[{0,5}] {1}\n", "[E] {0} {1} {2}",
			"\"\\{[0-9a-f-]{36}\\}\"|\"[0-9a-f]{32}\"|\"[0-9a-f]{16}\"", ".CortexPlugin", ".Orion",
			"\"EventName\":\"EventManager\",", "\"EventType\":\"Orion\",",
			"\\OrionImprovement\\SolarWinds.OrionImprovement.exe",
			"0123456789abcdefghijklmnopqrstuvwxyz-_.", "\"sessionId\":\"{0}\",", "\"steps\":[",
			"\"Succeeded\":true,", "\"Timestamp\":\"\\/Date({0})\\/\",", "\"userId\":\"{0}\",",
			"{0} {1} HTTP/{2}\n", "10140", "144.86.226.0", "154.118.140.0", "172.16.0.0", "18.130.0.0",
			"184.72.0.0", "192.168.0.0", "199.201.117.0", "20.140.0.0", "20100", "20220", "217.163.7.0",
			"224.0.0.0", "240.0.0.0", "255.240.0.0", "255.254.0.0", "255.255.248.0", "3.0.0.382",
			"41.84.159.0", "43140", "4320", "43260", "524287", "583da945-62af-10e8-4902-a8f205c72b2e",
			"65280", "71.152.53.0", "74.114.24.0", "8.18.144.0", "87.238.80.0", "96.31.172.0", "983040",
			"99.79.0.0", "Administrator", "advapi32.dll", "Apollo", "appsync-api", "avsvmcloud.com",
			"api.solarwinds.com", "-root", "-cert", "-universal_ca", "-ca", "-primary_ca", "-timestamp",
			"-global", "-secureca", "CloudMonitoring", "MACAddress", "DHCPEnabled", "DHCPServer",
			"DNSHostName", "DNSDomainSuffixSearchOrder", "DNSServerSearchOrder", "IPAddress", "IPSubnet",
			"DefaultIPGateway", "OSArchitecture", "InstallDate", "Organization", "RegisteredUser",
			"fc00::", "fe00::", "fec0::", "ffc0::", "ff00::", "HKCC", "HKCR", "HKCU", "HKDD",
			"HKEY_CLASSES_ROOT", "HKEY_CURRENT_CONFIG", "HKEY_CURRENT_USER", "HKEY_DYN_DATA",
			"HKEY_LOCAL_MACHINE", "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Cryptography",
			"HKEY_PERFOMANCE_DATA", "HKEY_USERS", "HKLM", "HKPD", "HKU", "If-None-Match",
			"Microsoft-CryptoAPI/", "Nodes", "Volumes", "Interfaces", "Components", "opensans",
			"Organization", "OSArchitecture", "ParentProcessID", "PathName", "ReportWatcherPostpone",
			"ReportWatcherRetry", "S-1-5-", "SeRestorePrivilege", "SeShutdownPrivilege",
			"SeTakeOwnershipPrivilege", "SolarWinds", "SolarWindsOrionImprovementClient/",
			"SourceCodePro", "SourceHanSans", "SourceHanSerif", "SourceSerifPro", "Start", "swip/Events",
			"swip/upd/", "swip/Upload.ashx", "SYSTEM", "SYSTEM\\CurrentControlSet\\services", "us-east-1",
			"us-east-2", "us-west-2", "fonts/woff/{0}-{1}-{2}{3}.woff2",
			"fonts/woff/{0}-{1}-{2}-webfont{3}.woff2", "ph2eifo3n5utg1j8d94qrvbmk0sal76c",
			"pki/crl/{0}{1}{2}.crl", "rq3gsalt6u1iyfzop572d49bnx8cvmkewhj",
			"Select * From Win32_NetworkAdapterConfiguration where IPEnabled=true",
			"Select * From Win32_OperatingSystem", "Select * From Win32_Process",
			"Select * From Win32_SystemDriver", "Select * From Win32_UserAccount"
		};
				
	}

	void SwallowExceptionTest()
	{
		try{
			Literals();
		}
		catch // BUG : SwallowEverythingExceptionHandler
		{}

		try{
			Literals();
		}
		catch( Exception e) // BUG : SwallowEverythingExceptionHandler
		{
			// 
		}

		try{
			Literals();
		}
		catch( Exception e)
		{
			// NOT A BUG
			throw;
		}
	}
}
