# Materialize + Cube Integration Proof-of-Concept

![image](https://user-images.githubusercontent.com/11527560/168118268-7e5531aa-ce9c-4300-8aef-61ae6faa373e.png)

This is a quick proof-of-concept of how [Cube](https://cube.dev/) integrates with [Materialize]()

- **Materialize** is a streaming database that
- **Cube** is a "headless BI" service that connects to databases or data warehouses and handles Data Modeling, Access Control, Caching and APIs

## Starting Up

You'll need to have [docker and docker-compose installed](https://materialize.com/docs/third-party/docker) before getting started.

1. Clone this repo and navigate to the directory by running:

   ```shell session
   git clone https://github.com/ruf-io/materialize-cube-demo.git
   cd materialize-cube-demo
   ```

2. Bring up the Docker Compose containers in the background.

   ```shell session
   docker-compose up -d
   ```

   **This may take several minutes to complete the first time you run it.** If all goes well, you'll have everything running in their own containers, with Debezium configured to ship changes from MySQL into Redpanda.

3. Confirm that everything is running as expected:

   ```shell session
   docker-compose ps
   ```

4. Initialize the Materialize Schema

   ```shell session
   psql -h localhost -p 6875 -U materialize -f materialize/create.sql
   ```
