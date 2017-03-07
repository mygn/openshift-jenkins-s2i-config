#!/usr/bin/groovy
@Library('github.com/rawlingsj/fabric8-pipeline-library@master')
def name = 'openshift-jenkins-s2i-config'
def org = 'fabric8io'
dockerTemplate{
    s2iNode{
        git "https://github.com/${org}/${name}.git"
        if (env.BRANCH_NAME.startsWith('PR-')) {
            echo 'Running CI pipeline'
            container('s2i') {
                sh 's2i build . openshift/jenkins-2-centos7:latest fabric8/jenkins-openshift:test --copy'
            }
        } else if (env.BRANCH_NAME.equals('master')) {
            echo 'Running CD pipeline'
            def newVersion = getNewVersion {}

            stage 's2i build'
            container('docker') {
                // make sure we have the latest openshift image on the node
                 sh 'docker pull openshift/jenkins-2-centos7:latest'
            }
            container('s2i') {
                sh 's2i build . openshift/jenkins-2-centos7:latest fabric8/jenkins-openshift:latest --copy'
            }
            
            stage 'push to dockerhub'
            container('docker') {
                sh 'docker push fabric8/jenkins-openshift:latest'
                sh "docker tag fabric8/jenkins-openshift:latest fabric8/jenkins-openshift:${newVersion}"
                sh "docker push fabric8/jenkins-openshift:${newVersion}"
            }
            
            pushPomPropertyChangePR {
                propertyName = 'jenkins-openshift.version'
                projects = [
                        'fabric8io/fabric8-devops'
                ]
                version = newVersion
                containerName = 's2i'
            }
        }
    }
}
