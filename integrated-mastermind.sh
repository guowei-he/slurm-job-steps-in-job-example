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
module load gcc

# Mastermind starts here.
# Print some debug information.
echo "Master mind starts here"

# Loop over all tasks. srun them in the background in-place.
# These 10 tasks will be scheduled in the 4-CPU job allocation
# 1-4 will be finished first. Then 5-8, 9-10
# squeue -j <jobid> -s will gives the job steps running.
# No more than 4 job steps will be running at the same time.
commands_file="my-commands"
nlines=`wc -l ${commands_file} | cut -f1 -d' '`
if [[ ! -d "./tmp" ]]; then
  mkdir ./tmp
fi
for my_task_id in $(seq 1 $nlines);
do
  LIN=$(awk "NR == $my_task_id {print;exit}" $commands_file)
  echo $LIN > ./tmp/$$-$SLURM_JOBID-$my_task_id-cmd.tmp
  srun -n 1 bash ./tmp/$$-$SLURM_JOBID-$my_task_id-cmd.tmp &
done

# Wait all. Examine all job steps if necessary.
FAIL=0
for job in `jobs -p`
do
    wait $job || let "FAIL+=1"
done

echo $FAIL

if [ "$FAIL" == "0" ];
then
echo "YAY!"
else
echo "FAIL! ($FAIL)"
fi
