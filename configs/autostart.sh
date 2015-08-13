#!/bin/bash
service nginx start
service ssh start
/opt/buildAgent/bin/agent.sh start
