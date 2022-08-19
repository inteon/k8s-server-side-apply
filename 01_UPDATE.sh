#!/bin/bash

kubectl delete foos --all

clear

# kubectl CREATE = HTTP POST = SSA Update
# kubectl REPLACE = HTTP PUT = SSA Update
# kubectl APPLY = HTTP PATCH = SSA Apply

echo "HTTP POST -> all fields are owned by (creator, Update)"

cat << EOF | kubectl create --field-manager=creator -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
spec:
  replicas: 5
  deploymentName: aa
EOF

echo "---"
kubectl get foo test01 --show-managed-fields -o yaml
echo "---"

source "./00_press_key.sh"

echo "HTTP PUT -> all ALTERED fields are owned by (updater, Update)"
echo "a PUT operation checks the resource version to detect outdated client resources"
echo "a PUT operation does never trigger a field manager conflict"

cat << EOF | kubectl replace --field-manager=updater -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
spec:
  replicas: 10
  deploymentName: aa
EOF

echo "---"
kubectl get foo test01 --show-managed-fields -o yaml
echo "---"
