#!groovy

pipeline {
  agent {
        label 'ubuntu'
  }
  options {
	timestamps()
    ansiColor("xterm")
    buildDiscarder(logRotator(numToKeepStr: "100"))
    timeout(time: 2, unit: "HOURS")
  }
  environment {
      REPOS = 'cakcuk/ansible'
  }
    stages {
        stage("Print environment") {
            steps {
                sh 'printenv | sort'
            }
        }

        stage("Ansible and YAML Lint") {
            steps {
               sh '''
                bash ./scripts/prepare.sh
                . $HOME/.bashrc
                export PATH=$HOME/.local/bin:$PATH
                yamllint -f colored --no-warnings ${WORKSPACE}
                ansible-lint --exclude "molecule" --force-color -x 106 ${WORKSPACE}
		sudo ln -sf $HOME/.local/bin/ansible-playbook /usr/local/bin/ansible-playbook
                '''
                }
        }


        stage("Simulate the playbook") {
            when { expression { env.GIT_BRANCH != 'origin/main' } }
            steps {
                sh 'export PATH=$HOME/.local/bin:$PATH'
                ansiblePlaybook colorized: true, credentialsId: 'Global-SSH-RSA', disableHostKeyChecking: true, extras: '-C -D', installation: 'Jenkins-Ansible', inventory: 'inventory.yaml', playbook: 'playbook.yaml', vaultCredentialsId: 'Global-Ansible-Vault'
                }
        }
        stage("Run the playbook") {
            when { expression { env.GIT_BRANCH == 'origin/main' } }
            steps {
               sh 'export PATH=$HOME/.local/bin:$PATH'
               ansiblePlaybook colorized: true, credentialsId: 'Global-SSH-RSA', disableHostKeyChecking: true, installation: 'Jenkins-Ansible', inventory: 'inventory.yaml', playbook: 'playbook.yaml', vaultCredentialsId: 'Global-Ansible-Vault'
                }
        }
    } // EOL stages
  post {
    always {
        cleanWs()
        }
  } // eol post
}
