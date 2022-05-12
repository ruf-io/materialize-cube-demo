cube(`ItemSummary`, {
  refreshKey: {
    every: `1 second`
  },
  sql: `SELECT * FROM public.item_summary`,
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
      sql: `SUM(orders)/SUM(pageviews)`,
      format: `percent`
    },
    conversionRateLastHour: {
      type: `number`,
      sql: `SUM(last_hour_orders)/SUM(last_hour_pageviews)`,
      format: `percent`
    }
  },
  dimensions: {
    id: {
      sql: `item_id`,
      type: `number`
    },
    name: {
      sql: `name`,
      type: `string`
    },
    category: {
      sql: `category`,
      type: `string`
    }
  },
  dataSource: `default`,
  preAggregations: {
    main: {
      measures: [ItemSummary.count, ItemSummary.totalRevenue, ItemSummary.totalOrders, ItemSummary.totalPageviews, ItemSummary.totalItemsSold, ItemSummary.conversionRate, ItemSummary.conversionRateLastHour],
      dimensions: [ItemSummary.category, ItemSummary.id, ItemSummary.name]
    }
  }
});