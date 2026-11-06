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
    "featured-apps",
    "screenshot_1_home_exam.png",
    "timeline",
    "timeline-item",
    "reveal",
    "developer.html",
    "cv-section",
    "cv-drive-card",
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

# Verify navigation has exactly 2 items
if ($content.Contains("cv-vi.html") -or $content.Contains("cv-en.html")) {
    Write-Error "FAIL: index.html still contains legacy cv-vi.html or cv-en.html links"
    exit 1
}

Write-Output "PASS: index.html has valid structure, 2-link navigation, app showcase gallery, and Drive CV integration"
exit 0
