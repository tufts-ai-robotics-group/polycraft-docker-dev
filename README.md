# polycraft-docker-dev

Docker for polycraft development.

## Installation

1. Request access to the GitHub tufts-ai-robotics-group and Tufts HRILab GitLab ADE repository.
1. Use a single SSH key for GitHub and the Tufts HRILab GitLab.
1. Copy this SSH key into the root of this repository as "id_rsa".
1. Build the docker by running ```bash docker_build.sh``` from the repo root.

## Usage

Launch the docker by running ```bash docker_launch.sh``` from the repo root.
Inside the docker, run a script in the current folder to launch the desired application. 
