cube(`ProfileViewsPerMinuteLast10`, {
  sql: `SELECT * FROM public.profile_views_per_minute_last_10`,
  
  preAggregations: {
    // Pre-Aggregations definitions go here
    // Learn more here: https://cube.dev/docs/caching/pre-aggregations/getting-started  
  },
  
  joins: {
    
  },
  
  measures: {
    pageviews: {
      sql: `pageviews`,
      type: `sum`
    }
  },
  
  dimensions: {
    user: {
      sql: `user_id`,
      type: `number`,
    },
    receivedAtMinute: {
      sql: `received_at_minute`,
      type: `time`
    }
  },
  
  dataSource: `default`
});
