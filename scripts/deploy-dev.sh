FILE=.build/lambda/PRDStarter/lambda.zip
rm $FILE

docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src" \
     swift-5.8-builder  \
     git config --system --add safe.directory '*'
     
echo "building" && \
docker run \
     --rm \
     --volume "$(pwd)/:/src" \
     --workdir "/src" \
     swift-5.8-builder  \
     git config --system --add safe.directory '*' && swift build --product PRDStarter  -c release

echo "packaging" && \
docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src" \
    swift-5.8-builder  \
    scripts/package.sh PRDStarter > build.log.packaging.txt

if [[ -f "$FILE" ]]; then
    sls deploy
    echo "deployed at " 
    date
    echo "run 'sls logs --stage dev -f v1' for logs"
    say 'deployed dev'
else 
    echo "Deployable File Doesn't exists, check build.log.txt"
fi

