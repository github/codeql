# Test 1: BinaryFormatter.Deserialize (existing)
$untrustedBase64 = Read-Host "Enter user input"
$formatter = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
$stream = [System.IO.MemoryStream]::new([Convert]::FromBase64String($untrustedBase64))
$obj = $formatter.Deserialize($stream)

# Test 2: BinaryFormatter.UnsafeDeserialize
$input2 = Read-Host "Enter data"
$formatter2 = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
$stream2 = [System.IO.MemoryStream]::new([Convert]::FromBase64String($input2))
$obj2 = $formatter2.UnsafeDeserialize($stream2, $null)

# Test 3: SoapFormatter.Deserialize
$input3 = Read-Host "Enter soap data"
$soapFormatter = New-Object System.Runtime.Serialization.Formatters.Soap.SoapFormatter
$stream3 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input3))
$obj3 = $soapFormatter.Deserialize($stream3)

# Test 4: ObjectStateFormatter.Deserialize
$input4 = Read-Host "Enter state data"
$osf = New-Object System.Web.UI.ObjectStateFormatter
$obj4 = $osf.Deserialize($input4)

# Test 5: NetDataContractSerializer.Deserialize
$input5 = Read-Host "Enter serialized data"
$ndcs = New-Object System.Runtime.Serialization.NetDataContractSerializer
$stream5 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input5))
$obj5 = $ndcs.Deserialize($stream5)

# Test 6: NetDataContractSerializer.ReadObject
$input6 = Read-Host "Enter object data"
$ndcs2 = New-Object System.Runtime.Serialization.NetDataContractSerializer
$stream6 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input6))
$obj6 = $ndcs2.ReadObject($stream6)

# Test 7: LosFormatter.Deserialize
$input7 = Read-Host "Enter LOS data"
$losFormatter = New-Object System.Web.UI.LosFormatter
$obj7 = $losFormatter.Deserialize($input7)

# Test 8: XamlReader.Parse (static)
$input8 = Read-Host "Enter XAML"
$obj8 = [System.Windows.Markup.XamlReader]::Parse($input8)

# Test 9: XamlReader.Load (static)
$input9 = Read-Host "Enter XAML stream data"
$stream9 = [System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($input9))
$obj9 = [System.Windows.Markup.XamlReader]::Load($stream9)

# Test 10: DataSet.ReadXmlSchema
$input10 = Read-Host "Enter schema data"
$ds = New-Object System.Data.DataSet
$ds.ReadXmlSchema([System.IO.StringReader]::new($input10))

# Test 11: DataTable.ReadXml
$input11 = Read-Host "Enter table data"
$dt = New-Object System.Data.DataTable
$dt.ReadXml([System.IO.StringReader]::new($input11))

# Test 12: DataTable.ReadXmlSchema
$input12 = Read-Host "Enter table schema"
$dt2 = New-Object System.Data.DataTable
$dt2.ReadXmlSchema([System.IO.StringReader]::new($input12))

# Test 13: ResourceReader constructor (New-Object)
$input13 = Read-Host "Enter resource path"
$reader = New-Object System.Resources.ResourceReader -ArgumentList $input13

# Test 14: ResXResourceReader constructor ([Type]::new())
$input14 = Read-Host "Enter resx path"
$resxReader = [System.Resources.ResXResourceReader]::new($input14)

# Test 15: Activity.Load (static)
$input15 = Read-Host "Enter activity data"
$stream15 = [System.IO.MemoryStream]::new([Convert]::FromBase64String($input15))
[System.Workflow.ComponentModel.Activity]::Load($stream15, $null)

# Test 16: YamlDotNet.Serialization.Deserializer.Deserialize
$input16 = Read-Host "Enter YAML"
$yamlDeserializer = New-Object YamlDotNet.Serialization.Deserializer
$obj16 = $yamlDeserializer.Deserialize($input16)

# Test 17: MemoryPackSerializer.Deserialize (static)
$input17 = Read-Host "Enter packed data"
$bytes17 = [Convert]::FromBase64String($input17)
[MemoryPack.MemoryPackSerializer]::Deserialize($bytes17)
