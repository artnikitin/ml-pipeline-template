from pipeline.evaluate.validation import compare_scores
import sys

print(compare_scores(old=sys.argv[1], new=sys.argv[2]