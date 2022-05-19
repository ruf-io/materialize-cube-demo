cube(`Vendors`, {
  refreshKey: {
    every: `1 second`
  },

  sql: `SELECT * FROM public.agg_vendors_minute`,
  measures: {
    count: {
      type: `count`,
      drillMembers: [CUBE.name]
    },
    totalRevenue: {
      type: `sum`,
      sql: `revenue`,
      format: `currency`
    },
    totalOrders: {
      type: `sum`,
      sql: `orders`
    },
    totalPageviews: {
      type: `sum`,
      sql: `pageviews`
    },
    totalItemsSold: {
      type: `sum`,
      sql: `items_sold`
    },
    conversionRate: {
      type: `number`,
      sql: `SUM(orders)/SUM(pageviews)+1`,
      format: `percent`
    },
  },
  dimensions: {
    id: {
      sql: `vendor_id`,
      type: `number`
    },
    name: {
      sql: `vendor_name`,
      type: `string`
    },
    receivedAtMinute: {
      sql: `m`,
      type: `time`
    }
  },
  dataSource: `default`,
});
