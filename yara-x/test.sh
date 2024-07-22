#!/bin/bash
# -w ignore warnings, dupe import issues might be yara-x issue so should try with reg yara on same ruleset. 
# time on m2 mac was about 3:30 for msfvenom reverse_tcp payload with YARA Forge full
# should test CORE and EXTENDED YARA Forge files to see speed vs. effectiveness
# https://yarahq.github.io/
docker run -v ${PWD}/malware:/malware -v ${PWD}/rules:/rules yara-x scan /rules /malware -w
