package com.example.freemarkertest;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.Version;
import freemarker.core.TemplateClassResolver;
import freemarker.cache.StringTemplateLoader;

{
    Configuration cfg = new Configuration();
    cfg.setDirectoryForTemplateLoading(new File("/home/templates"));
    
    cfg.setDefaultEncoding("UTF-8");
    cfg.setLocale(Locale.US);
    cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

    // cfg.setAPIBuiltinEnabled(true);
    // cfg.setNewBuiltinClassResolver(TemplateClassResolver.ALLOWS_NOTHING_RESOLVER);
    // cfg.setSetting("new_builtin_class_resolver", "allows_nothing");

    Map<String, Object> input = new HashMap<String, Object>();
    input.put("title", argv[1]);

    Template template = cfg.getTemplate("FreemarkerUnsafeConfiguration.ftl");
    Writer consoleWriter = new OutputStreamWriter(System.out);
    template.process(input, consoleWriter);

}