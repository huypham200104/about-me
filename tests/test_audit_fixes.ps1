param()

$baseDir = if (Test-Path "about-me/css/style.css") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$css = Get-Content -Raw (Join-Path $baseDir "css/style.css")
$js = Get-Content -Raw (Join-Path $baseDir "js/main.js")

# 1. Test Issue 1 & 3: Print styles reset CSS variables and avoid page breaks
if (-not ($css -match "@media print\s*\{[^}]*\[data-theme=""dark""\]")) {
    Write-Error "FAIL: @media print does not override [data-theme='dark'] variables"
    exit 1
}
if (-not ($css.Contains("@page"))) {
    Write-Error "FAIL: Missing @page declaration in CSS"
    exit 1
}
if (-not ($css.Contains("break-inside: avoid"))) {
    Write-Error "FAIL: Missing 'break-inside: avoid' for print pagination"
    exit 1
}

# 2. Test Issue 2: Button text contrast in dark mode
if (-not ($css.Contains("--btn-primary-text"))) {
    Write-Error "FAIL: Missing --btn-primary-text custom property for WCAG contrast"
    exit 1
}

# 3. Test Issue 4: Safe storage in main.js
if (-not ($js.Contains("safeGetStorage") -and $js.Contains("safeSetStorage"))) {
    Write-Error "FAIL: Missing safe localStorage wrapper functions in main.js"
    exit 1
}

Write-Output "PASS: All audit fix assertions satisfied"
exit 0
