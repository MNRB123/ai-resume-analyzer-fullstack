<#
.SYNOPSIS
  Optional portfolio polish: MIT LICENSE, README live-demo URLs, GitHub topics, reminders for pin + deploy.

.PARAMETER RepoRoot
  Path to your local clone (default: repo folder next to this script's parent).

.PARAMETER GitHubUser
  Your GitHub username (default: MNRB123).

.PARAMETER RepoName
  Repository name (default: ai-resume-analyzer-fullstack).

.PARAMETER FrontendUrl
  After you deploy frontend, pass e.g. https://your-app.vercel.app

.PARAMETER BackendUrl
  After you deploy backend, pass e.g. https://your-api.onrender.com

.PARAMETER GitHubToken
  Personal Access Token (classic) with repo scope, OR use env GITHUB_TOKEN.
  Required only for -SetTopics. Get one: GitHub -> Settings -> Developer settings -> PATs.

.EXAMPLE
  .\scripts\polish-github-portfolio.ps1 -RepoRoot "C:\Users\mramb\AI-Resume-Analyzer-Fullstack"

.EXAMPLE
  .\scripts\polish-github-portfolio.ps1 -FrontendUrl "https://myapp.vercel.app" -BackendUrl "https://myapi.render.com" -CommitAndPush

.EXAMPLE
  $env:GITHUB_TOKEN = "ghp_...."
  .\scripts\polish-github-portfolio.ps1 -SetTopics
#>

[CmdletBinding()]
param(
  [string] $RepoRoot = (Split-Path $PSScriptRoot -Parent),
  [string] $GitHubUser = "MNRB123",
  [string] $RepoName = "ai-resume-analyzer-fullstack",
  [string] $FrontendUrl = "",
  [string] $BackendUrl = "",
  [switch] $CommitAndPush,
  [switch] $SetTopics
)

$ErrorActionPreference = "Stop"

# Default repo root: parent of scripts/ = project root when script lives in repo
if (-not (Test-Path (Join-Path $RepoRoot ".git"))) {
  $RepoRoot = Split-Path $PSScriptRoot -Parent
}

if (-not (Test-Path (Join-Path $RepoRoot ".git"))) {
  Write-Error "Not a git repo at RepoRoot: $RepoRoot`nPass -RepoRoot 'C:\Users\mramb\AI-Resume-Analyzer-Fullstack'"
}

$readme = Join-Path $RepoRoot "README.md"
if (-not (Test-Path $readme)) { Write-Error "README.md not found: $readme" }

# --- MIT LICENSE (create if missing next to README) ---
$licensePath = Join-Path $RepoRoot "LICENSE"
if (-not (Test-Path $licensePath)) {
  @"
MIT License

Copyright (c) 2026 Mukesh

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@ | Set-Content -Path $licensePath -Encoding utf8
  Write-Host "Created LICENSE (MIT) at $licensePath" -ForegroundColor Green
} else {
  Write-Host "LICENSE already exists, skipping." -ForegroundColor Yellow
}

# --- README: Live Demo URLs ---
$content = Get-Content $readme -Raw -Encoding utf8
if ($FrontendUrl) {
  $content = $content -replace '(?m)^- Frontend:.*$', "- Frontend: $FrontendUrl"
}
if ($BackendUrl) {
  $content = $content -replace '(?m)^- Backend API:.*$', "- Backend API: $BackendUrl"
}
if ($FrontendUrl -or $BackendUrl) {
  Set-Content -Path $readme -Value $content.TrimEnd() -Encoding utf8 -NoNewline
  Add-Content -Path $readme -Value "`n" -Encoding utf8
  Write-Host "Updated README.md Live Demo lines." -ForegroundColor Green
} else {
  Write-Host "Skipped README Live Demo (pass -FrontendUrl and/or -BackendUrl after deploy)." -ForegroundColor Cyan
}

# --- GitHub Topics via REST API ---
if ($SetTopics) {
  $token = $env:GITHUB_TOKEN
  if (-not $token) { Write-Error "Set GITHUB_TOKEN env var or use GitHub CLI: gh auth login" }
  $topics = @(
    "nextjs", "react", "nodejs", "express", "mongodb", "mongoose",
    "openai", "rag", "resume", "ats", "portfolio", "fullstack"
  ) | Select-Object -Unique
  $bodyObj = @{ names = $topics }
  $json = $bodyObj | ConvertTo-Json -Compress
  $headers = @{
    Authorization = "Bearer $token"
    Accept = "application/vnd.github+json"
    "X-GitHub-Api-Version" = "2022-11-28"
  }
  $uri = "https://api.github.com/repos/$GitHubUser/$RepoName/topics"
  Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $json -ContentType "application/json"
  Write-Host "Topics set on GitHub: $($topics -join ', ')" -ForegroundColor Green
} else {
  Write-Host "Skipped topics (run with -SetTopics and GITHUB_TOKEN after creating a PAT)." -ForegroundColor Cyan
}

# --- Git commit + push ---
if ($CommitAndPush) {
  Push-Location $RepoRoot
  try {
    git add LICENSE README.md 2>$null
    git status
    git commit -m "chore: add MIT license and/or update live demo links" 2>$null
    if ($LASTEXITCODE -ne 0) { Write-Host "Nothing to commit or commit failed (check git status)." -ForegroundColor Yellow }
    else { git push origin main }
  } finally {
    Pop-Location
  }
}

Write-Host ""
Write-Host "=== Manual steps (browser) ===" -ForegroundColor Magenta
Write-Host "1) Pin repo: https://github.com/$GitHubUser -> Profile -> Customize your pins -> select $RepoName"
Write-Host "2) Deploy frontend (Vercel/Netlify) and backend (Render/AWS); then re-run this script with -FrontendUrl -BackendUrl -CommitAndPush"
Write-Host "3) Or set topics with GitHub CLI: gh repo edit $GitHubUser/$RepoName --add-topic nextjs --add-topic express ..."
Write-Host ""
