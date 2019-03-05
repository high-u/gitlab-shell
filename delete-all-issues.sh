#!/bin/bash
#
# Usage
# ./delete-all-issues.sh https://example.gitlab.com <your_access_token>
#
gitlab_url="${1}/api/v4"
private_token=${2}
json=$(curl --header "PRIVATE-TOKEN: ${private_token}" "${gitlab_url}/issues?per_page=100&page=1")
len=$(echo $json | jq length)
for i in $( seq 0 $(($len - 1)) ); do
  row=$(echo $json | jq .[$i])
  iid=$(echo $row | jq .iid)
  project_id=$(echo $row | jq .project_id)
  title=$(echo $row | jq .title)
  curl --request DELETE --header "PRIVATE-TOKEN: ${private_token}" "${gitlab_url}/projects/${project_id}/issues/${iid}"
  echo "Deleted ${title}"
done
