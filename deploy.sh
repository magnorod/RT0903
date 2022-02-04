#!/bin/bash

deployment_file="deployment-motd.yml"

hash=$(git log | head -n 1 | cut -d ' ' -f2)
if [ $? -ne 0 ]
then
    exit 1
else
    echo "hash recupéré"
fi

docker build -t magnorod/motd-api-image:$hash .
if [ $? -ne 0 ]
then
    exit 1
else
    echo "image Docker créée"
fi

docker push magnorod/motd-api-image:$hash
if [ $? -ne 0 ]
then
    exit 1
else
    echo "image Docker push"
fi

sed -i "s/image:.*/image: magnorod\/motd-api-image:$hash/g" $deployment_file
if [ $? -ne 0 ]
then
    exit 1
else
    echo "deployment mis à jour"
fi



kubectl apply -f service.yml
if [ $? -ne 0 ]
then
    exit 1
else
    echo "my-service lance"
fi


kubectl apply -f service-redis.yml
if [ $? -ne 0 ]
then
    exit 1
else
    echo "service redis lance"
fi

kubectl delete deploy motd-deployment
if [ $? -ne 0 ]
then
    exit 1
else
    echo "deployment supprimé"
fi

kubectl apply -f deployment-motd.yml
if [ $? -ne 0 ]
then
    exit 1
else
    echo "deployment lancé"
fi

kubectl delete statefulset statefulset-redis
if [ $? -ne 0 ]
then
    exit 1
else
    echo "statefulset supprimé"
fi

kubectl apply -f statefulset.yml
if [ $? -ne 0 ]
then
    exit 1
else
    echo "statefulset lancé"
fi

exit 0