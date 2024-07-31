#!/bin/bash
REPOSITORY="https://github.com/Shreya0401/COL761-DATA-MINING.git"
FOLDER="COL761-DATA-MINING"
# Clone your repository from GitHub using HTTPS link
git clone $REPOSITORY

# Change directory to the cloned repository
cd $FOLDER

# Load module commands here
module load compiler/gcc/9.1.0
module load compiler/python/3.6.0/ucs4/gnu/447
module load pythonpackages/3.6.0/matplotlib/3.0.2/gnu
module load pythonpackages/3.6.0/numpy/1.16.1/gnu
module load pythonpackages/3.6.0/pandas/0.23.4/gnu
module load pythonpackages/3.6.0/scikit-learn/0.21.2/gnu
