# Changelog
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
