// Generated automatically from org.thymeleaf.engine.TemplateModel for testing purposes

package org.thymeleaf.engine;

import java.io.Writer;
import org.thymeleaf.IEngineConfiguration;
import org.thymeleaf.engine.TemplateData;
import org.thymeleaf.model.IModel;
import org.thymeleaf.model.IModelVisitor;
import org.thymeleaf.model.ITemplateEvent;
import org.thymeleaf.templatemode.TemplateMode;

public class TemplateModel implements IModel
{
    protected TemplateModel() {}
    public final IEngineConfiguration getConfiguration(){ return null; }
    public final IModel cloneModel(){ return null; }
    public final ITemplateEvent get(int p0){ return null; }
    public final String toString(){ return null; }
    public final TemplateData getTemplateData(){ return null; }
    public final TemplateMode getTemplateMode(){ return null; }
    public final int size(){ return 0; }
    public final void add(ITemplateEvent p0){}
    public final void addModel(IModel p0){}
    public final void insert(int p0, ITemplateEvent p1){}
    public final void insertModel(int p0, IModel p1){}
    public final void remove(int p0){}
    public final void replace(int p0, ITemplateEvent p1){}
    public final void reset(){}
    public final void write(Writer p0){}
    public void accept(IModelVisitor p0){}
}
