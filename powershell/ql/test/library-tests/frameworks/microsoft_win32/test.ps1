$registryPath = "HKEY_LOCAL_MACHINE/SOFTWARE/Microsoft/Windows NT/CurrentVersion"
$valueName = "ProductName"
$productName = [Microsoft.Win32.Registry]::GetValue($registryPath, $valueName, $null) # $ type="a value from the Windows registry"


$registryKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($registryPath)

# Get the value of a registry key
$productName2 = $registryKey.GetValue($valueName) # $ type="a value from the Windows registry"


# Get all value names in the registry key
$valueNames = $registryKey.GetValueNames() # $ type="a value from the Windows registry"

# TODO: I think this should also have a positional element on the access path
$subKeyNames = $registryKey.GetSubKeyNames() # $ type="a value from the Windows registry"
