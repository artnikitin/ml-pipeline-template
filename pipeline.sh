#!/usr/bin/env bash

dvc run -f load.dvc \
        -d static/data/train_features.csv.zip \
        -d static/data/train_targets.csv.zip \
        -d static/data/test_features.csv.zip \
        -d settings.py -d load.py \
        -o static/data/train_features.csv \
        -o static/data/train_targets.csv \
        -o static/data/test_features.csv \
        python load.py

dvc run -f train_test_split.dvc \
        -d static/data/train_features.csv \
        -d static/data/train_targets.csv \
        -d settings.py -d transform.py \
        -o static/data/X_train.pkl \
        -o static/data/X_valid.pkl \
        -o static/data/y_train.pkl \
        -o static/data/y_valid.pkl \
        python transform.py

dvc run -f model.dvc \
        -d static/data/X_train.pkl \
        -d static/data/y_train.pkl \
        -d settings.py -d model.py \
        -o static/data/model.pkl \
        python model.py

dvc run -f Dvcfile \
        -d static/data/X_valid.pkl \
        -d static/data/y_valid.pkl \
        -d static/data/model.pkl \
        -M static/data/eval.json \
        -d settings.py -d evaluate.py \
        python evaluate.py