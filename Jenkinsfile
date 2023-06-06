#!groovy

pipeline {
  agent {
        label 'ubuntu2204'
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
							'''
                }
        }


        stage("Simulate the playbook") {
            when { expression { env.GIT_BRANCH != 'origin/main' } }
            steps {
                sh 'echo "do whatever"'
                }
        }
        stage("Run the playbook") {
            when { expression { env.GIT_BRANCH == 'origin/main' } }
            steps {
                sh 'echo "do whatever"'
                }
        }
    } // EOL stages
  post {
    always {
        cleanWs()
        }
  } // eol post
}
