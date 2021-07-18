<html>
<head>
</head>
<body>

<#function msg text args...>
    <#assign directive=title?interpret>
    <#assign msg>
        <@directive/>
    </#assign>
    <#return msg>
</#function>

<p>${m.msg(title)}</p>

</body>
</html>
