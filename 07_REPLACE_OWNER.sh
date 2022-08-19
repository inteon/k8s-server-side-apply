#!/bin/bash

kubectl delete foos --all

clear

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

RESOURCE_VERSION=$(kubectl get foos test01 -o jsonpath="{.metadata.resourceVersion}")

cat << EOF | kubectl replace --field-manager="555" -v0 -f -
apiVersion: example.com/v1
kind: Foo
metadata:
  name: test01
  resourceVersion: "$RESOURCE_VERSION"
  managedFields:
    - "apiVersion": "example.com/v1"
      "fieldsType": "FieldsV1"
      "fieldsV1":
        "f:spec":
          "f:deploymentName": {}
      "manager": "TEST2"
      "operation": "Apply"
      "time": "2022-08-12T14:35:57Z"
spec:
  deploymentName: aap
EOF

echo "---"
kubectl get foo test01 --show-managed-fields -o yaml
echo "---"
