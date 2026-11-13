package com.example.freemarkertest;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.Version;
import freemarker.core.TemplateClassResolver;
import freemarker.cache.StringTemplateLoader;

{
    Configuration cfg = new Configuration();
    cfg.setDefaultEncoding("UTF-8");
    cfg.setLocale(Locale.US);
    cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

    // cfg.setNewBuiltinClassResolver(TemplateClassResolver.ALLOWS_NOTHING_RESOLVER);
    // cfg.setSetting("new_builtin_class_resolver", "allows_nothing");

    // String templateStr="<#assign ex=\"freemarker.template.utility.Execute\"?new()> ${ex(\"id\")}";
    String templateStr=argv[1];
    Template t = new Template("name", new StringReader(templateStr), cfg);
    Writer consoleWriter3 = new OutputStreamWriter(System.out);
    t.process(input, consoleWriter3);

}