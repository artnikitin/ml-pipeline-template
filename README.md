## Initialization
Create an empty git repo: `git init`. Then install dvc: `pip install dvc`. Initialize dvc: `dvc init`. Add data to dvc: `dvc add static/data/some_data_file.csv`. Commit changes to git.

## Run
Here is an example of a run command:

`$ dvc run -d data/Posts.xml -d code/xml_to_tsv.py -d code/conf.py
      -o data/Posts.tsv python code/xml_to_tsv.py`
      
First you collect all your input files and helpers/configuration modules along with
the function you want to run with `-p` flag.

* `-d data/Posts.xml` -> data file
* `-d code/conf.py` -> configuration file
* `code/xml_to_tsv.py` -> function

Then you specify an output: `-o data/Posts.tsv`.

Finally, you run your function: `python code/xml_to_tsv.py`.

Now you can start adding new blocks to form your pipeline.

`$ dvc run -d data/Posts.tsv -d code/split_train_test.py
        -d code/conf.py
        -o data/Posts-test.tsv -o data/Posts-train.tsv
        python code/split_train_test.py 0.33 20180319`
        
You again collect all your inputs and helpers. Here our input data file
is the output of the last block: `-d data/Posts.tsv`, now having `-d`
flag instead of `-o`. Include the new function: `code/split_train_test.py`
and new outputs: `-o data/Posts-test.tsv -o data/Posts-train.tsv`. Finally
call the function `python code/split_train_test.py 0.33 20180319`.

Go on and create the rest of the pipeline:

`dvc run -d code/featurization.py -d code/conf.py
        -d data/Posts-train.tsv -d data/Posts-test.tsv
        -o data/matrix-train.p -o data/matrix-test.p
        python code/featurization.py`
        
`dvc run -d data/matrix-train.p -d code/train_model.py
        -d code/conf.py -o data/model.p
        python code/train_model.py 20180319`
        
`dvc run -d data/model.p -d data/matrix-test.p
        -d code/evaluate.py -d code/conf.py -M data/eval.txt
        -f Dvcfile
        python code/evaluate.py`

The last command has new output: `-M data/eval.txt`. The `-M` flag
stands for metric and allows dvc to show metrics with a special command:
`dvc metrics show`

The pipeline is done.

## Reproduce

After you finished building a pipeline, you can run it with: `dvc repro`.
It means 'reproduce' and builds a new pipeline each time you make changes to your code.

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
    
## Project structure

Folder `/static` holds static files, including data files stored in `static/data` subdirectory.
Files for pipeline:
* load.py
* clean.py
* transform.py
* model.py
* evaluate.py

Initialize template with `./load.sh`. Add data files and run `./dvc.sh` to install and initialize dvc.

Paths to intermediate data files are stored in `conf.py` and imported from this module in pipeline modules.
Also don't forget to include `conf.py` in the `dvc run` pipeline blocks.

Functions are written using `conf.py` for importing input data files and usually return `None`: they write resulting files to disk.
The output paths are also stored and imported from `conf.py`.

Function may or may not take parameters through argv. You can specify these inside the function.
