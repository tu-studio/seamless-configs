#!/bin/bash

TU_STUDIO="/Users/manolo/Documents/Programming/projects/tu-studio"

SEAMLESS_CONFIGS="$TU_STUDIO/seamless-configs"
CONFIG="$SEAMLESS_CONFIGS/HUFO/showcontrol/config"
READABLE_SCHEDULES="$SEAMLESS_CONFIGS/HUFO/showcontrol/readable_schedules"

SHOWCONTROL="$TU_STUDIO/showcontrol"
GENERATOR="$SHOWCONTROL/venv/bin/showcontrol_schedule_generator"

$GENERATOR -c $CONFIG -o $CONFIG/schedule.yml -r $READABLE_SCHEDULES
