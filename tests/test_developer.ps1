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
    "dev-cover-banner",
    "dev-profile-bar",
    "Ngoc Huy 2001",
    "Một mobile developer khi rảnh sẽ thử tạo ứng dụng thú vị",
    "assets/my-logo-chplay.png",
    "assets/background-chplay.jpg",
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

# Verify navigation has exactly 2 items
if ($content.Contains("cv-vi.html") -or $content.Contains("cv-en.html")) {
    Write-Error "FAIL: developer.html still contains legacy cv-vi.html or cv-en.html links"
    exit 1
}

$navPattern = '(?s)<nav[^>]*>.*?<ul class="nav-links"[^>]*>(.*?)</ul>.*?</nav>'
if ($content -match $navPattern) {
    $navContent = $matches[1]
    $linkCount = ([regex]::Matches($navContent, '<li\b')).Count
    if ($linkCount -ne 2) {
        Write-Error "FAIL: Navigation does not have exactly 2 links (found $linkCount)"
        exit 1
    }
}

Write-Output "PASS: developer.html contains Ngoc Huy 2001 Google Play profile, CH Play app showcase, and 2-link navigation"
exit 0
