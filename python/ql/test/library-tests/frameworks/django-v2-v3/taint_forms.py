import django.forms


class MyField(django.forms.Field):
    def to_python(self, value):
        ensure_tainted(value)

    def validate(self, value):
        ensure_tainted(value)

    def run_validators(self, value):
        ensure_tainted(value)

    def clean(self, value):
        ensure_tainted(value)

        # # Base definition of `clean` looks like the following, so there is actually
        # # _data flow_ from the methods, but we will ignore for simplicity.
        # value = self.to_python(value)
        # self.validate(value)
        # self.run_validators(value)
        # return value


class MyForm(django.forms.Form):

    foo = MyField()

    def clean(self):
        cleaned_data = super().clean()

        ensure_tainted(
            cleaned_data,
            cleaned_data["key"],
            cleaned_data.get("key"),
        )

        ensure_tainted(
            self.cleaned_data,
            self.cleaned_data["key"],
            self.cleaned_data.get("key"),
        )

    def clean_foo(self):
        # This method is supposed to clean the `foo` field in context of this form.
        ensure_tainted(self.cleaned_data)
