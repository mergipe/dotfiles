#!/bin/bash

spotify_sink=$(pacmd list-sink-inputs | tr '\n' '\r' | perl -pe 's/ *index: ([0-9]+).+?application\.process\.binary = "([^\r]+)"\r.+?(?=index:|$)/\2 : \1\r/g' | tr '\r' '\n' | awk '/spotify/{print $3}')

pactl set-sink-input-volume $spotify_sink -5%
