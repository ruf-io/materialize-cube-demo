cube(`ProfileViewsEnriched`, {
  sql: `SELECT * FROM public.profile_views_enriched`,
  
  preAggregations: {
    // Pre-Aggregations definitions go here
    // Learn more here: https://cube.dev/docs/caching/pre-aggregations/getting-started  
  },
  
  joins: {
    
  },
  
  measures: {
    count: {
      type: `count`,
      drillMembers: []
    }
  },
  
  dimensions: {
    ownerEmail: {
      sql: `owner_email`,
      type: `string`
    },
    
    viewerEmail: {
      sql: `viewer_email`,
      type: `string`
    }
  },
  
  dataSource: `default`
});
