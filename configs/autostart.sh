#!/bin/bash
service nginx start
service ssh start
/root/android_config.sh
/opt/buildAgent/bin/agent.sh start

