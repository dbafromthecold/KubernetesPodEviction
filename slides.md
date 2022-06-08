## Adjusting Pod Eviction Timings in Kubernetes

---

<p align="center">
<img src="images/cndm_title_slide.png" />
</p>

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
<img src="images/node-128.png" style="float: right"/>
<!-- .slide: style="text-align: left;"> -->
<ul>
<li class="fragment">What happens when a node fails?<br></li>
<li class="fragment">Pods are moved to node in the Ready state</li>
<li class="fragment">However, by default this takes 5 minutes</li>
<ul>


---

# Demo

---

## Adding tolerations to deployments
<!-- .slide: style="text-align: left;"> -->
<pre><code data-line-numbers="1-5|5|6-9|9">tolerations:
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
<ul>
<li class="fragment">Pods need to move to a new node<br></li>
<li class="fragment">Storage also has to move</li>
<li class="fragment">Otherwise the pod will not spin up</li>
<ul>

---

# Demo

---

## Resources

<!-- .slide: style="text-align: left;"> -->
<font size="6">
<a href="https://github.com/dbafromthecold/KubernetesPodEviction">Github Repo - Kubernetes Pod Eviction</a><br>
<a href="https://dbafromthecold.com/2020/04/08/adjusting-pod-eviction-time-in-kubernetes/">Blog Post - Adjusting pod eviction time</a><br>
<a href="https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/">Kubernetes Documentation - Taints and tolerations</a>
</font>

<p align="center">
<img src="images/qr_code.png" />
</p>