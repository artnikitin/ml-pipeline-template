## About

A data science project structure, which makes advantage of the [DVC
](https://dvc.org) remote control system for machine learning. 
This is just one of the many ways it could be done. Feel free to contribute and share ideas.

## How is it organized?

The structure is inspired by the MVC architecture, used in web development, but
with a data science twick. Data files are stored in `/static/data` folder. You may add 
other static files, such as images or text files in `/static/img` folder.

The code is split into separate modules, that handle different tasks. 

| Module       | Function       
| ------------- |:-------------:|
| `load.py`     | download, unzip, convert data |
| `clean.py`    | clean data  |
| `transform.py`| change data, split for validation |
| `feature.py` | create and select new features   |
|  `model.py`  | train the model |
|  `tune.py`   | tune the model |
| `evaluate.py` | save evaluations to metrics file |    


The intermediate outputs of
these modules are stored in `static/data` folder as `.pkl` or `.csv` files. These modules are 
connected into a pipeline via `dvc` commands, an example of which is stored in `pipeline.sh` file.
To initialize your pipeline, edit the commands, `chmod +x pipeline.sh` and run the script once `./pipeline.sh`.

The `settings.py` file plays a role of a controller and has all paths to intermediate files, which are then used
by individual modules. This file is always included in all of the `dvc` pipeline commands. 

## Initialize
Create an empty git repo: `git init`. Then install dvc: `pip install dvc`. Initialize dvc: `dvc init`. Add data to dvc: `dvc add static/data/some_data_file.csv`. Commit changes to git.

## Run
Here is an example of a run command:

`$ dvc run -f load.dvc \
        -d static/data/train_features.csv.zip \
        -d static/data/train_targets.csv.zip \
        -d static/data/test_features.csv.zip \
        -d settings.py -d load.py \
        -o static/data/train_features.csv \
        -o static/data/train_targets.csv \
        -o static/data/test_features.csv \
        python load.py`
      
First you collect all your input files and helper and settings modules along with
the function you want to run with `-d` flags.

* `-f load.dvc` -> name of the pipeline block
* `-d static/data/train_features.csv.zip` -> data file
* `-d settings.py` -> configuration file
* `-d load.py` -> function

Then you specify an output: `-o static/data/train_features.csv`.

Finally, you run your function: `python load.py`. At this point a `.dvc` file 
will be created, which describes the pipeline block. It contains pointers to other
pipeline stages. Read more in the dvc [documentation](https://dvc.org/doc/get-started).

Now you can start adding new blocks to form your pipeline.

`$ dvc run -f train_test_split.dvc \
        -d static/data/train_features.csv \
        -d static/data/train_targets.csv \
        -d settings.py -d transform.py \
        -o static/data/X_train.pkl \
        -o static/data/X_valid.pkl \
        -o static/data/y_train.pkl \
        -o static/data/y_valid.pkl \
        python transform.py`
        
You again collect all your inputs and helpers. Here our input data files
is the outputs of the last block: `-d static/data/train_features.csv`, now having `-d`
flag instead of `-o`. Include the new function: `python transform.py`
and new outputs: `-o static/data/X_train.pkl`. Finally
call the function `python transform.py`. You can pass arguments directly to the functions
using `argv` parameters like `python transform.py 17 20156453`.

Go on and create the rest of the pipeline:

`dvc run -f model.dvc \
        -d static/data/X_train.pkl \
        -d static/data/y_train.pkl \
        -d settings.py -d model.py \
        -o static/data/model.pkl \
        python model.py`

`dvc run -f Dvcfile \
        -d static/data/X_valid.pkl \
        -d static/data/y_valid.pkl \
        -d static/data/model.pkl \
        -M static/data/eval.json \
        -d settings.py -d evaluate.py \
        python evaluate.py`

The last command has new output: `-M data/eval.txt`. The `-M` flag
stands for metric and allows dvc to show metrics with a special command:
`dvc metrics show`. Also it has a special name `-f Dvcfile`. Always name your
last pipeline block as `Dvcfile`, so `dvc` knows where's the end pointer.

The pipeline is done.

## Reproduce

After you finished building a pipeline, you can run it with: `dvc repro`.
It means 'reproduce' and runs the pipeline each time you make changes to your code, 
but only from the module, in which you made changes.

Possible workflow:

* Make new branch: `git checkout -b name`
* Change some code
* Run `dvc repro`
* Check metrics: `dvc metrics show -a`
    * If valuable results: commit changes, return to master: `git checkout master`, `dvc checkout`
    * Else: delete branch
* Make new branch: `git checkout -b name`
* Repeat all the steps
    * If the previous branch depends on current one, merge the last one into new one: `git merge name`
    * If merge conflicts: replace checksums with empty string
    * Run `dvc repro`
    * Check metrics: `dvc metrics show -a`
        * If better, merge into master: `git checkout master`, `dvc checkout`, `git merge name`
    
## Submit

Submission code can be placed in `submit.py` module. By default it is excluded from the 
pipeline, because you won't need to run it every time. Instead use `submit.sh` script to 
generate submission csv file and upload it to Kaggle.

    