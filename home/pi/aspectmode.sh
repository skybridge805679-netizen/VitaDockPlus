#!/bin/bash

# Sets how the Vita image fits the TV and restarts MPV if running.

# Usage: /home/pi/aspectmode.sh <fit|stretch|crop>
#   fit     - Keep the Vita aspect ratio, black bars where needed. (default)
#   stretch - Fill the whole screen, ignoring aspect ratio.
#   crop    - Keep the aspect ratio and fill the screen, cutting off the overflow.

MODE=$1

case $MODE in
	fit)     NAME="Fit" ;;
	stretch) NAME="Stretch" ;;
	crop)    NAME="Crop to fill" ;;
	*)
		echo "Usage: $0 <fit|stretch|crop>"
		exit 1
	;;
esac

/home/pi/updateConfig.sh "ASPECT_MODE" "$MODE"
/home/pi/notify.sh "Aspect ratio set to $NAME."
sudo bash /home/pi/run.sh &
