# Stack Patterns: DuckDB Analytics / Data Pipeline

Decomposition patterns for analytics and data pipeline projects using DuckDB as the embedded analytical engine.

## Typical Layer Mapping

| Layer | DuckDB Equivalent | Common Paths |
|-------|-------------------|--------------|
| Config | Connection setup, env vars, paths | `config/`, `src/config.py` |
| Schema/DDL | Table definitions, types | `sql/schema/`, `migrations/` |
| Ingestion | Source loading (CSV, Parquet, JSON, API) | `sql/ingestion/`, `src/ingest/` |
| Transforms | Cleaning, joins, enrichment | `sql/transforms/`, `src/transforms/` |
| Aggregations | Summaries, rollups, materialized views | `sql/aggregations/`, `sql/views/` |
| Exports | Output to Parquet, CSV, external DB | `sql/exports/`, `src/exports/` |
| Orchestration | Pipeline runner, DAG execution | `src/pipeline.py`, `Makefile` |
| Data Quality | Assertions, row counts, schema tests | `tests/`, `sql/quality/` |

## Decomposition Order

### 1. Schema before data
Define target table structures before loading any data. DuckDB supports `CREATE TABLE` and `CREATE TYPE` for enums.

```markdown
## 1. Schema
- [ ] 1.1 Create raw_events table DDL (sql/schema/raw_events.sql)
- [ ] 1.2 Create dim_users table DDL (sql/schema/dim_users.sql)
- [ ] 1.3 Create fact_orders table DDL (sql/schema/fact_orders.sql)
```

### 2. Ingestion before transforms
Load raw data into staging tables. DuckDB reads CSV, Parquet, and JSON natively.

```markdown
## 2. Ingestion
- [ ] 2.1 Ingest events CSV into raw_events (sql/ingestion/load_events.sql)
- [ ] 2.2 Ingest users Parquet into dim_users (sql/ingestion/load_users.sql)
```

### 3. Base tables before views, transforms in DAG order
Each transform reads from existing tables and writes to a new table or view. Order by data dependency.

```markdown
## 3. Transforms
- [ ] 3.1 Clean and deduplicate raw_events → stg_events (sql/transforms/stg_events.sql)
- [ ] 3.2 Join stg_events + dim_users → enriched_events (sql/transforms/enriched_events.sql)
- [ ] 3.3 Aggregate enriched_events → fact_orders (sql/transforms/build_fact_orders.sql)
```

### 4. Aggregations and exports last
Summary views and data exports depend on fully transformed data.

```markdown
## 4. Aggregations
- [ ] 4.1 Create daily_order_summary view (sql/aggregations/daily_order_summary.sql)
- [ ] 4.2 Create user_lifetime_value view (sql/aggregations/user_ltv.sql)

## 5. Exports
- [ ] 5.1 Export fact_orders to Parquet (sql/exports/export_orders.sql)
- [ ] 5.2 Export daily_order_summary to CSV (sql/exports/export_daily_summary.sql)
```

### 5. Pipeline orchestration ties it together
A runner script or Makefile executes SQL files in dependency order.

```markdown
## 6. Orchestration
- [ ] 6.1 Create pipeline runner that executes SQL files in order (src/pipeline.py)
- [ ] 6.2 Add CLI arguments for partial runs and dry-run mode
```

### 6. Data quality tests validate outputs
Assertions on row counts, null checks, uniqueness, and value ranges.

```markdown
## 7. Data Quality
- [ ] 7.1 Assert raw_events row count > 0 after ingestion
- [ ] 7.2 Assert fact_orders has no null user_ids
- [ ] 7.3 Assert daily_order_summary dates are contiguous
```

## Common Pitfalls

- **Don't create views before source tables exist** — views reference tables; the DDL for source tables must run first
- **Separate ingestion from transformation** — loading raw data and cleaning/joining are distinct steps with different failure modes
- **Use Parquet for intermediates** — when pipelines grow large, materialize intermediate results as Parquet files rather than keeping everything in-memory
- **DuckDB is embedded, not client/server** — there is no connection string to a remote server; DuckDB runs in-process with a local file or in-memory database
- **Don't mix DDL and DML in one file** — table creation (`CREATE TABLE`) and data loading (`INSERT`, `COPY`) are separate tasks

> For general data design principles (normalization, indexes, engine selection), see `principles-core.md`.
