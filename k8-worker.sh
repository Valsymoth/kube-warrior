yum install wget
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o jq
mv jq /usr/bin
setenforce 0 
sed -i 's/SELINUX=.*/SELINUX=permissive/' /etc/selinux/config 
yum install docker -y 
systemctl enable docker
systemctl start docker
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install kubeadm kubectl kubelet -y 
systemctl enable kubelet  
systemctl start kubelet  
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system 
#TO-DO fetch join token from the master and include in this file
#kubeadm token create --print-join-command
kubeadm join 159.89.20.210:6443 --token b87soc.xqngg22ppr1xrfj2 --discovery-token-ca-cert-hash sha256:f381eda5aa4d49b48cef23b19c16f0587409d407c5fdccfe4d2215d296a86574
