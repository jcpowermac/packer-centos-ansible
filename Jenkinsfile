#!/usr/bin/env groovy

def label = "packer-${UUID.randomUUID().toString()}"

podTemplate(label: label, cloud: "openshift", yaml: """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: slave
spec:
  containers:
    - image: 'docker-registry.default.svc:5000/packer/packer'
      env:
      - name: HOME
        value: /tmp
      name: jnlp
      workingDir: /tmp
      volumeMounts:
      - mountPath: /tmp
        name: workspace-volume
      resources:
        limits:
          devices.kubevirt.io/kvm: 1
          devices.kubevirt.io/tun: 1
  serviceAccount: jenkins
  serviceAccountName: jenkins
  nodeSelector:
    node-role.kubernetes.io/compute: 'true'
""") {
    node(label) {
        stage('checkout') {
            checkout scm
        }
        stage('Integration Test') {
            container('jnlp') {
                sh "find ."

                sh "ls -alh /opt/app-root/bin/packer"
                sh "ls -alh /dev/kvm"
                sh "/opt/app-root/bin/packer build -debug centos7.json"
            }
        }
    }
}
