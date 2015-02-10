#!/bin/bash

if [[ -z "$SYMFONY_SECRET" ]]; then echo "SYMFONY_SECRET is unset" && exit 1; fi

if [[ -z "$MAILER_HOST" ]]; then echo "MAILER_HOST is unset" && exit 1; fi

if [[ -z "$MAILER_USER" ]]; then echo "MAILER_USER is unset" && exit 1; fi

if [[ -z "$MAILER_PASSWORD" ]]; then echo "MAILER_PASSWORD is unset" && exit 1; fi

if [[ -z "$APP_DOMAIN" ]]; then APP_DOMAIN='search-awesome.com'; fi

if [[ -z "$MAILER_TRANSPORT" ]]; then MAILER_TRANSPORT='smtp'; fi
if [[ -z "$MAILER_PORT" ]]; then MAILER_PORT=465; fi
if [[ -z "$MAILER_ENCRYPTION" ]]; then MAILER_ENCRYPTION='ssl'; fi

if [[ -z "$MONGO_DATABASE" ]]; then MONGO_DATABASE='search_awesome_app'; fi

if [[ -z "$RECAPTCHA_PUBLIC_KEY" ]]; then echo "RECAPTCHA_PUBLIC_KEY is unset" && exit 1; fi
if [[ -z "$RECAPTCHA_PRIVATE_KEY" ]]; then echo "RECAPTCHA_PRIVATE_KEY is unset" && exit 1; fi
if [[ -z "$RECAPTCHA_SESSION_KEY" ]]; then RECAPTCHA_SESSION_KEY='_recaptcha_valid'; fi

if [[ -z "$DELIVERY_ADDRESS" ]]; then DELIVERY_ADDRESS='null'; fi

sed -i "s@secret: ThisTokenIsNotSoSecretChangeIt@secret: ${SYMFONY_SECRET}@" /www/app/config/parameters_base.yml
sed -i "s@mailer_transport: smtp@mailer_transport: ${MAILER_TRANSPORT}@" /www/app/config/parameters_base.yml
sed -i "s@mailer_host: 127.0.0.1@mailer_host: ${MAILER_HOST}@" /www/app/config/parameters_base.yml
sed -i "s@mailer_user: null@mailer_user: ${MAILER_USER}@" /www/app/config/parameters_base.yml
sed -i "s@mailer_password: null@mailer_password: ${MAILER_PASSWORD}@" /www/app/config/parameters_base.yml
sed -i "s@mailer_encryption: ssl@mailer_encryption: ${MAILER_ENCRYPTION}@" /www/app/config/parameters_base.yml
sed -i "s@mailer_port: 465@mailer_port: ${MAILER_ENCRYPTION}@" /www/app/config/parameters_base.yml
sed -i "s@app_domain: null@app_domain: ${APP_DOMAIN}@" /www/app/config/parameters_base.yml
sed -i "s@mongo_database: search_awesome_app@mongo_database: ${MONGO_DATABASE}@" /www/app/config/parameters_base.yml
sed -i "s@delivery_address: null@delivery_address: ${DELIVERY_ADDRESS}@" /www/app/config/parameters_base.yml
sed -i "s@recaptcha_public_key: null@recaptcha_public_key: ${RECAPTCHA_PUBLIC_KEY}@" /www/app/config/parameters_base.yml
sed -i "s@recaptcha_private_key: null@recaptcha_private_key: ${RECAPTCHA_PRIVATE_KEY}@" /www/app/config/parameters_base.yml
sed -i "s@recaptcha_session_key: _recaptcha_valid@_recaptcha_valid: ${RECAPTCHA_SESSION_KEY}@" /www/app/config/parameters_base.yml

cp /www/app/config/parameters_base.yml /www/app/config/parameters.yml

# run HHVM
cd /www/web
hhvm --mode server -vServer.Port=9000 -vServer.Type=fastcgi
