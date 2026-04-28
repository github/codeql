# Test 1: BinaryFormatter.Deserialize
$untrustedBase64 = Read-Host "Enter user input" # $ Source
$formatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
$stream = [System.IO.MemoryStream]::new([Convert]::FromBase64String($untrustedBase64))
$obj = $formatter.Deserialize($stream) # $ Alert

# Test 2: BinaryFormatter.UnsafeDeserialize
$input2 = Read-Host "Enter data" # $ Source
$formatter2 = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
$stream2 = [System.IO.MemoryStream]::new([Convert]::FromBase64String($input2))
$obj2 = $formatter2.UnsafeDeserialize($stream2, $null) # $ Alert

# Test 3: SoapFormatter.Deserialize
$input3 = Read-Host "Enter soap data" # $ Source
$soapFormatter = New-Object System.Runtime.Serialization.Formatters.Soap.SoapFormatter
$stream3 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input3))
$obj3 = $soapFormatter.Deserialize($stream3) # $ Alert

# Test 4: ObjectStateFormatter.Deserialize
$input4 = Read-Host "Enter state data" # $ Source
$osf = New-Object System.Web.UI.ObjectStateFormatter
$obj4 = $osf.Deserialize($input4) # $ Alert

# Test 5: NetDataContractSerializer.Deserialize
$input5 = Read-Host "Enter serialized data" # $ Source
$ndcs = New-Object System.Runtime.Serialization.NetDataContractSerializer
$stream5 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input5))
$obj5 = $ndcs.Deserialize($stream5) # $ Alert

# Test 6: NetDataContractSerializer.ReadObject
$input6 = Read-Host "Enter object data" # $ Source
$ndcs2 = New-Object System.Runtime.Serialization.NetDataContractSerializer
$stream6 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input6))
$obj6 = $ndcs2.ReadObject($stream6) # $ Alert

# Test 7: LosFormatter.Deserialize
$input7 = Read-Host "Enter LOS data" # $ Source
$losFormatter = New-Object System.Web.UI.LosFormatter
$obj7 = $losFormatter.Deserialize($input7) # $ Alert

# Test 8: XamlReader.Parse (static)
$input8 = Read-Host "Enter XAML" # $ Source
$obj8 = [System.Windows.Markup.XamlReader]::Parse($input8) # $ Alert

# Test 9: XamlReader.Load (static)
$input9 = Read-Host "Enter XAML stream data" # $ Source
$stream9 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input9))
$obj9 = [System.Windows.Markup.XamlReader]::Load($stream9) # $ Alert

# Test 10: DataSet.ReadXmlSchema
$input10 = Read-Host "Enter schema data" # $ Source
$ds = New-Object System.Data.DataSet
$ds.ReadXmlSchema([System.IO.StringReader]::new($input10)) # $ Alert

# Test 11: DataTable.ReadXml
$input11 = Read-Host "Enter table data" # $ Source
$dt = New-Object System.Data.DataTable
$dt.ReadXml([System.IO.StringReader]::new($input11)) # $ Alert

# Test 12: DataTable.ReadXmlSchema
$input12 = Read-Host "Enter table schema" # $ Source
$dt2 = New-Object System.Data.DataTable
$dt2.ReadXmlSchema([System.IO.StringReader]::new($input12)) # $ Alert

# Test 13: ResourceReader constructor (New-Object)
$input13 = Read-Host "Enter resource path" # $ Source
$reader = New-Object System.Resources.ResourceReader -ArgumentList $input13 # $ Alert

# Test 14: ResXResourceReader constructor ([Type]::new())
$input14 = Read-Host "Enter resx path" # $ Source
$resxReader = [System.Resources.ResXResourceReader]::new($input14) # $ Alert

# Test 15: Activity.Load (static)
$input15 = Read-Host "Enter activity data" # $ Source
$stream15 = [System.IO.MemoryStream]::new([Convert]::FromBase64String($input15))
[System.Workflow.ComponentModel.Activity]::Load($stream15, $null) # $ Alert

# Test 16: YamlDotNet.Serialization.Deserializer.Deserialize
$input16 = Read-Host "Enter YAML" # $ Source
$yamlDeserializer = New-Object YamlDotNet.Serialization.Deserializer
$obj16 = $yamlDeserializer.Deserialize($input16) # $ Alert

# Test 17: MemoryPackSerializer.Deserialize (static)
$input17 = Read-Host "Enter packed data" # $ Source
$bytes17 = [Convert]::FromBase64String($input17)
[MemoryPack.MemoryPackSerializer]::Deserialize($bytes17) # $ Alert
