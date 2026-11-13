# Lab 1 record

Name: Rishav

Roll no.: 2301730245

**1. DevOps foundations**

Git stores the source history, GitHub hosts the repository and Jenkins runs the
pipeline. Keeping the pipeline in a Jenkinsfile means changes to the build process
can be reviewed along with the application.

**2. CI/CD workflow**

Push a change → checkout → install dependencies → test → package → deploy.
A failed test stops the package and deployment stages. Each successful build
produces a numbered archive, so the artifact can be traced to a Jenkins build.

**3. Automated deployment**

The default deployment uses Docker and checks the container on port 5011.
For the systemd alternative, use an Ubuntu host, select `DEPLOY_TARGET=systemd`
and install the service:

```bash
sudo apt update
sudo apt install git python3 python3-venv curl
sudo install -m 0644 docs/devops-lab1.service /etc/systemd/system/devops-lab1.service
sudo install -o root -g root -m 0755 scripts/deploy.sh /usr/local/sbin/deploy-lab1
sudo systemctl daemon-reload
sudo systemctl enable devops-lab1.service
sudo /usr/local/sbin/deploy-lab1 "$PWD"
curl --fail http://127.0.0.1:5001/health
```

On a dedicated Jenkins lab host, use `sudo visudo -f /etc/sudoers.d/lab1-jenkins`
and add `jenkins ALL=(root) NOPASSWD: /usr/local/sbin/deploy-lab1`.
This lets the job run the installed deployment script. Keep that script owned by
root. Only trusted repository code should run on this agent: Python package
installation during deployment also runs as root.

The script copies the app, installs its runtime dependencies, restarts the service
and waits for `/health`. A failed health check fails the pipeline.

The Docker alternative is `DEPLOY=true`, `DEPLOY_TARGET=docker` in Jenkins.
It runs `scripts/deploy-container.sh`, builds the current source, starts the app
on port 5011 and checks health inside the container. This is also usable on a
Mac or Windows Docker host. The systemd configuration above remains the Ubuntu option.

**4. Git and Jenkins setup**

Install Jenkins using the [official Ubuntu instructions](https://www.jenkins.io/doc/book/installing/linux/).
Complete the setup wizard on port 8080 and install the Git, Pipeline and JUnit
plugins. Check the Java requirement on that page before installing Jenkins.

```bash
git --version
git config user.name "Rishav"
git config user.email "174773787+Rishav23av@users.noreply.github.com"
systemctl status jenkins
```

**Recorded Ubuntu Git setup**

Git was installed and configured inside an Ubuntu 24.04 container. The global
identity in that container is Rishav with the GitHub noreply email. See
`docs/commands/ubuntu-git-install.txt` and `ubuntu-git-setup.txt` for the actual
installation and verification output. This kept the host's global Git settings
separate from the Ubuntu exercise.

**5. Version control**

```bash
git switch -c feature/submission-map
git add docs/submission-checklist.md
git commit -m "Add a question-wise submission map"
git switch main
git merge --ff-only feature/submission-map
git push origin main
git log --graph --oneline -5
```

**6. Basic Jenkins pipeline**

Use `https://github.com/Rishav23av/devops-lab-1.git` as the SCM URL. Run the first
build manually. Test results appear under Test Result and the archive appears
under Build Artifacts.

**7. Pipeline stages**

Checkout gets the current code. Build creates a virtual environment. Test checks
the routes and student details. Package creates the archive. Deploy runs after the tests pass. `DEPLOY=false` skips it for a build-only run.
The Docker target is the default; systemd requires the service setup above. Poll SCM
checks for new commits every five minutes.

The tests run locally and through GitHub Actions. Jenkins and systemd use a
configured Linux host.
