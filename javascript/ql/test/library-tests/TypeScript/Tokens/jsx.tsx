render(<div>&#10003;</div>);
render(<Trans>See #{tag} posts</Trans>);
render(<div>// not a comment /* neither is this */</div>);
render(<div>{/* real JSX comment */ tag}</div>);
render(<><span>#</span><span>{/a#/.test(tag) ? `#${tag}` : tag >= 1}</span></>);
render(<div title="trailing \">#</div>);
render(<name-with-dashes data-value="#">{tag}</name-with-dashes>);
render(<div>line one
  # line two
</div>);

