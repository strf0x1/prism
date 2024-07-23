#!/bin/bash
docker build -t yara-x-container .
mkdir rules
mkdir malware
wget https://github.com/YARAHQ/yara-forge/releases/latest/download/yara-forge-rules-full.zip
unzip yara-forge-rules-full.zip
mv packages/full/yara-rules-full.yar rules/
rm -rf packages/
rm -f yara-forge-rules-full.zip
