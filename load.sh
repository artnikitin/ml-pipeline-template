#!/bin/bash
git remote rm origin

mkdir static
mkdir static/data

echo ".env/" >> .gitignore
echo ".idea/" >> .gitignore
echo "*.pyc" >> .gitignore
echo "pipeline/" >> .gitignore

pip install dvc
dvc init

cd ..
git clone git@github.com:artnikitin/pipeline.git
cd pipeline
python setup.py install
cd ..

#mv dvc_project_template ${BASH_ARGV[1]}
