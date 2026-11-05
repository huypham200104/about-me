param()

$baseDir = if (Test-Path "about-me/developer.html") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$target = Join-Path $baseDir "developer.html"

if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}

$content = Get-Content -Raw $target

$requiredTokens = @(
    "<!DOCTYPE html>",
    "dev-hero",
    "assets/my-logo-chplay.png",
    "GPLX A1 - 200 Câu",
    "vn.huypham.gplx.a1",
    "btn-playstore",
    "badge-android",
    "tech-tags",
    "github-callout",
    "https://github.com/huypham200104",
    "config.js",
    "reveal"
)

foreach ($token in $requiredTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing required token in developer.html: '$token'"
        exit 1
    }
}

Write-Output "PASS: developer.html contains all required sections and CH Play showcase features"
exit 0
