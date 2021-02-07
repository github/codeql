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

import { Form } from 'react-final-form'

const App = () => (
  <Form
    onSubmit={async values => {
      $("#id").html(values.stooge); // NOT OK
    }}
    initialValues={{ stooge: 'larry', employed: false }}
    render={({ handleSubmit, form, submitting, pristine, values }) => (
      <form onSubmit={handleSubmit}>
        <input type="text" name="stooge"></input>
      </form>
    )}
  />
)