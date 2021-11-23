# Tournament Ends if Total Step Cost exceeds 1M - not easy for 5 minute games ##
MAX_STEP_COST = 1000000
# For Windows - (YMMV):
PAL_COMMAND = "./gradlew runclient"
# For Systems with Graphics Cards, Use this instead
# PAL_COMMAND_UNIX = "./gradlew runclient"
# requires xvfb to be installed - see installation instructions
# PAL_COMMAND_UNIX = "xvfb-run -s '-screen 0 1280x1024x24' ./gradlew --no-daemon --stacktrace runclient"
# -c 1000 -t "POGO_L00_T01_S01_X0100_A_U9999_V0200FPS_011022" -g "../pogo_100_PN" -a "BASELINE_POGOPLAN_SPEEDTEST" -d "agents/pogo_stick_planner_agent/" -    x "python 1_python_miner_PLANNER_FF_1_vDN_EDITS.py"
## CONFIGURABLE ##################################### CLI Commands ####################################
MAX_TIME = 1500                                     # change using -i <time>
MAX_TOURN_TIME = 2880                               # change using -m <minutes> 48 hours default
TOURNAMENT_ID = "POGO_L00_T01_S01_X0100_A_U9999"    # change using -t <tournament_name>
AGENT_DIRECTORY = "/home/docker/code/ade"           # change using -d <agent/start/script/folder/>
AGENT_COMMAND = "ant launch -Dmain=com.config.polycraft.PolycraftAgent -Dargs=\"-gameport 9000 -vision\""              # change using -x <windows cmd to launch script - Windows OS only>
AGENT_COMMAND_UNIX = "ant launch -Dmain=com.config.polycraft.PolycraftAgent -Dargs=\"-gameport 9000 -vision\""              # change using -x <windows cmd to launch script - Windows OS only>
AGENT_ID = f"MY_AGENT_ID"                           # change using -a <agent_name>
GAME_COUNT = 100                                    # change using -c <count>
GAMES_FOLDER = "../pogo_100_PN"                     # change using -g <rel_path/to/games/folder>
SPEED = 20                                          # change using -s <ticks_per_second>
