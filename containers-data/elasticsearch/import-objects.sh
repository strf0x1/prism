#!/bin/bash
curl -X POST "127.0.0.1:5601/api/saved_objects/_import?overwrite=true" -H 'kbn-xsrf: true' --form file=@index-pattern.ndjson
curl -X POST "127.0.0.1:5601/api/saved_objects/_import?overwrite=true" -H 'kbn-xsrf: true' --form file=@search.ndjson
curl -X POST "127.0.0.1:5601/api/saved_objects/_import?overwrite=true" -H 'kbn-xsrf: true' --form file=@visualization.ndjson
curl -X POST "127.0.0.1:5601/api/saved_objects/_import?overwrite=true" -H 'kbn-xsrf: true' --form file=@dashboard.ndjson
curl -X POST "127.0.0.1:5601/api/saved_objects/_import?overwrite=true" -H 'kbn-xsrf: true' --form file=@query.ndjson
