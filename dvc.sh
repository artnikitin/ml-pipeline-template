#!/usr/bin/env bash

pip install dvc
dvc init
dvc add static/data/*
git add .
git commit -m "add dataset"

