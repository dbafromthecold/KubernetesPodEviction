# Kubernetes Pod Eviction

---

## Andrew Pruski

### SQL Server DBA, Microsoft Data Platform MVP, & Certified Kubernetes Administrator
<!-- .slide: style="text-align: left;"> -->
<i class="fab fa-twitter"></i><a href="https://twitter.com/dbafromthecold">  @dbafromthecold</a><br>
<i class="fas fa-envelope"></i>  dbafromthecold@gmail.com<br>
<i class="fab fa-wordpress"></i>  www.dbafromthecold.com<br>
<i class="fab fa-github"></i><a href="https://github.com/dbafromthecold">  github.com/dbafromthecold</a>

---

## Pod Eviction on Node failure
<!-- .slide: style="text-align: left;"> -->
- What happens when a node fails?<br>
- Pods are moved to node in the Ready state<br>
- However, by default this takes 5 minutes<br>

<font size="6"><a href="https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/">kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration</a></font>

---

# Demo

---

## Adding tolerations to deployments
<!-- .slide: style="text-align: left;"> -->
<pre><code data-line-numbers="1-4|4|5-8|8">tolerations:
- key: "node.kubernetes.io/unreachable"
  operator: "Exists"
  effect: "NoExecute"
  tolerationSeconds: 10
- key: "node.kubernetes.io/not-ready"
  operator: "Exists"
  effect: "NoExecute"
  tolerationSeconds: 10
</pre></code>

---

# Demo

---

## What about stateful applications?
<!-- .slide: style="text-align: left;"> -->
- Pods need to move to a new node<br>
- Storage also has to move<br>
- Otherwise the pod will not spin up<br>

---

# Demo

---

## Resources

<!-- .slide: style="text-align: left;"> -->
<font size="6">
<a href="https://github.com/dbafromthecold/KubernetesPodEviction">github.com/dbafromthecold/KubernetesPodEviction</a><br>
<a href="https://dbafromthecold.com/2020/04/08/adjusting-pod-eviction-time-in-kubernetes/">dbafromthecold.com/2020/04/08/adjusting-pod-eviction-time-in-kubernetes/</a><br>
<a href="https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/">kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/</a>
</font>