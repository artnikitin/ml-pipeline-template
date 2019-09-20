#!/bin/bash

echo ".env/" >> .gitignore
echo ".idea/" >> .gitignore
echo "*.pyc" >> .gitignore

pip install dvc
dvc init
