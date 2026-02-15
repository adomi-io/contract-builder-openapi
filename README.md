> [!TIP]
> Looking for a way to manage your API contracts effortlessly?
> Check out our community-driven tools for Odoo and beyond.
>
> **[adomi-io](https://github.com/adomi-io)**.

<p align="center">
  <img src="/docs/static/logo.png" width="240" />
</p>

# 📜 Contract Builder 🏗️

A tool to turn your OpenAPI specs into working code. Drop your OpenAPI files in, and the builder automatically generates clients, types, and schemas for your favorite languages.

Under the hood, this repo uses the [OpenAPI Generator CLI](https://openapi-generator.tech/) wrapped in Docker, making it easy to keep your frontend and backend in sync without manual boilerplate.

## Highlights

- 🌍 Support for **all** OpenAPI Generator languages (Python, TypeScript, Go, etc.)
- 📂 **Multi-service support**: Automatically scans the `specs` folder for all your APIs
- 🐳 **Fully Dockerized**: No need to install Java or the generator locally
- 🔄 **Consistent Output**: Ensures your whole team generates the exact same code
- 🚀 **Fast Iteration**: Quickly design APIs and see the code update instantly

## What you can do

- Keep a single source of truth for your API
- Generate multiple clients in one go
- Ensure your frontend types always match your backend spec
- Quickly iterate on API designs and see the code update instantly

To generate clients, just drop your OpenAPI spec into the `specs` folder and run the builder.

# Getting started

> [!WARNING]
> This tool is designed to run via Docker.
> It keeps your environment clean and ensures everyone on your team gets the exact same code output.
>
>**[Download Docker Desktop](https://www.docker.com/products/docker-desktop/)**

# Docker Compose

The easiest way to use this is with `docker-compose`. It mounts your local folders so the generated code appears right on your machine.

See the [docker](./docker) folder for more information.

Copy the files in the [docker](./docker) folder to your project root, or run the commands from within that folder.

**Place your specs**

Put your `.yml` or `.yaml` files in subfolders under `specs/` (e.g., `specs/my-service/api.yml`). The subfolder name determines the output name.

**Run the generator**

```bash
docker compose up
```

**Find your code**

Check the `out/` directory for your generated clients.

# Running from source

Clone this repository, and open a terminal in the root directory.

## Build the application

> [!TIP]
> You can also run `docker compose up --build`.

Run `docker compose build`

## Run the application

Run the application by running

`docker compose up`

If you want to run the application all the time, start it with

`docker compose up -d`

To stop the application, run

`docker compose down`

# Adding new languages

The logic lives in `src/generate.sh`, which uses the `GENERATORS` environment variable to determine which clients to build. You can use **any** [generator name](https://openapi-generator.tech/docs/generators) supported by OpenAPI Generator.

When using the provided `docker-compose.yml`, it defaults to `python,typescript-axios,graphql-schema`.

## Update docker-compose.yml

Edit the `environment` section in your `docker-compose.yml`:

```yaml
environment:
  - GENERATORS=python,typescript-axios,graphql-schema,go
```

## Run with an environment variable

You can also pass it directly to Docker:

```bash
docker run --rm -e GENERATORS="python,go" -v $(pwd)/specs:/local/src -v $(pwd)/out:/local/out contract-builder
```

## Typical data flow

- Developer updates `specs/petstore/api.yml`
- `docker compose up` is triggered
- The generator container starts, scans `specs/`, and runs `generate.sh`
- New code is written to `out/petstore/python`, `out/petstore/typescript-axios`, etc., depending on your `GENERATORS` setting.
- Your app uses the updated clients immediately

## About Adomi

Contract Builder is an Adomi project. We build helpful tools for modern development workflows. If you have ideas or run into issues, feel free to open an issue or suggestion.
