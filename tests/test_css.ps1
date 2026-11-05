param()
$baseDir = if (Test-Path "about-me/css/style.css") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$target = Join-Path $baseDir "css/style.css"
if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}

$content = Get-Content -Raw $target

# Check no !important
if ($content -match "!important") {
    Write-Error "FAIL: Found '!important' in CSS, which is disallowed by constraints"
    exit 1
}

# Check required selectors and tokens
$requiredTokens = @(
    ":root",
    '[data-theme="dark"]',
    "--color-primary",
    "--bg-body",
    "--text-primary",
    "--color-accent",
    ".site-header",
    ".nav-container",
    ".theme-toggle",
    ".timeline",
    ".cv-sheet",
    ".reveal",
    "@media (max-width: 768px)",
    "@media print"
)

foreach ($token in $requiredTokens) {
    if (-not $content.Contains($token)) {
        Write-Error "FAIL: Missing required CSS token or selector: '$token'"
        exit 1
    }
}

Write-Output "PASS: style.css conforms to all design system and constraint requirements"
exit 0
