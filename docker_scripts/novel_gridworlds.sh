# set Pipenv to use in this script
export PIPENV_PIPFILE=${CODE_DIR}/Pipfile
# run NovelGridworlds game
cd ${CODE_DIR}/polycraft_tufts/envs/novel_gridworlds_tests
pipenv run python3 socket_env_polycraft.py &
# run visual novelty detector
cd ${CODE_DIR}/polycraft_tufts/Novelty_Detectors/polycraft_detector/
pipenv run python server.py &
# run ADE agent
cd ${CODE_DIR}/ade
ant launch -Dmain=com.config.polycraft.PolycraftAgent -Dargs="-gameport 9000 -vision"
