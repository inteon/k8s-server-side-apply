#!/bin/bash

kubectl delete foos --all

clear

echo "HTTP PATCH -> tries to own all the provided fields (test, Apply)"

cat << EOF | kubectl apply --server-side --field-manager=test -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
spec:
  deploymentName: test
EOF

echo "---"
kubectl get foo test01 --show-managed-fields -o yaml
echo "---"

source "./00_press_key.sh"

echo "HTTP PATCH -> tries to own all the provided fields (test, Apply)"
echo "since this patch does not contain a value for the deploymentName field, ownership of that field is lost"
echo "this also results in defaulting the value of deploymentName to an empty string"

cat << EOF | kubectl apply --server-side --field-manager=test --validate=false -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
spec:
  replicas: 5
EOF

echo "---"
kubectl get foo test01 --show-managed-fields -o yaml
echo "---"
