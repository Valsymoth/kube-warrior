yum install wget -y
wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O /usr/bin/jq
chmod +x /usr/bin/jq
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
EOF 
sysctl --system 
kubeadm init --pod-network-cidr=10.244.0.0/16 > /dev/null
# Master stuff
useradd kubewarrior 
useradd -aG wheel kubewarrior
echo kubewarrior:kubewarrior | chpasswd
chmod 640 /etc/sudoers 
echo "kubewarrior ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i 's/%wheel.*/%wheel        ALL=(ALL)       NOPASSWD: ALL/' /etc/sudoers 
chmod 440 /etc/sudoers 
sudo -u kubewarrior mkdir -p $HOME/.kube 
sudo -u kubewarrior cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo -u kubewarrior chown  $(id -u):$(id -g) $HOME/.kube/config
sudo -u kubewarrior kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml 
sudo kubectl get nodes 
