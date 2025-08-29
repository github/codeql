class C:
    def __getitem__(self, idx):
        if self.idx < 0:
            # BAD: Should raise a KeyError or IndexError instead.
            raise ValueError("Invalid index")
        return self.lookup(idx)
 
