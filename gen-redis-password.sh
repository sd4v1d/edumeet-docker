#!/bin/bash
REDIS_PASSWORD=$(openssl rand -base64 32)
echo "Generated Redis password: ${REDIS_PASSWORD}"
# escape sed delimiter (/)
REDIS_PASSWORD=${REDIS_PASSWORD//\//\\/}

echo "setting Redis password in ./configs/redis/redis.conf"
sed -i -r "s/^requirepass\ .*/requirepass\ ${REDIS_PASSWORD}/" configs/redis/redis.conf

for fileType in {json,yaml,toml}
do
  if [ -f ./configs/server/config.${fileType} ]
  then
    case ${fileType} in
      json)
        REGEX='^.*\"password\"\ :'
        ;;
      yaml)
        REGEX='^.*password:'
        ;;
      toml)
        REGEX='^.*password\ ='
        ;;
    esac
    echo "setting Redis password in ./configs/server/config.${fileType}"
    sed -i -r "s/(${REGEX}).*/\1 \"${REDIS_PASSWORD}\"/" configs/server/config.${fileType}
  fi
done

