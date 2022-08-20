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
);

function plainSubmit(e) {
    $("#id").html(e.target.value); // NOT OK
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
  const onSubmit = (data) => {
    $("#id").html(data.name); // NOT OK 
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
          const values = getValues(); // { test: "test-input", test1: "test1-input" }
          $("#id").html(values.name); // NOT OK
        }}
      >
      </button>
    </form>
  );
}

function vanillaJS() {
    document.querySelector("form.myform").addEventListener("submit", e => {
        $("#id").html(e.target.value); // NOT OK
    });

    document.querySelector("form.myform").onsubmit = function (e) {
        $("#id").html(e.target.value); // NOT OK
    }
}