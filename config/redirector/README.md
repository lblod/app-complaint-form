# What?
Redirects `http://klachtenformulier.lblod.info/` to `http://klachtenformulier.lokaalbestuur.vlaanderen.be/`.

# Why?
This service and configuration are only relevant in production. Since the backoffice part was moved to ACM/IDM, it was necessary to make it work with a `*.vlaanderen.be` DNS. This means we currently have to support both `klachtenformulier.lblod.info` and `klachtenformulier.lokaalbestuur.vlaanderen.be`.

We want to push `klachtenformulier.lokaalbestuur.vlaanderen.be` forward, but we don't want to break the existing links, so a redirect is needed.

# Assumptions
- It should work only on production.
- It works only on machines set up with the standard Let's Encrypt setup, i.e. the service will work on the described `http` link.
- This service should listen on `klachtenformulier.lblod.info` as `VIRTUAL_HOST` in `docker-compose.override.yml`
- The identifier will listen to `klachtenformulier.lokaalbestuur.vlaanderen.be`
