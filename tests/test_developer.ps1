param()
$target = "about-me/developer.html"
if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}

$content = Get-Content -Raw $target

$requiredTokens = @(
    "<!DOCTYPE html>",
    "developer-intro",
    "card-grid",
    "app-card",
    "badge-android",
    "badge-crossplatform",
    "tech-tags",
    "github-callout",
    "https://github.com/huypham200104",
    "Google Play",
    "reveal"
)

foreach ($token in $requiredTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing required token in developer.html: '$token'"
        exit 1
    }
}

Write-Output "PASS: developer.html contains all required sections and features"
exit 0
