#!/bin/bash
#
# This script first submit a container job, then a detached mastermind.
#

main() {
  local container_job_script="my-container.sh"
  local container_job_id=`sbatch ${container_job_script} | cut -d ' ' -f 4`
  local mastermind_job_script="detached-mastermind.sh"
  sbatch -d --after:${container_job_id} ${mastermind_job_script} ${container_job_id}
}

main "$@"
