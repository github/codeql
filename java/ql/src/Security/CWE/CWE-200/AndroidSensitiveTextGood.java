TextView pwView = findViewById(R.id.pw_text);
pwView.setVisibility(View.INVISIBLE);
pwView.setText("Your password is: " + password);

Button showButton = findViewById(R.id.show_pw_button);
showButton.setOnClickListener(new View.OnClickListener() {
    public void onClick(View v) {
      pwView.setVisibility(View.VISIBLE);
    }
});
