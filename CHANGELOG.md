# Changelog
## 2.3.0 (2025-12-01)
- [DL-7013] update grace period to wait a bit before email gets triggered
### Deploy instructions
```
drc restart deltanotifier
```
## 2.2.2 (2025-07-08)
- Bump frontend to v0.8.1 [DL-6715]

### Deploy instructions

The frontend now uses `semtech/static-file-service` as the base image, which assumes the identifier is the entrypoint of the app so we need to do some config changes when deploying:

- move the `VIRTUAL_HOST`, `LETSENCRYPT_HOST` and `LETSENCRYPT_EMAIL` environment variables from the frontend to the identifier service
- move the `networks` config from the frontend to the identifier service

After that run the following commands:

```
drc restart dispatcher ; drc up -d
```

## 2.2.1 (2025-06-30)
- Bump mu-cl-resources to v1.27.0
## 2.2.0 (2025-06-24)
- Added redirection from `klachtenformulier.lblod.info` to `klachtenformulier.lokaalbestuur.vlaanderen.be`. SeeAlso: [DL-6614]
### Deploy instructions
On production only, ensure the `docker-compose.override.yml` file contains at least the following directives:

```
services:
  redirector:
    environment:
      VIRTUAL_HOST: "klachtenformulier.lblod.info"
      LETSENCRYPT_HOST: "klachtenformulier.lblod.info"
      LETSENCRYPT_EMAIL: "info@redpencil.io"
    networks:
      - proxy
      - default
  frontend:
    environment:
      VIRTUAL_HOST: "klachtenformulier.lokaalbestuur.vlaanderen.be"
      LETSENCRYPT_HOST: "klachtenformulier.lokaalbestuur.vlaanderen.be"
      LETSENCRYPT_EMAIL: "info@redpencil.io"
    networks:
      - proxy
      - default
```

## 2.1.0 (2025-06-21)
- Add ACMIDM and mocklogin to the stack [DL-6614]
### Deploy instructions
On DEV only: add the following to your `docker-compose.override.yml`:
```
  mocklogin:
    image: lblod/mock-login-service:0.7.0
    restart: "no"
```
And for QA:
```
  frontend:
    environment:
      EMBER_ACMIDM_CLIENT_ID: "5cbf63f8-fbd9-4ab6-8c91-be0d07723147"
      EMBER_ACMIDM_BASE_URL: "https://authenticatie-ti.vlaanderen.be/op/v1/auth"
      EMBER_ACMIDM_LOGOUT_URL: "https://authenticatie-ti.vlaanderen.be/op/v1/logout"
      EMBER_ACMIDM_REDIRECT_URL: "https://qa.klachtenformulier.lblod.info/authorization/callback" # only for QA
      EMBER_ACMIDM_SCOPE: "openid rrn profile vo abb_klachtenformulier"

  login:
    environment:
      MU_APPLICATION_AUTH_REDIRECT_URI: "https://qa.klachtenformulier.lblod.info/authorization/callback" # only for QA
      MU_APPLICATION_AUTH_CLIENT_SECRET: "TODO_REPLACE_ME" # QA and Prod
```

*Note that for PROD, it'll be very similar but some values will change. We don't have them yet, we'll receive them from ACMIDM once we validate the QA setup.*

Then
```
drc restart dispatcher database migrations ; drc up -d
```
## 2.0.3 (2024-03-07)
- format all dates using the same timezone [DL-5685]
### deploy instructions
```
drc restart complaint-form-email-converter
```
## 2.0.2 (2024-01-30)
- correct dispatcher rules [DL-5603]
## 2.0.1 (2024-01-30)
- ensure old data is properly migrated to work with mu-auth [DL-5603]
## 2.0.0 (2024-01-17)
Mainly a refurbishment taking all `semantic.works` evolutions into considerations.
### deploy instructions
The database needs upgrade: see https://github.com/redpencilio/docker-virtuoso/blob/0eb1029cee9c04e16f80bddc857cd8210c83fc0b/README.md
Service names have changed, ensure in the `docker-compose.override.yml`
```
complaint-form-email-converter-service -> complaint-form-email-converter
deliver-email-service -> deliver-email
```
Ensure also `docker-compose.override.yml`
```
  complaint-form-warning:
    environment:
      EMAIL_FROM: "from"
      EMAIL_TO: "to"
  error-alert:
    environment:
      EMAIL_FROM: "from"
      EMAIL_TO: "to"
```
```
drc down; drc up -d --remove-orphans
```
