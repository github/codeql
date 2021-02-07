import React from 'react';
import { Formik, withFormik, useFormikContext } from 'formik';

const FormikBasic = () => (
    <div>
        <Formik
            initialValues={{ email: '', password: '' }}
            validate={values => {
                $("#id").html(values.foo); // NOT OK
            }}
            onSubmit={(values, { setSubmitting }) => {
                $("#id").html(values.bar); // NOT OK
            }}
        >
            {(inputs) => (
                <form onSubmit={handleSubmit}></form>
            )}
        </Formik>
    </div>
);

const FormikEnhanced = withFormik({
    mapPropsToValues: () => ({ name: '' }),
    validate: values => {
        $("#id").html(values.email); // NOT OK
    },

    handleSubmit: (values, { setSubmitting }) => {
        $("#id").html(values.email); // NOT OK
    }
})(MyForm);

(function () {
    const { values, submitForm } = useFormikContext();
    $("#id").html(values.email); // NOT OK

    $("#id").html(submitForm.email); // OK 
})

