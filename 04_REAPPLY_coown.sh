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

echo "HTTP PATCH -> tries to own all the provided fields (test2, Apply)"
echo "this causes no conflicts since the value does not change, resulting in a coowned field"

cat << EOF | kubectl apply --server-side --field-manager=test2 -v0 -f -
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
echo "this results in removing ownership of deploymentName for test"
echo "the value of deploymentName is however not reset to an empty string, since the field is still owned by test2"

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

source "./00_press_key.sh"

echo "HTTP PATCH -> tries to own all the provided fields (test2, Apply)"
echo "this results in removing ownership of deploymentName for test2"
echo "the value of deploymentName now reset to an empty string, since test2 was the only owner of the field"

cat << EOF | kubectl apply --server-side --field-manager=test2 -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
spec:
EOF

echo "---"
kubectl get foo test01 --show-managed-fields -o yaml
echo "---"
