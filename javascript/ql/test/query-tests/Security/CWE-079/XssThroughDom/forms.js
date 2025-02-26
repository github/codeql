import React from 'react';
import { Formik, withFormik, useFormikContext } from 'formik';

const FormikBasic = () => (
    <div>
        <Formik
            initialValues={{ email: '', password: '' }}
            validate={values => { // $ Source
                $("#id").html(values.foo); // $ Alert
            }}
            onSubmit={(values, { setSubmitting }) => { // $ Source
                $("#id").html(values.bar); // $ Alert
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
    validate: values => { // $ Source
        $("#id").html(values.email); // $ Alert
    },

    handleSubmit: (values, { setSubmitting }) => { // $ Source
        $("#id").html(values.email); // $ Alert
    }
})(MyForm);

(function () {
    const { values, submitForm } = useFormikContext(); // $ Source
    $("#id").html(values.email); // $ Alert

    $("#id").html(submitForm.email);
})

import { Form } from 'react-final-form'

const App = () => (
  <Form
    onSubmit={async values => { // $ Source
      $("#id").html(values.stooge); // $ Alert
    }}
    initialValues={{ stooge: 'larry', employed: false }}
    render={({ handleSubmit, form, submitting, pristine, values }) => (
      <form onSubmit={handleSubmit}>
        <input type="text" name="stooge"></input>
      </form>
    )}
  />
);

function plainSubmit(e) {
    $("#id").html(e.target.value); // $ Alert
}

const plainReact = () => (
    <form onSubmit={e => plainSubmit(e)}>
        <input type="text" value={this.state.value} onChange={this.handleChange} />
        <input type="submit" value="Submit" />
    </form>
)

import { useForm } from 'react-hook-form';

function HookForm() {
  const { register, handleSubmit, errors } = useForm(); // initialize the hook
  const onSubmit = (data) => { // $ Source
    $("#id").html(data.name); // $ Alert
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
        <input name="name" ref={register({ required: true })} />
        <input type="submit" />
    </form>
  );
}

function HookForm2() {
  const { register, getValues } = useForm();
  
  return (
    <form>
      <input name="name" ref={register} />
      <button
        type="button"
        onClick={() => {
          const values = getValues(); // $ Source - { test: "test-input", test1: "test1-input" }
          $("#id").html(values.name); // $ Alert
        }}
      >
      </button>
    </form>
  );
}

function vanillaJS() {
    document.querySelector("form.myform").addEventListener("submit", e => {
        $("#id").html(e.target.value); // $ Alert
    });

    document.querySelector("form.myform").onsubmit = function (e) {
        $("#id").html(e.target.value); // $ Alert
    }
}