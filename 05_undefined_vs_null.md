# serialised fooApplyConfig (does not include null-valued pointer fields)
{
   "apiVersion":"example.com/v1",
   "kind":"Foo",
   "metadata":{
      "name":"test01",
      "namespace":"default"
   }
}

# serialised foo (has default values for non-pointer fields)
{
   "apiVersion":"example.com/v1",
   "kind":"Foo",
   "metadata":{
      "name":"test01",
      "namespace":"default"
   },
   "spec":{
      "replicas":0,
      "deploymentName":"",
   }
}
