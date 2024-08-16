$var = 1
while ($var -le 5)
{
    Write-Host The value of Var is: $var
    $var++
    if ($var -le 3){
        continue;
    }
    else
    {
        break;
    }
}