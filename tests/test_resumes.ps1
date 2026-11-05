param()

$baseDir = if (Test-Path "about-me/index.html") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$target = Join-Path $baseDir "index.html"

if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}

$content = Get-Content -Raw $target

# Check English CV content
$enTokens = @(
    "Pham Ngoc Huy",
    "Profile Summary",
    "Work Experience",
    "Education &amp; Certifications",
    "Skills &amp; Technologies",
    "cv-panel-en",
    "window.print()"
)
foreach ($token in $enTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing English CV token in index.html: '$token'"
        exit 1
    }
}

# Check Vietnamese CV content
$viTokens = @(
    "Phạm Ngọc Huy",
    "Tóm tắt năng lực",
    "Kinh nghiệm làm việc",
    "Học vấn",
    "Kỹ năng chuyên môn",
    "cv-panel-vi",
    "btn-drive-cv",
    "window.print()"
)
foreach ($token in $viTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing Vietnamese CV token in index.html: '$token'"
        exit 1
    }
}

# Check Tab switcher
if (-not $content.Contains("cv-tab-btn") -or -not $content.Contains('data-tab="vi"') -or -not $content.Contains('data-tab="en"')) {
    Write-Error "FAIL: Missing CV language tab switcher in index.html"
    exit 1
}

Write-Output "PASS: Integrated CV in index.html contains complete Vietnamese & English sections with tabs and Drive links"
exit 0
