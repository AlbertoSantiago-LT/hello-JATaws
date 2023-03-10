pipeline {
    agent any
    options {
        timestamps()
        ansiColor('xterm')
    }
    stages{
        stage('Imagen'){
            steps{
                sh '''
		docker-compose build
                git tag 1.0.${BUILD_NUMBER}
                docker tag ghcr.io/albertosantiago-lt/hello-2048/hello2048:latest ghcr.io/albertosantiago-lt/hello-2048/hello2048:1.0.${BUILD_NUMBER}
                '''
                sshagent(['ssh-github']) {
                    sh('git push git@github.com:albertosantiago-lt/hello-2048.git --tags')
                }
	    }	                              
        }  
        
        stage('Subir Imagen'){
            steps{ 
		withCredentials([string(credentialsId: 'github-token', variable: 'GIT_TOKEN')]){
		    sh 'echo $GIT_TOKEN | docker login ghcr.io -u albertosantiago-lt --password-stdin'
                    sh 'docker push ghcr.io/albertosantiago-lt/hello-2048/hello2048:1.0.${BUILD_NUMBER}'
		        }
            }
        }  
        stage('Terraform Init') {
            steps{
                withAWS(credentials: 'Credentials_aws', region: 'eu-west-1') {
                    sh 'terraform init'
                    sh 'terraform fmt'
                    sh 'terraform validate'
                }
	        }
        }

        stage('Terraform Apply') {
            steps{
                withAWS(credentials: 'Credentials_aws', region: 'eu-west-1') {
	            sh 'terraform apply -auto-approve'
                }
	        }
        }
        stage('Terraform Playbook') {
            steps{
                sshagent(['ssh-amazon']) {
                    withAWS(credentials: 'Credentials_aws', region: 'eu-west-1') {
                        ansiblePlaybook credentialsId: 'ssh-amazon', inventory: './ansible/aws_ec2.yml', playbook: './ansible/httpd.yml'
                    }
	            }
            }
        }
    }
}
