import sys
import compare


folder1 = sys.argv[1]
folder2 = sys.argv[2]
diff_file = sys.argv[3]

compare.compare_folders(folder1, folder2, diff_file)
