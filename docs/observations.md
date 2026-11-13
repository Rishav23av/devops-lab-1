# Lab 1 observations

Rishav | Roll no. 2301730245

- All three route tests passed locally and in Jenkins.
- The first Jenkins build tested and packaged the app. Build 2 also deployed it with Docker.
- The health check ran inside the deployed container, so it worked even though Jenkins itself ran in another container.
- The app served the correct name and roll number at port 5011.
- Poll SCM is configured in the Jenkinsfile. The recorded builds were started manually.
- The Ubuntu service file is included for a systemd host. The recorded deployment used Docker Desktop on macOS.

See [screenshots](screenshots/README.md), [command output](commands/) and [reports](../reports/README.md).

Ubuntu Git setup and a real feature-branch merge were also recorded. The final
SCM-triggered build ran with deployment enabled by default and passed all stages.
