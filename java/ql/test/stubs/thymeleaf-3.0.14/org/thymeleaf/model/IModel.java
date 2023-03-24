// Generated automatically from org.thymeleaf.model.IModel for testing purposes

package org.thymeleaf.model;

import java.io.Writer;
import org.thymeleaf.IEngineConfiguration;
import org.thymeleaf.model.IModelVisitor;
import org.thymeleaf.model.ITemplateEvent;
import org.thymeleaf.templatemode.TemplateMode;

public interface IModel
{
    IEngineConfiguration getConfiguration();
    IModel cloneModel();
    ITemplateEvent get(int p0);
    TemplateMode getTemplateMode();
    int size();
    void accept(IModelVisitor p0);
    void add(ITemplateEvent p0);
    void addModel(IModel p0);
    void insert(int p0, ITemplateEvent p1);
    void insertModel(int p0, IModel p1);
    void remove(int p0);
    void replace(int p0, ITemplateEvent p1);
    void reset();
    void write(Writer p0);
}
