import sys

generated_output_rst = "flow-model-coverage-{language}.rst"
generated_output_csv = "flow-model-coverage-{language}.csv"

# The CI job checks out the codebase to a subfolder
data_prefix = ""

index = 1
if sys.argv[0].endswith("generate-report.py"):
    index = 3

if len(sys.argv) > index:
    data_prefix = sys.argv[index] + "/"

documentation_folder = data_prefix + \
    "{language}/documentation/library-coverage/"

repo_output_rst = documentation_folder + "flow-model-coverage.rst"
repo_output_csv = documentation_folder + "flow-model-coverage.csv"
