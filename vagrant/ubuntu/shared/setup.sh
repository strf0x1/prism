#!/bin/bash
apt install /vagrant_data/auditbeat-7.17.20-amd64.deb -y
cp /vagrant_data/auditbeat.yml /etc/auditbeat/auditbeat.yml
cp /vagrant_data/default.conf /etc/auditbeat/audit.rules.d/default.conf
systemctl enable auditbeat --now