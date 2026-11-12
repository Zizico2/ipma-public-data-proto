# ipma-public-data-proto

Independent wire contract for IPMA website feeds under `/public-data/`.
This repository does not import or change `ipma-proto` or its documented
`/open-data/` API. Package: `ipma.public_data.v1`; service: `PublicDataService`.

`proto/` is language neutral. `rust/` builds Prost/Tonic bindings and reflection
descriptors with protox, without system protoc. Both new services consume this
crate using an exact Git SHA. Other languages can generate from the same schema.

Run `rtk just verify`. Rust is pinned in `rust-toolchain.toml`.

## Source semantics

Verified on 2026-11-12 against IPMA's website JavaScript and live JSON:

- `forecast/aggregate/{location_id}.json`: mixed hourly, three-hourly and daily
  records; select `period_hours == 1` for hourly forecasts. Do not manufacture
  missing hours or assume a fixed horizon. Never merge daily rows into hourly rows.
- `forecast/locations.json`: website location catalogue (broader than open-data).
- `districts.json`: district/island catalogue.
- `warnings/warnings_www.json`: object containing `data` and `dataAtualiza`.

Endpoint and field semantics are observed behavior, not an official API guarantee.
Source: https://www.ipma.pt/opencms/bin/scripts/otempo/prev.localidade.hora.js
Website: https://www.ipma.pt/pt/otempo/prev.localidade.hora/

All instants are UTC. Render with Europe/Lisbon or Atlantic/Azores as appropriate.
`period_hours` preserves the source `idPeriodo` even for unfamiliar codes.
Measurements use optional fields; missing/null/empty/-99 become absent. Unknown
source fields and original category codes survive in each record's `source_json`.
The website labels precipitation probability as >=0.3 mm in the preceding three
hours; it is not a per-hour probability. UTCI is kept as the named source index.

The adapter leaves cache expiry unset. Gateways own caching. Fetch time does not
mean source update time. Evolve fields additively; never reuse field numbers.
The website feeds require no API key, but reuse remains subject to IPMA's terms
and attribution. This project is not affiliated with IPMA.
