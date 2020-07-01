#!/bin/sh

format_response () {
    PAYLOAD=$1
    DATA=$2
    echo $PAYLOAD
    echo $DATA
    sed -i "1s/^/$DATA\n/" $PAYLOAD
    sed -i '2s/^/<details><summary>Show Output<\/summary>\n/' $PAYLOAD
    sed -i '3s/^/\n/' $PAYLOAD
    sed -i '4s/^/```diff\n/' $PAYLOAD
    echo "\`\`\`" >> $PAYLOAD
    echo "</details>" >> $PAYLOAD
    return $PAYLOAD
}

send_response () {
    FORMAT=$(format_response $1 "test")
    PAYLOAD=$(echo '{}' | jq --arg body "`cat $FORMAT`" '.body = $body')
    URI=https://api.github.com
    API_HEADER="Accept: application/vnd.github.v3+json"
    AUTH_HEADER="Authorization: token $GIT_TOKEN"
    COMMENTS_URL=$(jq -r ".issue.comments_url" "$GITHUB_EVENT_PATH")
    curl -XPOST -s -S -H "${AUTH_HEADER}" -H "${API_HEADER}" --data "$PAYLOAD" "$COMMENTS_URL"
}

PAYLOAD=`cat abc.txt`
send_response $PAYLOAD