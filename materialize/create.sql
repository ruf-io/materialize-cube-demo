-- CREATE SOURCES

CREATE SOURCE json_pageviews
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'pageviews'
FORMAT BYTES;

CREATE SOURCE purchases
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'mysql.shop.purchases'
FORMAT AVRO USING CONFLUENT SCHEMA REGISTRY 'http://redpanda:8081'
ENVELOPE DEBEZIUM;

CREATE SOURCE items
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'mysql.shop.items'
FORMAT AVRO USING CONFLUENT SCHEMA REGISTRY 'http://redpanda:8081'
ENVELOPE DEBEZIUM;

CREATE SOURCE users
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'mysql.shop.users'
FORMAT AVRO USING CONFLUENT SCHEMA REGISTRY 'http://redpanda:8081'
ENVELOPE DEBEZIUM;

CREATE SOURCE vendors
FROM KAFKA BROKER 'redpanda:9092' TOPIC 'mysql.shop.vendors'
FORMAT AVRO USING CONFLUENT SCHEMA REGISTRY 'http://redpanda:8081'
ENVELOPE DEBEZIUM;

-- CREATE NON-MATERIALIZED VIEW TO PARSE JSON PAGEVIEWS

CREATE VIEW pageview_stg AS
    SELECT
        *,
        regexp_match(url, '/(products|profiles)/')[1] AS pageview_type,
        (regexp_match(url, '/(?:products|profiles)/(\d+)')[1])::INT AS target_id,
        to_timestamp(received_at) as received_at_ts
    FROM (
        SELECT
            (data->'user_id')::INT AS user_id,
            data->>'url' AS url,
            data->>'channel' AS channel,
            (data->>'received_at')::double AS received_at
        FROM (
            SELECT CAST(data AS jsonb) AS data
            FROM (
                SELECT convert_from(data, 'utf8') AS data
                FROM json_pageviews
            )
        )
    );

-- CREATE AN ANALYTICAL AGGREGATION FOR VENDORS

CREATE MATERIALIZED VIEW agg_vendors_minute AS
    SELECT
        vendors.id as vendor_id,
        vendors.name as vendor_name,
        minute_series.m::timestamp,
        SUM(purchases.quantity) as items_sold,
        COUNT(purchases.id) as orders,
        SUM(purchases.purchase_price) as revenue,
        COUNT(pageview_stg.url) as pageviews
    FROM vendors
    JOIN items ON items.vendor_id = vendors.id
    JOIN (
        SELECT generate_series('2022-05-19 00:00:00', '2022-05-20 00:00:00', '1 MINUTE') as m
    ) minute_series ON true
    LEFT JOIN purchases ON purchases.item_id = items.id AND date_trunc('minute', purchases.created_at) = minute_series.m
    LEFT JOIN pageview_stg ON pageview_stg.target_id = items.id AND pageview_stg.pageview_type = 'products' AND date_trunc('minute', pageview_stg.received_at_ts) = minute_series.m
    GROUP BY 1, 2, 3;