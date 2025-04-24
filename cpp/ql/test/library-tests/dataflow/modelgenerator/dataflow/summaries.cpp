using size_t = decltype(sizeof(int));

size_t strlen(const char* str);
char* strcpy(char* dest, const char* src);

namespace Models {
    struct BasicFlow {
        int* tainted;

        //No model as destructors are excluded from model generation.
        ~BasicFlow() = default;

        //heuristic-summary=Models;BasicFlow;true;returnThis;(int *);;Argument[-1];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;BasicFlow;true;returnThis;(int *);;Argument[-1];ReturnValue[*];value;dfc-generated
        BasicFlow* returnThis(int* input) {
            return this;
        }

        //heuristic-summary=Models;BasicFlow;true;returnParam0;(int *,int *);;Argument[0];ReturnValue;taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnParam0;(int *,int *);;Argument[*0];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;BasicFlow;true;returnParam0;(int *,int *);;Argument[0];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnParam0;(int *,int *);;Argument[*0];ReturnValue[*];value;dfc-generated
        int* returnParam0(int* input0, int* input1) {
            return input0;
        }

        //heuristic-summary=Models;BasicFlow;true;returnParam1;(int *,int *);;Argument[1];ReturnValue;taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnParam1;(int *,int *);;Argument[*1];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;BasicFlow;true;returnParam1;(int *,int *);;Argument[1];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnParam1;(int *,int *);;Argument[*1];ReturnValue[*];value;dfc-generated
        int* returnParam1(int* input0, int* input1) {
            return input1;
        }

        //heuristic-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[1];ReturnValue;taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[*1];ReturnValue[*];taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[2];ReturnValue;taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[*2];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[1];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[*1];ReturnValue[*];value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[2];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnParamMultiple;(bool,int *,int *);;Argument[*2];ReturnValue[*];value;dfc-generated
        int* returnParamMultiple(bool b, int* input0, int* input1) {
            return b ? input0 : input1;
        }

        //heuristic-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[0];Argument[*1];taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[0];ReturnValue[*];taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[*0];ReturnValue[*];taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[1];ReturnValue;taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[*0];Argument[*1];taint;df-generated
        //contentbased-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[0];Argument[*1];taint;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[0];ReturnValue[*];taint;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[*0];ReturnValue[*];value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[1];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnSubstring;(const char *,char *);;Argument[*0];Argument[*1];value;dfc-generated
        char* returnSubstring(const char* source, char* dest) {
            return strcpy(dest, source + 1);
        }

        //heuristic-summary=Models;BasicFlow;true;setField;(int *);;Argument[0];Argument[-1];taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;setField;(int *);;Argument[*0];Argument[-1];taint;df-generated
        //contentbased-summary=Models;BasicFlow;true;setField;(int *);;Argument[0];Argument[-1].Field[*tainted];value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;setField;(int *);;Argument[*0];Argument[-1].Field[**tainted];value;dfc-generated
        void setField(int* s) {
            tainted = s;
        }

        //heuristic-summary=Models;BasicFlow;true;returnField;();;Argument[-1];ReturnValue;taint;df-generated
        //heuristic-summary=Models;BasicFlow;true;returnField;();;Argument[-1];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;BasicFlow;true;returnField;();;Argument[-1].Field[*tainted];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;BasicFlow;true;returnField;();;Argument[-1].Field[**tainted];ReturnValue[*];value;dfc-generated
        int* returnField() {
            return tainted;
        }
    };

    template<typename T>
    struct TemplatedFlow {
        T tainted;

        //heuristic-summary=Models;TemplatedFlow<T>;true;template_returnThis;(T);;Argument[-1];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;TemplatedFlow<T>;true;template_returnThis;(T);;Argument[-1];ReturnValue[*];value;dfc-generated
        TemplatedFlow<T>* template_returnThis(T input) {
            return this;
        }

        //heuristic-summary=Models;TemplatedFlow<T>;true;template_returnParam0;(T *,T *);;Argument[0];ReturnValue;taint;df-generated
        //heuristic-summary=Models;TemplatedFlow<T>;true;template_returnParam0;(T *,T *);;Argument[*0];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;TemplatedFlow<T>;true;template_returnParam0;(T *,T *);;Argument[0];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;TemplatedFlow<T>;true;template_returnParam0;(T *,T *);;Argument[*0];ReturnValue[*];value;dfc-generated
        T* template_returnParam0(T* input0, T* input1) {
            return input0;
        }

        //heuristic-summary=Models;TemplatedFlow<T>;true;template_setField;(T);;Argument[0];Argument[-1];taint;df-generated
        //contentbased-summary=Models;TemplatedFlow<T>;true;template_setField;(T);;Argument[0];Argument[-1].Field[*tainted];value;dfc-generated
        void template_setField(T s) {
            tainted = s;
        }

        //heuristic-summary=Models;TemplatedFlow<T>;true;template_returnField;();;Argument[-1];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;TemplatedFlow<T>;true;template_returnField;();;Argument[-1].Field[*tainted];ReturnValue[*];value;dfc-generated
        T& template_returnField() {
            return tainted;
        }

        //heuristic-summary=Models;TemplatedFlow<T>;true;templated_function<U>;(U *,T *);;Argument[0];ReturnValue;taint;df-generated
        //heuristic-summary=Models;TemplatedFlow<T>;true;templated_function<U>;(U *,T *);;Argument[*0];ReturnValue[*];taint;df-generated
        //contentbased-summary=Models;TemplatedFlow<T>;true;templated_function<U>;(U *,T *);;Argument[0];ReturnValue;value;dfc-generated
        //contentbased-summary=Models;TemplatedFlow<T>;true;templated_function<U>;(U *,T *);;Argument[*0];ReturnValue[*];value;dfc-generated
        template<typename U>
        U* templated_function(U* u, T* t) {
            return u;
        }
    };

    void test_templated_flow() {
        // Ensure that we have an instantiation of the templated class
        TemplatedFlow<int> intFlow;
        intFlow.template_returnThis(0);

        intFlow.template_returnParam0(nullptr, nullptr);

        intFlow.template_setField(0);
        intFlow.template_returnField();

        intFlow.templated_function<int>(nullptr, nullptr);
    }
}

//heuristic-summary=;;true;toplevel_function;(int *);;Argument[0];ReturnValue;taint;df-generated
//heuristic-summary=;;true;toplevel_function;(int *);;Argument[*0];ReturnValue;taint;df-generated
//contentbased-summary=;;true;toplevel_function;(int *);;Argument[0];ReturnValue;taint;dfc-generated
//contentbased-summary=;;true;toplevel_function;(int *);;Argument[*0];ReturnValue;value;dfc-generated
int toplevel_function(int* p) {
    return *p;
}

//No model as static functions are excluded from model generation.
static int static_toplevel_function(int* p) {
    return *p;
}

struct NonFinalStruct {
    //heuristic-summary=;NonFinalStruct;true;public_not_final_member_function;(int);;Argument[0];ReturnValue;taint;df-generated
    //contentbased-summary=;NonFinalStruct;true;public_not_final_member_function;(int);;Argument[0];ReturnValue;value;dfc-generated
    virtual int public_not_final_member_function(int x) {
        return x;
    }

    //heuristic-summary=;NonFinalStruct;false;public_final_member_function;(int);;Argument[0];ReturnValue;taint;df-generated
    //contentbased-summary=;NonFinalStruct;false;public_final_member_function;(int);;Argument[0];ReturnValue;value;dfc-generated
    virtual int public_final_member_function(int x) final {
        return x;
    }

private:
    //No model as private members are excluded from model generation.
    int private_member_function(int x) {
        return x;
    }

protected:
    //No model as protected members are excluded from model generation.
    int protected_member_function(int x) {
        return x;
    }
};

struct FinalStruct final {
    //heuristic-summary=;FinalStruct;false;public_not_final_member_function_2;(int);;Argument[0];ReturnValue;taint;df-generated
    //contentbased-summary=;FinalStruct;false;public_not_final_member_function_2;(int);;Argument[0];ReturnValue;value;dfc-generated
    virtual int public_not_final_member_function_2(int x) {
        return x;
    }

    //heuristic-summary=;FinalStruct;false;public_final_member_function_2;(int);;Argument[0];ReturnValue;taint;df-generated
    //contentbased-summary=;FinalStruct;false;public_final_member_function_2;(int);;Argument[0];ReturnValue;value;dfc-generated
    virtual int public_final_member_function_2(int x) final {
        return x;
    }
};

union U {
    int x, y;
};

//heuristic-summary=;;true;get_x_from_union;(U *);;Argument[0];ReturnValue;taint;df-generated
//heuristic-summary=;;true;get_x_from_union;(U *);;Argument[*0];ReturnValue;taint;df-generated
//contentbased-summary=;;true;get_x_from_union;(U *);;Argument[0];ReturnValue;taint;dfc-generated
//contentbased-summary=;;true;get_x_from_union;(U *);;Argument[*0].Union[*U];ReturnValue;value;dfc-generated
int get_x_from_union(U* u) {
    return u->x;
}

//heuristic-summary=;;true;set_x_in_union;(U *,int);;Argument[1];Argument[*0];taint;df-generated
//contentbased-summary=;;true;set_x_in_union;(U *,int);;Argument[1];Argument[*0].Union[*U];value;dfc-generated
void set_x_in_union(U* u, int x) {
    u->x = x;
}
