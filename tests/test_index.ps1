param()
$target = "about-me/index.html"
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
    "js/main.js",
    "Phạm Ngọc Huy",
    "PNH",
    "theme-toggle",
    "nav-toggle",
    "timeline",
    "timeline-item",
    "reveal",
    "developer.html",
    "cv-vi.html",
    "cv-en.html"
)

foreach ($token in $requiredTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing required token in index.html: '$token'"
        exit 1
    }
}

Write-Output "PASS: index.html has valid structure and all required components"
exit 0
