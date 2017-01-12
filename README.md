# Slurm Example: Multiple Job Steps in a Job Allocation
This example shows how to run serveral job steps under on job allocation in Slurm, integrated and detached, using a master-slave model.

## Integrated Example
In this example, the master process is submitted as a job, requesting 4 cores. Then the master directly submit 10 slaves in the same job allocation, each trying to run a lapack sample program. `srun` will automatically schedule these slaves so that they run in a batch-by-4 fashion. No overscribing will happen.

### Files
* integrated-mastermind.sh: The main script that starts everything and allocate everything.

### Usage
`sbatch integrated-mastermind.sh`

## Detached Example
In this example, first a container job is submitted, doing nothing but allocating 4 cores. Then, the master process is submitting as a batch job, which will only start after the beginning of the container job. Also, the job id of the container job is passed to the master process. After that, the master process use `srun --jobid=<container-job-id>` to start the slaves in the container. `srun` will automatically schedule these slaves so that they run in a batch-by-4 fashion. No overscribing will happen.

### Files
* submit-detached-mastermind.sh: The script that submits container and master process to Slurm.
* detached-mastermind.sh: The master process script that start and monitor the slaves.
* my-container.sh: This will allocate 4 cores without doing anything else. The resources will be used by the slaves dispatched by `detached-mastermind.sh`

### Usage
`./submit-detached-mastermind.sh`
