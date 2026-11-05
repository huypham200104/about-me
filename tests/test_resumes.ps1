param()

$enTarget = "about-me/cv-en.html"
$viTarget = "about-me/cv-vi.html"

if (-not (Test-Path $enTarget)) {
    Write-Error "FAIL: $enTarget does not exist"
    exit 1
}
if (-not (Test-Path $viTarget)) {
    Write-Error "FAIL: $viTarget does not exist"
    exit 1
}

$enContent = Get-Content -Raw $enTarget
$viContent = Get-Content -Raw $viTarget

# Check English tokens
$enTokens = @(
    "Pham Ngoc Huy",
    "Profile Summary",
    "Work Experience",
    "Education",
    "Skills",
    "Download PDF",
    "cv-vi.html",
    "window.print()"
)
foreach ($token in $enTokens) {
    if (-not $enContent.Contains($token)) {
        Write-Error "FAIL: Missing token in cv-en.html: '$token'"
        exit 1
    }
}

# Check Vietnamese tokens
$viTokens = @(
    "Phạm Ngọc Huy",
    "Tóm tắt",
    "Kinh nghiệm làm việc",
    "Học vấn",
    "Kỹ năng",
    "Tải PDF",
    "cv-en.html",
    "window.print()"
)
foreach ($token in $viTokens) {
    if (-not $viContent.Contains($token)) {
        Write-Error "FAIL: Missing token in cv-vi.html: '$token'"
        exit 1
    }
}

Write-Output "PASS: Both cv-en.html and cv-vi.html meet structural and reciprocal link requirements"
exit 0
