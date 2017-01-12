#!/bin/bash
#SBATCH -p serial
# Set number of tasks to run
#SBATCH --ntasks=1
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

# Get container job id from argument
container_job_id="$1"

# Loop over all tasks. srun dispatch them to the container job.
# These tasks will be scheduled within the container job, with 4 cores.
# squeue -j <jobid> -s will show the running job steps.
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
  srun -n 1 --jobid=${container_job_id} bash ./tmp/$$-$SLURM_JOBID-$my_task_id-cmd.tmp &
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
