## Railway

- Project: `cosmos` (production).
- Services: `portal`, `assistant`, `context`, `bridge` (Core group).
- CLI: `railway` (token stored in Railway vars; no local .env needed).
- Key vars (shared env): `RAILWAY_TOKEN`, `SPECTRA_RAILWAY_COSMOS_PROJECT_ID` (ids), plus service-specific settings stored in Railway.
- Domains: `spectradatasolutions.com` on `portal` (port 8080). Assistant uses SSH only (no HTTP).
- Docs: https://docs.railway.com/

Notes

- Deploy portal from repo root: `railway up --service portal --environment production --path-as-root portal`.
- Assistant deploy: `railway up --service assistant --environment production --path-as-root Core/infrastructure/assistant`.

### API (GraphQL)

- Endpoint: `https://backboard.railway.app/graphql/v2`
- Auth: Bearer token (same token the Railway CLI uses, from `~/.railway/config.json`).
- No separate REST API; everything is via GraphQL/CLI.

Example: get project status (PowerShell)

```powershell
$token = (Get-Content "$env:USERPROFILE\.railway\config.json" | ConvertFrom-Json).user.token
$query = @'
query Status {
  project(id: "e812e11e-c5f6-4398-8eca-af9bd07219a2") {
    name
    services { edges { node { name serviceInstances { edges { node { latestDeployment { status } } } } } } }
  }
}
'@
Invoke-RestMethod -Method Post -Uri https://backboard.railway.app/graphql/v2 `
  -Headers @{ Authorization = "Bearer $token" } `
  -Body (@{ query = $query } | ConvertTo-Json -Compress) `
  -ContentType "application/json"
```

Example: update service instance settings

```powershell
$token = (Get-Content "$env:USERPROFILE\.railway\config.json" | ConvertFrom-Json).user.token
$mutation = @'
mutation UpdateSvc($serviceId: String!, $environmentId: String!, $input: ServiceInstanceUpdateInput!) {
  serviceInstanceUpdate(serviceId: $serviceId, environmentId: $environmentId, input: $input)
}
'@
$vars = @{
  serviceId = "<service-id>"
  environmentId = "<env-id>"
  input = @{
    rootDirectory     = "assistant"
    dockerfilePath    = "Dockerfile"
    healthcheckPath   = "/"
    healthcheckTimeout = 10
  }
}
$body = @{ query = $mutation; variables = $vars } | ConvertTo-Json -Compress -Depth 10
Invoke-RestMethod -Method Post -Uri https://backboard.railway.app/graphql/v2 `
  -Headers @{ Authorization = "Bearer $token" } `
  -Body $body `
  -ContentType "application/json"
```
