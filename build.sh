#!/bin/bash

docker build -t binwalk .

# Run using the following command
#docker run --rm -v $(pwd):/root/extracted/ binwalk <firmware image>.bin