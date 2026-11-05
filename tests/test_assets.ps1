param()
$baseDir = if (Test-Path "about-me/assets/favicon.svg") { "about-me" } else { (Resolve-Path "$PSScriptRoot/..").Path }
$target = Join-Path $baseDir "assets/favicon.svg"
if (-not (Test-Path $target)) {
    Write-Error "FAIL: $target does not exist"
    exit 1
}
try {
    [xml]$xml = Get-Content -Raw $target
    if ($xml.svg.viewBox -ne "0 0 64 64") {
        Write-Error "FAIL: viewBox is not '0 0 64 64'"
        exit 1
    }
    Write-Output "PASS: favicon.svg is valid SVG with viewBox 0 0 64 64"
    exit 0
} catch {
    Write-Error "FAIL: Invalid XML/SVG: $_"
    exit 1
}
