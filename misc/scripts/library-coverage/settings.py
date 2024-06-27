import sys

generated_output_rst = "framework-coverage-{language}.rst"
generated_output_csv = "framework-coverage-{language}.csv"

# The CI job checks out the codebase to a subfolder
data_prefix = ""

index = 1
if sys.argv[0].endswith("generate-report.py"):
    index = 3

if len(sys.argv) > index:
    data_prefix = sys.argv[index] + "/"

documentation_folder_no_prefix = "{language}/documentation/library-coverage/"
documentation_folder = data_prefix + documentation_folder_no_prefix

output_rst_file_name = "coverage.rst"
output_csv_file_name = "coverage.csv"
repo_output_rst = documentation_folder + output_rst_file_name
repo_output_csv = documentation_folder + output_csv_file_name

languages = ['java', 'csharp', 'go']
