param()

$baseDir = if (Test-Path "about-me/index.html") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$target = Join-Path $baseDir "index.html"

if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}

$content = Get-Content -Raw $target

# 1. Verify cv-vi.html and cv-en.html do not exist on disk
$cvViPath = Join-Path $baseDir "cv-vi.html"
$cvEnPath = Join-Path $baseDir "cv-en.html"
if (Test-Path $cvViPath) {
    Write-Error "FAIL: Legacy file cv-vi.html still exists on disk"
    exit 1
}
if (Test-Path $cvEnPath) {
    Write-Error "FAIL: Legacy file cv-en.html still exists on disk"
    exit 1
}

# 2. Check Drive CV configuration tokens and buttons
$cvTokens = @(
    "cv-section",
    "cv-drive-card",
    "btn-drive-cv-vi",
    "btn-drive-cv-en",
    "driveCvViUrl",
    "driveCvEnUrl",
    "Phạm Ngọc Huy"
)
foreach ($token in $cvTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing CV Drive token in index.html: '$token'"
        exit 1
    }
}

# 3. Verify navbar strictly contains only 2 categories (Trang chu, Developer & Apps)
$navPattern = '(?s)<nav[^>]*>.*?<ul class="nav-links"[^>]*>(.*?)</ul>.*?</nav>'
if ($content -match $navPattern) {
    $navContent = $matches[1]
    $linkCount = ([regex]::Matches($navContent, '<li\b')).Count
    if ($linkCount -ne 2) {
        Write-Error "FAIL: Navigation does not have exactly 2 links (found $linkCount)"
        exit 1
    }
}

Write-Output "PASS: Verified 2-link navigation, removed legacy cv files, and integrated Google Drive CV card in index.html"
exit 0
