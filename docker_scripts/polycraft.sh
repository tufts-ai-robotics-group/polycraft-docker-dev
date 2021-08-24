# set Pipenv to use in this script
export PIPENV_PIPFILE=${CODE_DIR}/Pipfile
# run Polycraft, with config.py set to launch ADE agent
cd ${CODE_DIR}/PAL/PolycraftAIGym
pipenv run python3 LaunchTournament.py
