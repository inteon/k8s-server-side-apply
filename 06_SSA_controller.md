
"extract/modify-in-place/apply": https://kubernetes.io/blog/2021/08/06/server-side-apply-ga/#using-server-side-apply-in-a-controller

"Controllers typically should unconditionally set all the fields they own by setting Force: true in the ApplyOptions":
https://opensource.googleblog.com/2021/10/server-side-apply-in-kubernetes.html#Using%20Server-side%20Apply%20in%20a%20controller:~:text=When%20authoring%20new,place/apply%22%20workflow.

How to handle outdated client resources?
- somehow, we want to be certain that a result based on a newer state is not overwritten by a result based on an older state
- IDEA: use force=false Apply and become coowner of generation field while altering the owned fields
- use different field manager name, for controllers and cause conflicts?
- ideally this does not happen

What is the effect of other patch operations on the managed fields?
