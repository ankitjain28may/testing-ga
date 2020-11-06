#!/bin/sh
# set -e
format_response () {
    PAYLOAD="abc.txt"
    DATA=$1
    echo $DATA
    sed -i '1s/^/<details><summary>Show Output<\/summary>\n/' $PAYLOAD
    sed -i '2s/^/\n/' $PAYLOAD
    sed -i '3s/^/```diff\n/' $PAYLOAD
    echo "\`\`\`" >> $PAYLOAD
    echo "</details>" >> $PAYLOAD
    echo $2
    DA=$DATA
    if [ "$2" = true ]; 
    then
        echo "Hello world"
        DA="*$DA*\n**ERROR**"
        sed -i "1s/^/$DA\n/" $PAYLOAD    
    fi
}

send_response () {
    ABC="testing: hello"
    DATA="$ABC\nhello: *world*\nError"
    format_response $DATA true
    PAYLOAD=$(echo '{}' | jq --arg body "`cat ./abc.txt`" '.body = $body')
    URI=https://api.github.com
    API_HEADER="Accept: application/vnd.github.v3+json"
    AUTH_HEADER="Authorization: token $GIT_TOKEN"
    COMMENTS_URL=$(jq -r ".issue.comments_url" "$GITHUB_EVENT_PATH")
    curl -XPOST -s -S -H "${AUTH_HEADER}" -H "${API_HEADER}" --data "$PAYLOAD" "$COMMENTS_URL"
}

echo "GITHUB_EVENT"
echo "$GITHUB_EVENT"
echo "GITHUB_RUN_NUMBER"
echo $GITHUB_RUN_NUMBER
echo "GITHUB_RUN_ID"
echo $GITHUB_RUN_ID
echo "GITHUB_WORKFLOW"
echo $GITHUB_WORKFLOW
echo "GITHUB_ACTION"
echo $GITHUB_ACTION
PAYLOAD=`cat ./abc.txt`

send_response $PAYLOAD
