param()
$baseDir = if (Test-Path "about-me/js/main.js") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$target = Join-Path $baseDir "js/main.js"
if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}

# Run node --check
$nodeCheck = node --check $target 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "FAIL: node --check failed: $nodeCheck"
    exit 1
}

$content = Get-Content -Raw $target
$requiredTokens = @(
    "pnh_theme",
    "prefers-color-scheme",
    "theme-toggle",
    "IntersectionObserver",
    "reveal",
    "is-visible",
    "nav-toggle",
    "is-open",
    "SITE_CONFIG",
    "initConfigLinks",
    "initCvTabs"
)

foreach ($token in $requiredTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing required JS token or logic: '$token'"
        exit 1
    }
}

Write-Output "PASS: main.js has valid syntax and includes all controller modules"
exit 0
