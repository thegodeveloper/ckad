# Question 23 - Labels and Annotations - 3%

## Task Definition

- Identify some *Pods* in *Namespace* `sun`.
- Add new label `protected: true` to all *Pods* with an existent label `type: worker` or `type: runner`.
- Also add an annotation `protected: do not delete this pod` to all *Pods* having the new label `protected: true`.

## Solution

<details>
  <summary>Show the solution</summary>

### List Pods in Namespace sun

```shell
k -n sun get pods --show-labels
NAME           READY   STATUS    RESTARTS   AGE     LABELS
0509649a       1/1     Running   0          13m     type=runner,type_old=messenger
0509649b       1/1     Running   0          5m47s   type=worker
1428721e       1/1     Running   0          5m47s   type=worker
1428721f       1/1     Running   0          5m47s   type=worker
43b9a          1/1     Running   0          5m47s   type=test
4c09           1/1     Running   0          5m47s   type=worker
4c35           1/1     Running   0          5m47s   type=worker
4fe4           1/1     Running   0          5m47s   type=worker
5555a          1/1     Running   0          5m47s   type=messenger
86cda          1/1     Running   0          5m47s   type=runner
8d1c           1/1     Running   0          5m47s   type=messenger
a004a          1/1     Running   0          5m46s   type=runner
a94128196      1/1     Running   0          5m46s   type=runner,type_old=messenger
afd79200c56a   1/1     Running   0          5m46s   type=worker
b667           1/1     Running   0          5m46s   type=worker
fdb2           1/1     Running   0          5m46s   type=worker
```

### List Pods with type=runner label

```shell
k -n sun get pods -l type=runner
NAME        READY   STATUS    RESTARTS   AGE
0509649a    1/1     Running   0          14m
86cda       1/1     Running   0          7m9s
a004a       1/1     Running   0          7m8s
a94128196   1/1     Running   0          7m8s
```

### Add the label to Pods with label type runner or worker

```shell
k -n sun label pod -l "type in (worker,runner)" protected=true
pod/0509649a labeled
pod/0509649b labeled
pod/1428721e labeled
pod/1428721f labeled
pod/4c09 labeled
pod/4c35 labeled
pod/4fe4 labeled
pod/86cda labeled
pod/a004a labeled
pod/a94128196 labeled
pod/afd79200c56a labeled
pod/b667 labeled
pod/fdb2 labeled
```

### Show Labels Again

```shell
k -n sun get pod --show-labels
NAME           READY   STATUS    RESTARTS   AGE   LABELS
0509649a       1/1     Running   0          19m   protected=true,type=runner,type_old=messenger
0509649b       1/1     Running   0          11m   protected=true,type=worker
1428721e       1/1     Running   0          11m   protected=true,type=worker
1428721f       1/1     Running   0          11m   protected=true,type=worker
43b9a          1/1     Running   0          11m   type=test
4c09           1/1     Running   0          11m   protected=true,type=worker
4c35           1/1     Running   0          11m   protected=true,type=worker
4fe4           1/1     Running   0          11m   protected=true,type=worker
5555a          1/1     Running   0          11m   type=messenger
86cda          1/1     Running   0          11m   protected=true,type=runner
8d1c           1/1     Running   0          11m   type=messenger
a004a          1/1     Running   0          11m   protected=true,type=runner
a94128196      1/1     Running   0          11m   protected=true,type=runner,type_old=messenger
afd79200c56a   1/1     Running   0          11m   protected=true,type=worker
b667           1/1     Running   0          11m   protected=true,type=worker
fdb2           1/1     Running   0          11m   protected=true,type=worker
```

### Set the annotation using the new label

```shell
k -n sun annotate pod -l protected=true protected="do not delete this pod"
pod/0509649a annotated
pod/0509649b annotated
pod/1428721e annotated
pod/1428721f annotated
pod/4c09 annotated
pod/4c35 annotated
pod/4fe4 annotated
pod/86cda annotated
pod/a004a annotated
pod/a94128196 annotated
pod/afd79200c56a annotated
pod/b667 annotated
pod/fdb2 annotated
```

### Validate the annotation in Pods

```shell
k -n sun describe pod | grep Annotations: -A4
Annotations:      cni.projectcalico.org/containerID: 0b65b12a3ee667eaf602f5b875f1d2c41bb3c1cec96639026c9d9da4dbf4d08a
                  cni.projectcalico.org/podIP: 10.244.88.211/32
                  cni.projectcalico.org/podIPs: 10.244.88.211/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: df8c688f883b2b9f29ab876eda2f4f423735acbb0f41ceb336d1a0155e1317b8
                  cni.projectcalico.org/podIP: 10.244.235.16/32
                  cni.projectcalico.org/podIPs: 10.244.235.16/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: bffd2b26ded077c6de0213d8662e5a99e58e9a2375c5ce33c5789a040d78d21c
                  cni.projectcalico.org/podIP: 10.244.88.212/32
                  cni.projectcalico.org/podIPs: 10.244.88.212/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: 06b5fd4fa68df9014b028418840e3c060f1ce281f2f919817414521e7cec855d
                  cni.projectcalico.org/podIP: 10.244.235.17/32
                  cni.projectcalico.org/podIPs: 10.244.235.17/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: 4e1cd78fa8dc59566a5c80cf5429b46d5eea0ad8f84cc5f5aee90cc73a693f4c
                  cni.projectcalico.org/podIP: 10.244.235.18/32
                  cni.projectcalico.org/podIPs: 10.244.235.18/32
Status:           Running
--
Annotations:      cni.projectcalico.org/containerID: 91b74ec897ebc788cda547d1bdbb6a03e14e9d9cc024185f054144df07eb2821
                  cni.projectcalico.org/podIP: 10.244.88.213/32
                  cni.projectcalico.org/podIPs: 10.244.88.213/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: 47c1ecdee51b6585441bf22edf3efd850b4e419ef6acf9acf3b68d1557690c1a
                  cni.projectcalico.org/podIP: 10.244.88.214/32
                  cni.projectcalico.org/podIPs: 10.244.88.214/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: d35ee064e1508b2f03aa17e6bf90a3004997fe291d67a33d08892dbcf6d55e4d
                  cni.projectcalico.org/podIP: 10.244.235.19/32
                  cni.projectcalico.org/podIPs: 10.244.235.19/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: 70f74dfd4f3792a23c300fc1a67c635689c95fa8de88cc7934954e5eaa032de5
                  cni.projectcalico.org/podIP: 10.244.235.20/32
                  cni.projectcalico.org/podIPs: 10.244.235.20/32
Status:           Running
--
Annotations:      cni.projectcalico.org/containerID: 52456247a2f51bce3626e08060b2dcedd4edd494ee15be06e7069179b0a52d9a
                  cni.projectcalico.org/podIP: 10.244.88.215/32
                  cni.projectcalico.org/podIPs: 10.244.88.215/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: 48c4074b5115ebcd0d3bcb7bcc79de4175eefa198f65691702dab2fb30ae8ea2
                  cni.projectcalico.org/podIP: 10.244.88.216/32
                  cni.projectcalico.org/podIPs: 10.244.88.216/32
Status:           Running
--
Annotations:      cni.projectcalico.org/containerID: 8bd7aa4fb9feb4cf1e5dc218fe7ff928348d5e138c5742f4b38e938deeb037f4
                  cni.projectcalico.org/podIP: 10.244.235.21/32
                  cni.projectcalico.org/podIPs: 10.244.235.21/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: eee5802668a3ee3c5c90685597e8b846f0a178b80f4ae3d8939bf346590cd5ae
                  cni.projectcalico.org/podIP: 10.244.235.22/32
                  cni.projectcalico.org/podIPs: 10.244.235.22/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: b56c651d53aecfec89f1ce6043d3ef5d276f673747734a5af2ebac8150f23a5d
                  cni.projectcalico.org/podIP: 10.244.88.217/32
                  cni.projectcalico.org/podIPs: 10.244.88.217/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: 7150d4649ba8b7f8e2ea20150dfb00fc5167829ccbeb683b5a325ed239e5083c
                  cni.projectcalico.org/podIP: 10.244.235.23/32
                  cni.projectcalico.org/podIPs: 10.244.235.23/32
                  protected: do not delete this pod
--
Annotations:      cni.projectcalico.org/containerID: d580464e957a35b6f3b06784634c6d62c70dfd98d011b1aa788b06282b59c9b4
                  cni.projectcalico.org/podIP: 10.244.88.218/32
                  cni.projectcalico.org/podIPs: 10.244.88.218/32
                  protected: do not delete this pod
```

## Resources

- [Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)
- [Annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)

</details>

<br>
<div style="display: flex; justify-content: space-between;">
  <a href="22-requests-and-limits-serviceaccount.md" style="text-align: left;">&larr; Prev</a>
</div>