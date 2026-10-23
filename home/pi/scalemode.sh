#!/bin/bash

# Sets how the Vita image is scaled up to the TV and restarts MPV if running.

# Usage: /home/pi/scalemode.sh <lanczos|pixel|catmull|bilinear|nearest>
#   lanczos  - Previous default. Smooth, but soft and heavy on slower Pis.
#   pixel    - Sharp pixels with only the edges smoothed (like sharp-bilinear).
#              Best for keeping the Vita image crisp without blur or uneven pixels.
#   catmull  - Sharper edges than lanczos at a much lower GPU cost.
#   bilinear - Cheapest, softest.
#   nearest  - No smoothing at all. Crisp pixels but uneven at non-integer scales.

MODE=$1

case $MODE in
	lanczos)  NAME="Lanczos" ;;
	pixel)    NAME="Pixel Sharp (Oversample)" ;;
	catmull)  NAME="Sharp (Catmull-Rom)" ;;
	bilinear) NAME="Bilinear" ;;
	nearest)  NAME="Pixel (Nearest)" ;;
	*)
		echo "Usage: $0 <lanczos|pixel|catmull|bilinear|nearest>"
		exit 1
	;;
esac

/home/pi/updateConfig.sh "SCALE_MODE" "$MODE"
/home/pi/notify.sh "Scaling set to $NAME."
sudo bash /home/pi/run.sh &
