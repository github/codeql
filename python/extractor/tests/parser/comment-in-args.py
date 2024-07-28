"""
At the time this test was added, when either comment 2 or comment 3 was present, this
would cause the TSG parser to have an error.
"""

# comment 0
print(
    # comment 1
    (
        # comment 2
        1
        # comment 3
)
# comment 4
)
