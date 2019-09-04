#!/bin/bash
mkdir static
mkdir static/data
touch conf.py load.py clean.py transform.py feature.py model.py evaluate.py

git clone git@github.com:artnikitin/pipeline.git
cd pipeline
python setup.py install
cd ..

echo ".env/" >> .gitignore
echo ".idea/" >> .gitignore
echo "*.pyc" >> .gitignore

pip install dvc
dvc init