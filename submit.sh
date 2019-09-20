#!/usr/bin/env bash

python submit.py
kaggle competitions submit -c name-of-your-competition -f static/data/submission_file_name.csv -m "submission message"