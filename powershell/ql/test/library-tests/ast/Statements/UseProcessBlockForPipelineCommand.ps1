Function Get-Number
{
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline)]
        [int]
        $Number
    )

    $Number
}