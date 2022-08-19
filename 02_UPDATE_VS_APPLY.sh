#!/bin/bash

kubectl delete foos --all

clear

echo "HTTP POST -> all fields are owned by (test, Update)"

cat << EOF | kubectl create --field-manager=test -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
spec:
  deploymentName: aa
EOF

echo "---"
kubectl get foo test01 --show-managed-fields -o yaml
echo "---"

source "./00_press_key.sh"

echo "HTTP PATCH -> tries to own all the provided fields (test, Apply)"
echo "the patch causes a conflict since POST/PUT and PATCH do not mix"

cat << EOF | kubectl apply --server-side --field-manager=test -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
spec:
  deploymentName: aad
EOF
