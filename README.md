# deploy-kimi1

Minimal professional HTTP API with CI/CD, Docker and idempotent SSH deploy.

## Endpoints

- `GET /health` — returns `{ "status": "ok" }` with HTTP 200
- `GET /version` — returns the deployed version (commit SHA or tag)
- `POST /echo` — echoes the JSON request body

## Stack

- Node.js 18
- Express
- Jest + Supertest
- ESLint
- Docker

## Development

```bash
npm install
npm run lint
npm test
npm start
```

## Docker

```bash
docker build -t deploy-kimi1 .
docker run -p 3000:3000 deploy-kimi1
```

Or with docker-compose:

```bash
docker-compose up --build
```

## CI

The GitHub Actions workflow runs lint, tests, builds the Docker image and performs a real smoke test against the running container. The workflow fails if `/health` does not return HTTP 200.

## Deploy

The deploy workflow runs via SSH. Configure these secrets:

- `DEPLOY_HOST`
- `DEPLOY_USER`
- `DEPLOY_SSH_KEY`
- `DEPLOY_PORT`

The deploy script keeps the previous version locally and rolls back automatically if the health check fails.

## License

MIT
