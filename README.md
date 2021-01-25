# DNS Records

> DNS Records application

## Local development

Setup a local development enviroment through the following instructions:

1. Please make sure to install Ruby 2.7.1+
2. Install `bundler` and `rails` through the following command: `gem install rails bundler`
3. Install project dependencies: `bundle install`
4. Provide a PostgreSQL server for local development (PostgreSQL 13.x)
5. Test your local environment through the following command: `bin/rails db:create db:migrate && bin/rails test`
6. The server can be started through the following command: `bin/rails server`

## Deployment through Docker

This project can be deployed through a Docker container. To test it locally, follow these instructions:

1. Please make sure to install Docker and docker-compose
2. Build the image and provide the essential services through docker-compose: `docker-compose up --build`
3. Please make sure to provide a `DNS_RECORDS_DATABASE_URL` while deploying the containerized solution (check `docker-compose.yml` as a reference)

## API Documentation

This application provides a REST API for DNS Records management. It exposes the following endpoints:

### 1. Endpoint to create DNS Records with Hostnames

`POST /dns_records`

Request body (`application/json`):

```json
{
    "dns_records": {
        "ip": "1.1.1.1",
        "hostnames_attributes": [
            {
                "hostname": "lorem.com"
            }
        ]
    }
}
```

Example:

```sh
$ curl -X POST -H "Content-Type: application/json" \
    -d '{"dns_records": { "ip": "1.1.1.1", "hostnames_attributes": [{ "hostname": "lorem.com" }] } }' \
    http://localhost:3000/dns_records
> {"id":1}

$ curl -X POST -H "Content-Type: application/json" \
    -d '{"dns_records": { "ip": "1.1.1.1", "hostnames_attributes": [{ "hostname": "ipsum.com" }] } }' \
    http://localhost:3000/dns_records
> {"id":1}

$ curl -X POST -H "Content-Type: application/json" \
    -d '{"dns_records": { "ip": "1.1.1.1", "hostnames_attributes": [{ "hostname": "dolor.com" }] } }' \
    http://localhost:3000/dns_records
> {"id":1}
```

### 2. Endpoint to retrieve DNS Records

`GET /dns_records`

Query parameters:

- `page` (required): page number
- `included`: list of all hostnames the DNS records should have
- `excluded`: list of hostnames the DNS records should not have

Response body format (`application/json`):

```json
{
    "total_records": 1,
    "records": [
        {
            "id": 1,
            "ip_address": "1.1.1.1"
        }
    ],
    "related_hostnames": [
        {
            "hostname": "lorem.com",
            "count": 5
        }
    ]
}
```

Example, given the entries above:

```sh
$ curl http://localhost:3000/dns_records\?page=1\&included\[\]=ipsum.com
> {"total_records":1,"records":[{"id":1,"ip_address":"1.1.1.1"}],"related_hostnames":[{"hostname":"lorem.com","count":1},{"hostname":"dolor.com","count":1}]}
```

## License

[MIT License](http://earaujoassis.mit-license.org/) &copy; Ewerton Carlos Assis
