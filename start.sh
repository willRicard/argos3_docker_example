#!/bin/bash
cd /root/argos3-webviz/client && python3 -m http.server &
cd /root/examples && mkdir build
cd /root/examples/build && cmake ..
cd /root/examples/build && cmake --build .
cd /root/examples && argos3 -c experiments/crazyflie_sensing.argos
