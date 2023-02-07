<%@taglib prefix="e" uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" %>


<h1>${e:forHtml(param.test1)}</h1>

<script>
    function hello(param1,param2) {
        console.info(param1+" "+param2);
    }
    var test = hello('${e:forJavaScript(param.test1)}','${e:forJavaScript(param.test2)}');
</script>
