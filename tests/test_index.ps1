param()

$baseDir = if (Test-Path "about-me/index.html") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$target = Join-Path $baseDir "index.html"

if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}

$content = Get-Content -Raw $target

$requiredTokens = @(
    "<!DOCTYPE html>",
    "<html",
    "<meta name=""viewport""",
    "assets/favicon.svg",
    "css/style.css",
    "config.js",
    "js/main.js",
    "Phạm Ngọc Huy",
    "PNH",
    "theme-toggle",
    "nav-toggle",
    "timeline",
    "timeline-item",
    "reveal",
    "developer.html",
    "cv-section",
    "cv-panel-vi",
    "cv-panel-en",
    "btn-drive-cv",
    "driveCvViUrl",
    "driveCvEnUrl"
)

foreach ($token in $requiredTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing required token in index.html: '$token'"
        exit 1
    }
}

Write-Output "PASS: index.html has valid structure and all required components (including merged CV and Drive config)"
exit 0
