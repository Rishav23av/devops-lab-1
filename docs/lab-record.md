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

The deployment target is an Ubuntu machine running systemd. Install Python, venv,
curl and the service before enabling `DEPLOY` in Jenkins:

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

**5. Version control**

```bash
git switch -c feature/home-message
# Edit the home message in app/app.py, then run the tests.
python -m pytest tests/ -v
git add app/app.py
git commit -m "Update home message"
git switch main
git merge feature/home-message
git push origin main
git log --oneline -5
```

**6. Basic Jenkins pipeline**

Use `https://github.com/Rishav23av/devops-lab-1.git` as the SCM URL. Run the first
build manually. Test results appear under Test Result and the archive appears
under Build Artifacts.

**7. Pipeline stages**

Checkout gets the current code. Build creates a virtual environment. Test checks
the routes and student details. Package creates the archive. Deploy runs only
after the service is configured and the build parameter is enabled. Poll SCM
checks for new commits every five minutes.

The tests run locally and through GitHub Actions. Jenkins and systemd use a
configured Linux host.
