#!/usr/bin/env bash

latest_uri=$(curl -s http://www-eu.apache.org/dist/spark/ | grep -Eoi '<a [^>]+>' | grep -Eo 'spark[^\"]+' | tail -n 1)
latest_uri="http://www-eu.apache.org/dist/spark/${latest_uri}"
latest_version=$(curl -s "${latest_uri}" | grep -Eoi '<a [^>]+>' | grep -Eo 'spark[^\"]+-bin-hadoop\d\.\d\.tgz' | tail -n 1)
wget -P ./opt "${latest_uri}${latest_version}" 
