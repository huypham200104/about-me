param()

Write-Host "=== RUNNING COMPREHENSIVE VERIFICATION SUITE FOR ABOUT-ME WEBSITE ===" -ForegroundColor Cyan

$baseDir = "about-me"
$htmlFiles = @("index.html", "cv-en.html", "cv-vi.html", "developer.html")
$allPassed = $true

# 1. Check all HTML files exist
foreach ($file in $htmlFiles) {
    $path = Join-Path $baseDir $file
    if (-not (Test-Path $path)) {
        Write-Error "FAIL: Missing file $path"
        $allPassed = $false
    } else {
        Write-Host "✓ Exists: $file" -ForegroundColor Green
    }
}

# 2. Check CSS, JS, Favicon exist
$coreFiles = @("css/style.css", "js/main.js", "assets/favicon.svg")
foreach ($core in $coreFiles) {
    $path = Join-Path $baseDir $core
    if (-not (Test-Path $path)) {
        Write-Error "FAIL: Missing core asset $path"
        $allPassed = $false
    } else {
        Write-Host "✓ Exists: $core" -ForegroundColor Green
    }
}

# 3. Check HTML linkage & meta tags
foreach ($file in $htmlFiles) {
    $content = Get-Content -Raw (Join-Path $baseDir $file)
    
    if (-not $content.Contains("assets/favicon.svg")) {
        Write-Error "FAIL: $file missing favicon link"
        $allPassed = $false
    }
    if (-not $content.Contains("css/style.css")) {
        Write-Error "FAIL: $file missing css/style.css link"
        $allPassed = $false
    }
    if (-not $content.Contains("js/main.js")) {
        Write-Error "FAIL: $file missing js/main.js link"
        $allPassed = $false
    }
    if (-not $content.Contains('name="viewport"')) {
        Write-Error "FAIL: $file missing viewport meta tag"
        $allPassed = $false
    }
    if (-not $content.Contains('charset="UTF-8"')) {
        Write-Error "FAIL: $file missing UTF-8 charset"
        $allPassed = $false
    }
}
Write-Host "✓ All HTML files have valid meta tags and asset linkages" -ForegroundColor Green

# 4. Check CSS Constraints
$cssContent = Get-Content -Raw (Join-Path $baseDir "css/style.css")
if ($cssContent -match "!important") {
    Write-Error "FAIL: Found '!important' in CSS"
    $allPassed = $false
} else {
    Write-Host "✓ CSS has NO '!important' rules" -ForegroundColor Green
}

if (-not $cssContent.Contains("@media print")) {
    Write-Error "FAIL: CSS missing print stylesheet"
    $allPassed = $false
} else {
    Write-Host "✓ CSS includes @media print rules" -ForegroundColor Green
}

# 5. Check JS Syntax
$jsCheck = node --check (Join-Path $baseDir "js/main.js") 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "FAIL: js/main.js syntax error: $jsCheck"
    $allPassed = $false
} else {
    Write-Host "✓ js/main.js syntax is 100% valid" -ForegroundColor Green
}

# 6. Check Reciprocal Internal Links
$cvVi = Get-Content -Raw (Join-Path $baseDir "cv-vi.html")
$cvEn = Get-Content -Raw (Join-Path $baseDir "cv-en.html")
if (-not $cvVi.Contains("cv-en.html") -or -not $cvEn.Contains("cv-vi.html")) {
    Write-Error "FAIL: Reciprocal links between cv-vi.html and cv-en.html missing"
    $allPassed = $false
} else {
    Write-Host "✓ Reciprocal links between Vietnamese & English CV are verified" -ForegroundColor Green
}

if (-not $allPassed) {
    Write-Error "Comprehensive verification suite FAILED"
    exit 1
}

Write-Host "`n>>> ALL VERIFICATION CHECKS PASSED SUCCESSFULLY! <<<" -ForegroundColor Cyan
exit 0
