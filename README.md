# Materialize + Cube Integration Proof-of-Concept

![image](https://user-images.githubusercontent.com/11527560/169356685-8c846ba5-90eb-4472-9e03-46e43bed6003.png)

This is a quick proof-of-concept of how [Cube](https://cube.dev/) integrates with [Materialize](https://materialize.com/)

- **Materialize** is a streaming database that maintains the results of queries incrementally, giving you views of your data that are always up to date.
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

5. There is a basic cube schema already drafted for a "Vendors" aggregation in [`cube/schema/Vendors.js`](https://github.com/ruf-io/materialize-cube-demo/blob/main/cube/schema/Vendors.js)
   a. Test out building a query with it in the Cube.JS Dev Playground at `localhost:4000`

   b. Test curling the query to see how the REST API works, the REST API uses a JSON schema that is demonstrated in the UI (see JSON Query tab):
   ```json
   {
   "measures": [
      "Vendors.totalRevenue",
      "Vendors.totalOrders",
      "Vendors.totalPageviews",
      "Vendors.totalItemsSold"
   ],
   "timeDimensions": [],
   "order": {
      "Vendors.totalRevenue": "desc"
   },
   "dimensions": [
      "Vendors.name"
   ],
   "filters": [
      {
         "member": "Vendors.id",
         "operator": "equals",
         "values": [
         "24"
         ]
      }
   ]
   }
   ```

   So you can test it via a curl command like:

   ```
   curl localhost:4000/cubejs-api/v1/load -G -s --data-urlencode "query=$(cat example_query.json)" | jq '.data'
   ```

   c. You can test the GraphQL API using the dev playground

   d. Test adding Auth to limit what data each vendor can read.

   e. Try adding a pre-aggregation with a `1 second` cache expiration. This effectively tells Cube Store to cache the view on every query, if Materialize goes down it will continue to serve the last state of the view!
