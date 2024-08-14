import powershell

class Parameter extends @parameter instanceof Ast
{
    string toString(){none()}

    VariableExpression getName(){
        parameter(this, result, _, _)
    }

    string getStaticType()
    {
        parameter(this, _, result, _)
    }

    int getNumAttributes(){
        parameter(this, _, _, result)
    }

    AttributeBase getAttribute(int i){
        parameter_attribute(this, i, result)
    }

    AttributeBase getAAttribute(){
        result = this.getAttribute(_)
    }

    Expression getDefaultValue(){
        parameter_default_value(this, result)
    }

    SourceLocation getLocation(){
        parameter_location(this, result)
    }
}