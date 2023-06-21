FILE=.build/lambda/AnyStoreLambda/lambda.zip
rm $FILE

# > build.log.txt && \

echo "building" && \
docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src/" \
     swift-5.5-builder  \
     swift build --product AnyStoreLambda -c release 
echo "packaging" && \
docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    swift-5.5-builder  \
    scripts/package.sh AnyStoreLambda > build.log.packaging.txt

if [[ -f "$FILE" ]]; then
    sls deploy --stage prod
    echo "deployed at " 
    date
    echo "run 'sls logs --stage prod -f v1' for logs"
    say 'deployed prod'
else 
    echo "Deployable File Doesn't exists, check build.log.txt"
fi

