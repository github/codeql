// Generated automatically from org.thymeleaf.IEngineConfiguration for testing purposes

package org.thymeleaf;

import java.util.Map;
import java.util.Set;
import org.thymeleaf.DialectConfiguration;
import org.thymeleaf.cache.ICacheManager;
import org.thymeleaf.context.IEngineContextFactory;
import org.thymeleaf.dialect.IDialect;
import org.thymeleaf.engine.AttributeDefinitions;
import org.thymeleaf.engine.ElementDefinitions;
import org.thymeleaf.engine.TemplateManager;
import org.thymeleaf.expression.IExpressionObjectFactory;
import org.thymeleaf.linkbuilder.ILinkBuilder;
import org.thymeleaf.messageresolver.IMessageResolver;
import org.thymeleaf.model.IModelFactory;
import org.thymeleaf.postprocessor.IPostProcessor;
import org.thymeleaf.preprocessor.IPreProcessor;
import org.thymeleaf.processor.cdatasection.ICDATASectionProcessor;
import org.thymeleaf.processor.comment.ICommentProcessor;
import org.thymeleaf.processor.doctype.IDocTypeProcessor;
import org.thymeleaf.processor.element.IElementProcessor;
import org.thymeleaf.processor.processinginstruction.IProcessingInstructionProcessor;
import org.thymeleaf.processor.templateboundaries.ITemplateBoundariesProcessor;
import org.thymeleaf.processor.text.ITextProcessor;
import org.thymeleaf.processor.xmldeclaration.IXMLDeclarationProcessor;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateparser.markup.decoupled.IDecoupledTemplateLogicResolver;
import org.thymeleaf.templateresolver.ITemplateResolver;

public interface IEngineConfiguration
{
    AttributeDefinitions getAttributeDefinitions();
    ElementDefinitions getElementDefinitions();
    ICacheManager getCacheManager();
    IDecoupledTemplateLogicResolver getDecoupledTemplateLogicResolver();
    IEngineContextFactory getEngineContextFactory();
    IExpressionObjectFactory getExpressionObjectFactory();
    IModelFactory getModelFactory(TemplateMode p0);
    Map<String, Object> getExecutionAttributes();
    Set<DialectConfiguration> getDialectConfigurations();
    Set<ICDATASectionProcessor> getCDATASectionProcessors(TemplateMode p0);
    Set<ICommentProcessor> getCommentProcessors(TemplateMode p0);
    Set<IDialect> getDialects();
    Set<IDocTypeProcessor> getDocTypeProcessors(TemplateMode p0);
    Set<IElementProcessor> getElementProcessors(TemplateMode p0);
    Set<ILinkBuilder> getLinkBuilders();
    Set<IMessageResolver> getMessageResolvers();
    Set<IPostProcessor> getPostProcessors(TemplateMode p0);
    Set<IPreProcessor> getPreProcessors(TemplateMode p0);
    Set<IProcessingInstructionProcessor> getProcessingInstructionProcessors(TemplateMode p0);
    Set<ITemplateBoundariesProcessor> getTemplateBoundariesProcessors(TemplateMode p0);
    Set<ITemplateResolver> getTemplateResolvers();
    Set<ITextProcessor> getTextProcessors(TemplateMode p0);
    Set<IXMLDeclarationProcessor> getXMLDeclarationProcessors(TemplateMode p0);
    String getStandardDialectPrefix();
    TemplateManager getTemplateManager();
    boolean isStandardDialectPresent();
}
