#!/bin/bash
#SBATCH -p serial
# Set number of tasks to run
#SBATCH --ntasks=4
# Set number of cores per task (default is 1)
#SBATCH --cpus-per-task=1
# Walltime format hh:mm:ss
#SBATCH --time=00:30:00
# Output and error files
#SBATCH -o job.%J.out
#SBATCH -e job.%J.err

# **** Put all #SBATCH directives above this line! ****
# **** Otherwise they will not be in effective! ****
#
# **** Actual commands start here ****
# Load modules here (safety measure)
module purge

# You may need to load gcc here .. This is application specific
# module load gcc 

# Just sleep and wait for task
sleep 999999999
