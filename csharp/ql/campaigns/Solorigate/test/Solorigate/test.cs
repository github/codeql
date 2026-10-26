using System;
using System.Text;

class FalsePositiveCases
{
	// regular FVN
	ulong GetRegularFvnHash(string s)
	{
		ulong num = 14695981039346656037UL; /* FNV base offset */ // $ SPURIOUS: Alert[cs/solorigate/number-of-known-hashes-above-threshold]

		foreach (byte b in Encoding.UTF8.GetBytes(s))
		{
			num ^= (ulong)b;
			num *= 1099511628211UL; /* FNV prime */ // $ SPURIOUS: Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		}

		return num;
	}
}

class TestCases
{
	ulong GetRegularFvnHash(string s)
	{
		ulong num = 14695981039346656037UL; // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		try
		{
			foreach (byte b in Encoding.UTF8.GetBytes(s))
			{
				num ^= (ulong)b;
				num *= 1099511628211UL; // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
			}
		}
		catch // BUG : SwallowEverythingExceptionHandler
		{

		} // $ Alert[cs/solorigate/swallow-everything-exception]

		return num ^ 6605813339339102567UL; // $ Alert[cs/solorigate/modified-fnv-function-detection] Alert[cs/solorigate/number-of-known-hashes-above-threshold] // BUG (ModifiedFnvFunctionDetection.ql)
	}

	enum JobEngine // $ Alert[cs/solorigate/number-of-known-commands-in-enum-above-threshold]
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

	void Abort() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void AddFileExecutionEngine() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void AddRegistryExecutionEngine() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void AdjustTokenPrivileges() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Base64Decode() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Base64Encode() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ByteArrayToHexString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CheckServerConnection() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Close() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CloseHandle() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CollectSystemDescription() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Compress() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateSecureString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateUploadRequest() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void CreateUploadRequestImpl() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Decompress() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DecryptShort() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Deflate() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DelayMin() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DelayMs() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DeleteFile() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DeleteRegistryValue() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void DeleteValue() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ExecuteEngine() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void FileExists() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetAddresses() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetAddressFamily() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetArgumentIndex() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetBaseUri() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetBaseUriImpl() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetCache() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetCurrentProcess() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetCurrentString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetDescriptionId() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetFileHash() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetFileSystemEntries() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetHash() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetHive() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetIntArray() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetIPHostEntry() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetManagementObjectProperty() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNetworkAdapterConfiguration() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNewOwnerName() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNextString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetNextStringEx() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetOrCreateUserID() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetOrionImprovementCustomerId() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetOSVersion() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetPreviousString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetProcessByDescription() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetRegistrySubKeyAndValueNames() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetStatus() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetStringHash() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetSubKeyAndValueNames() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetUserAgent() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetValue() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void GetWebProxy() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void HexStringToByteArray() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Inflate() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Initialize() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void InitiateSystemShutdownExW() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void IsNullOrInvalidName() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void IsSynchronized() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void KillTask() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void LookupPrivilegeValueW() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void OpenProcessToken() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ParseServiceResponse() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Quote() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadConfig() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadDeviceInfo() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadRegistryValue() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadReportStatus() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ReadServiceStatus() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void RebootComputer() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void RunTask() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SearchAssemblies() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SearchConfigurations() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SearchServices() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetAutomaticMode() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetKeyOwner() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetKeyOwnerWithPrivileges() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetKeyPermissions() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetManualMode() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetProcessPrivilege() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetRegistryValue() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetTime() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SetValue() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void SplitString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void ToString() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void TrackEvent() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void TrackProcesses() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Unquote() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Unzip() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Update() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void UpdateBuffer() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void UpdateNotification() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void UploadSystemDescription() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Valid() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteConfig() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteFile() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteReportStatus() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void WriteServiceStatus() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold
	void Zip() { } // $ Alert[cs/solorigate/number-of-known-method-names-above-threshold] // BUG : NumberOfKnownMethodNamesAboveThreshold

	void Hashes() {
		ulong[] hashes = { // BUG : NumberOfKnownHashesAboveThreshold
		  10063651499895178962, 10235971842993272939, 10296494671777307979, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  10336842116636872171, 10374841591685794123, 10393903804869831898, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  10463926208560207521, 10484659978517092504, 10501212300031893463, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  10545868833523019926, 10657751674541025650, 106672141413120087, 10734127004244879770, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  10829648878147112121, 1099511628211, 11073283311104541690, 1109067043404435916, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  11109294216876344399, 11266044540366291518, 11385275378891906608, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  11771945869106552231, 11801746708619571308, 11818825521849580123, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  11913842725949116895, 12027963942392743532, 12094027092655598256, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  12343334044036541897, 12445177985737237804, 12445232961318634374, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  12574535824074203265, 12679195163651834776, 12709986806548166638, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  12718416789200275332, 12785322942775634499, 12790084614253405985, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  12969190449276002545, 13014156621614176974, 13029357933491444455, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  13135068273077306806, 13260224381505715848, 13316211011159594063, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  13464308873961738403, 13544031715334011032, 13581776705111912829, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  13599785766252827703, 13611051401579634621, 13611814135072561278, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  13655261125244647696, 1367627386496056834, 1368907909245890092, 13693525876560827283, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  13783346438774742614, 13799353263187722717, 13825071784440082496, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  13852439084267373191, 13876356431472225791, 14055243717250701608, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  14079676299181301772, 14095938998438966337, 14111374107076822891, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  14193859431895170587, 14226582801651130532, 14243671177281069512, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  14256853800858727521, 14480775929210717493, 14482658293117931546, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  14513577387099045298, 14630721578341374856, 14695981039346656037, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  14710585101020280896, 1475579823244607677, 14868920869169964081, 14968320160131875803, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  14971809093655817917, 15039834196857999838, 15092207615430402812, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  15114163911481793350, 15194901817027173566, 15267980678929160412, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  15457732070353984570, 15514036435533858158, 15535773470978271326, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  15587050164583443069, 155978580751494388, 15695338751700748390, 15997665423159927228, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  16066522799090129502, 16066651430762394116, 16112751343173365533, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  16130138450758310172, 1614465773938842903, 16292685861617888592, 16335643316870329598, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  16423314183614230717, 16570804352575357627, 1682585410644922036, 16858955978146406642, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  16990567851129491937, 17017923349298346219, 17097380490166623672, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  17109238199226571972, 17204844226884380288, 17291806236368054941, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  17351543633914244545, 17439059603042731363, 17574002783607647274, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  17624147599670377042, 17633734304611248415, 17683972236092287897, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  17849680105131524334, 17939405613729073960, 17956969551821596225, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  17978774977754553159, 17984632978012874803, 17997967489723066537, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  18147627057830191163, 18150909006539876521, 18159703063075866524, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  18246404330670877335, 18294908219222222902, 18392881921099771407, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  18446744073709551613, 191060519014405309, 2032008861530788751, 2128122064571842954, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  2147483647, 2147745794, 2380224015317016190, 2478231962306073784, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  2532538262737333146, 2589926981877829912, 2597124982561782591, 2600364143812063535, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  2717025511528702475, 2734787258623754862, 27407921587843457, 2760663353550280147, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  2797129108883749491, 2810460305047003196, 292198192373389586, 2934149816356927366, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  3045986759481489935, 3178468437029279937, 3200333496547938354, 3320026265773918739, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  3320767229281015341, 3341747963119755850, 3407972863931386250, 3413052607651207697, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  3413886037471417852, 3421197789791424393, 3421213182954201407, 3425260965299690882, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  3538022140597504361, 3575761800716667678, 3588624367609827560, 3626142665768487764, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  3642525650883269872, 3656637464651387014, 3660705254426876796, 3769837838875367802, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  3778500091710709090, 3796405623695665524, 3869935012404164040, 3890769468012566366, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  3890794756780010537, 397780960855462669, 4030236413975199654, 4088976323439621041, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  4454255944391929578, 4501656691368064027, 4578480846255629462, 4821863173800309721, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  4931721628717906635, 506634811745884560, 5132256620104998637, 5183687599225757871, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  521157249538507889, 5219431737322569038, 541172992193764396, 5415426428750045503, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  5449730069165757263, 5587557070429522647, 5614586596107908838, 576626207276463000, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  5942282052525294911, 5945487981219695001, 5984963105389676759, 607197993339007484, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  6088115528707848728, 6116246686670134098, 6180361713414290679, 6195833633417633900, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  6274014997237900919, 640589622539783622, 6461429591783621719, 6491986958834001955, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  6508141243778577344, 6605813339339102567, 682250828679635420, 6827032273910657891, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  6943102301517884811, 700598796416086955, 7080175711202577138, 7175363135479931834, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  7315838824213522000, 7412338704062093516, 7516148236133302073, 7574774749059321801, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  7701683279824397773, 7775177810774851294, 7810436520414958497, 7878537243757499832, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  79089792725215063, 7982848972385914508, 8052533790968282297, 8129411991672431889, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  8146185202538899243, 835151375515278827, 8381292265993977266, 8408095252303317471, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  8473756179280619170, 8478833628889826985, 8612208440357175863, 8697424601205169055, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  8698326794961817906, 8709004393777297355, 8727477769544302060, 8760312338504300643, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  8799118153397725683, 8873858923435176895, 8994091295115840290, 9007106680104765185, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  9061219083560670602, 9149947745824492274, 917638920165491138, 9234894663364701749, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  9333057603143916814, 9384605490088500348, 9531326785919727076, 9555688264681862794, // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		  9559632696372799208, 9903758755917170407 // $ Alert[cs/solorigate/number-of-known-hashes-above-threshold]
		};
	}

	void Literals() {
		string[] literals = { // BUG : NumberOfKnownLiteralsAboveThreshold
			"(?i)([^a-z]|^)(test)([^a-z]|$)", "(?i)(solarwinds)", "[{0,5}] {1,-16} {2}\t{3,5} {4}\\{5}\n", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"[{0,5}] {1}\n", "[E] {0} {1} {2}", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"\"\\{[0-9a-f-]{36}\\}\"|\"[0-9a-f]{32}\"|\"[0-9a-f]{16}\"", ".CortexPlugin", ".Orion", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"\"EventName\":\"EventManager\",", "\"EventType\":\"Orion\",", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"\\OrionImprovement\\SolarWinds.OrionImprovement.exe", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"0123456789abcdefghijklmnopqrstuvwxyz-_.", "\"sessionId\":\"{0}\",", "\"steps\":[", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"\"Succeeded\":true,", "\"Timestamp\":\"\\/Date({0})\\/\",", "\"userId\":\"{0}\",", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"{0} {1} HTTP/{2}\n", "10140", "144.86.226.0", "154.118.140.0", "172.16.0.0", "18.130.0.0", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"184.72.0.0", "192.168.0.0", "199.201.117.0", "20.140.0.0", "20100", "20220", "217.163.7.0", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"224.0.0.0", "240.0.0.0", "255.240.0.0", "255.254.0.0", "255.255.248.0", "3.0.0.382", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"41.84.159.0", "43140", "4320", "43260", "524287", "583da945-62af-10e8-4902-a8f205c72b2e", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"65280", "71.152.53.0", "74.114.24.0", "8.18.144.0", "87.238.80.0", "96.31.172.0", "983040", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"99.79.0.0", "Administrator", "advapi32.dll", "Apollo", "appsync-api", "avsvmcloud.com", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"api.solarwinds.com", "-root", "-cert", "-universal_ca", "-ca", "-primary_ca", "-timestamp", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"-global", "-secureca", "CloudMonitoring", "MACAddress", "DHCPEnabled", "DHCPServer", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"DNSHostName", "DNSDomainSuffixSearchOrder", "DNSServerSearchOrder", "IPAddress", "IPSubnet", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"DefaultIPGateway", "OSArchitecture", "InstallDate", "Organization", "RegisteredUser", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"fc00::", "fe00::", "fec0::", "ffc0::", "ff00::", "HKCC", "HKCR", "HKCU", "HKDD", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"HKEY_CLASSES_ROOT", "HKEY_CURRENT_CONFIG", "HKEY_CURRENT_USER", "HKEY_DYN_DATA", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"HKEY_LOCAL_MACHINE", "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Cryptography", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"HKEY_PERFOMANCE_DATA", "HKEY_USERS", "HKLM", "HKPD", "HKU", "If-None-Match", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"Microsoft-CryptoAPI/", "Nodes", "Volumes", "Interfaces", "Components", "opensans", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"Organization", "OSArchitecture", "ParentProcessID", "PathName", "ReportWatcherPostpone", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"ReportWatcherRetry", "S-1-5-", "SeRestorePrivilege", "SeShutdownPrivilege", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"SeTakeOwnershipPrivilege", "SolarWinds", "SolarWindsOrionImprovementClient/", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"SourceCodePro", "SourceHanSans", "SourceHanSerif", "SourceSerifPro", "Start", "swip/Events", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"swip/upd/", "swip/Upload.ashx", "SYSTEM", "SYSTEM\\CurrentControlSet\\services", "us-east-1", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"us-east-2", "us-west-2", "fonts/woff/{0}-{1}-{2}{3}.woff2", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"fonts/woff/{0}-{1}-{2}-webfont{3}.woff2", "ph2eifo3n5utg1j8d94qrvbmk0sal76c", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"pki/crl/{0}{1}{2}.crl", "rq3gsalt6u1iyfzop572d49bnx8cvmkewhj", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"Select * From Win32_NetworkAdapterConfiguration where IPEnabled=true", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"Select * From Win32_OperatingSystem", "Select * From Win32_Process", // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
			"Select * From Win32_SystemDriver", "Select * From Win32_UserAccount" // $ Alert[cs/solorigate/number-of-known-literals-above-threshold]
		};

	}

	void SwallowExceptionTest()
	{
		try{
			Literals();
		}
		catch // BUG : SwallowEverythingExceptionHandler
		{} // $ Alert[cs/solorigate/swallow-everything-exception]

		try{
			Literals();
		}
		catch( Exception e) // BUG : SwallowEverythingExceptionHandler
		{
			//
		} // $ Alert[cs/solorigate/swallow-everything-exception]

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
