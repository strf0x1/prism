# prism
what:
rapid exploit development and detection engineering stack
  
why:
 exploit development and writing detections are time consuming, and replicating the target environment could mean you have to burn it down and rebuild multiple environments. apply rapid development and CI/CD principles:
- rapid end-to-end payload prototyping and consistency with a container-based stack
- post-compilation static analysis with yara, strings, strace. obfuscation diffing
- detection engineering with ElasticSearch, Kibana and Auditbeat
- stage 1 -> stage 2 analysis with Arkime, Suricata and Auditbeat Socket module
  
todo:
- arkime ui broken but getting events in elastic
- need elasticsearch template mappings/dashboards/ILM
- implement a generic compilation interface, parameterize build steps and target compilation container
- implement static analysis workflow
- implement C2 Frameworks and Teamserver containers. http server for payload hosting
- react framework ui for rapid code pasting -> report workflow.