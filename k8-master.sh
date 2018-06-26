yum update -y
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
kubeadm init --pod-network-cidr=10.244.0.0/16 
# Master stuff
chmod 640 /etc/sudoers 
echo "kubewarrior ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i 's/%wheel.*/%wheel        ALL=(ALL)       NOPASSWD: ALL/' /etc/sudoers 
chmod 440 /etc/sudoers 
useradd -G wheel kubewarrior 
echo kubewarrior:kubewarrior | chpasswd
user=kubewarrior 
mkdir -p /home/$user/.kube 
cp -i /etc/kubernetes/admin.conf /home/$user/.kube/config
chown $user:$user /home/$user/.kube/config
sudo -u $user kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml 
sudo -u $user kubectl get nodes 
kubeadm token create --print-join-command >> k8-worker.sh
# hardcored, don't like this part much.
scp ./k8-worker.sh root@207.154.243.210:~
ssh root@46.101.198.252 "~/k8-worker.sh"
ssh root@46.101.198.252 ". /root/k8-worker.sh"
