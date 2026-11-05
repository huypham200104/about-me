param()

Write-Host "=== RUNNING COMPREHENSIVE VERIFICATION SUITE FOR ABOUT-ME WEBSITE ===" -ForegroundColor Cyan

$baseDir = if (Test-Path "about-me/index.html") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$htmlFiles = @("index.html", "developer.html")
$allPassed = $true

# 1. Check all expected HTML files exist
foreach ($file in $htmlFiles) {
    $path = Join-Path $baseDir $file
    if (-not (Test-Path $path)) {
        Write-Error "FAIL: Missing file $path"
        $allPassed = $false
    } else {
        Write-Host "✓ Exists: $file" -ForegroundColor Green
    }
}

# 1.1 Verify deleted CV files do NOT exist (project reduced to 2 pages)
$deprecatedFiles = @("cv-en.html", "cv-vi.html")
foreach ($dep in $deprecatedFiles) {
    $path = Join-Path $baseDir $dep
    if (Test-Path $path) {
        Write-Error "FAIL: Deprecated file $path should have been removed"
        $allPassed = $false
    } else {
        Write-Host "✓ Verified removed: $dep" -ForegroundColor Green
    }
}

# 2. Check Core config, CSS, JS, Favicon exist
$coreFiles = @("config.js", "css/style.css", "js/main.js", "assets/favicon.svg", "assets/my-logo-chplay.png", "assets/background-chplay.jpg")
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
    if (-not $content.Contains("config.js")) {
        Write-Error "FAIL: $file missing config.js link"
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

# 5. Check JS & Config Syntax
$jsCheck = node --check (Join-Path $baseDir "js/main.js") 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "FAIL: js/main.js syntax error: $jsCheck"
    $allPassed = $false
} else {
    Write-Host "✓ js/main.js syntax is 100% valid" -ForegroundColor Green
}

$cfgCheck = node --check (Join-Path $baseDir "config.js") 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "FAIL: config.js syntax error: $cfgCheck"
    $allPassed = $false
} else {
    Write-Host "✓ config.js syntax is 100% valid" -ForegroundColor Green
}

# 6. Check Navigation links between index.html and developer.html
$indexContent = Get-Content -Raw (Join-Path $baseDir "index.html")
$devContent = Get-Content -Raw (Join-Path $baseDir "developer.html")

if (-not $indexContent.Contains("developer.html") -or -not $devContent.Contains("index.html")) {
    Write-Error "FAIL: Reciprocal navigation links between index.html and developer.html missing"
    $allPassed = $false
} else {
    Write-Host "✓ Reciprocal links between index.html and developer.html are verified" -ForegroundColor Green
}

# 7. Check Integrated CV and Dual Drive links (VI & EN) in index.html
if (-not $indexContent.Contains("cv-panel-vi") -or -not $indexContent.Contains("cv-panel-en")) {
    Write-Error "FAIL: index.html missing integrated CV panels (VI and EN)"
    $allPassed = $false
} else {
    Write-Host "✓ Integrated CV panels in index.html verified" -ForegroundColor Green
}

if (-not $indexContent.Contains("driveCvViUrl") -or -not $indexContent.Contains("driveCvEnUrl")) {
    Write-Error "FAIL: index.html missing dual Google Drive CV links for VI & EN"
    $allPassed = $false
} else {
    Write-Host "✓ Dual Google Drive CV buttons (Tiếng Việt & English) in index.html verified" -ForegroundColor Green
}

# 8. Check Published App GPLX A1 in developer.html
if (-not $devContent.Contains("GPLX A1 - 200 Câu") -or -not $devContent.Contains("vn.huypham.gplx.a1")) {
    Write-Error "FAIL: developer.html missing GPLX A1 - 200 Câu showcase"
    $allPassed = $false
} else {
    Write-Host "✓ Published CH Play App GPLX A1 in developer.html verified" -ForegroundColor Green
}

if (-not $allPassed) {
    Write-Error "Comprehensive verification suite FAILED"
    exit 1
}

Write-Host "`n>>> ALL VERIFICATION CHECKS PASSED SUCCESSFULLY! <<<" -ForegroundColor Cyan
exit 0
