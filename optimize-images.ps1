# Image Optimization Script for DesiBites
# This script compresses JPG images and can convert to WebP (if ImageMagick is installed)

$imagePath = "c:\Users\91768\OneDrive\Documents\webPage\images"

Write-Host "=== DesiBites Image Optimization ===" -ForegroundColor Cyan
Write-Host ""

# Get all JPG images and their sizes
$images = Get-ChildItem -Path $imagePath -Filter "*.jpg"
$totalOriginalSize = 0

Write-Host "Current Image Sizes:" -ForegroundColor Yellow
foreach ($img in $images) {
    $sizeMB = [math]::Round($img.Length / 1MB, 2)
    $totalOriginalSize += $img.Length
    $status = if ($sizeMB -gt 0.5) { "[!] NEEDS OPTIMIZATION" } else { "[OK]" }
    Write-Host "  $($img.Name): $sizeMB MB $status"
}

Write-Host ""
Write-Host "Total size: $([math]::Round($totalOriginalSize / 1MB, 2)) MB" -ForegroundColor Yellow
Write-Host ""

# Check if ImageMagick is available
$magickAvailable = $null -ne (Get-Command "magick" -ErrorAction SilentlyContinue)

if ($magickAvailable) {
    Write-Host "ImageMagick detected! Converting and optimizing images..." -ForegroundColor Green
    
    foreach ($img in $images) {
        $sizeMB = [math]::Round($img.Length / 1MB, 2)
        
        if ($sizeMB -gt 0.1) {
            $outputPath = $img.FullName
            $backupPath = $img.FullName + ".backup"
            
            # Create backup
            Copy-Item $img.FullName $backupPath -Force
            
            # Optimize: resize to max 800px width, quality 80
            Write-Host "Optimizing: $($img.Name)..." -ForegroundColor Cyan
            & magick $img.FullName -resize "800x>" -quality 80 -strip $outputPath
            
            $newSize = (Get-Item $outputPath).Length
            $savings = [math]::Round(($img.Length - $newSize) / 1MB, 2)
            Write-Host "  Saved: $savings MB" -ForegroundColor Green
        }
    }
    
    # Show new total
    $newTotal = (Get-ChildItem -Path $imagePath -Filter "*.jpg" | Measure-Object -Property Length -Sum).Sum
    Write-Host ""
    Write-Host "New total size: $([math]::Round($newTotal / 1MB, 2)) MB" -ForegroundColor Green
    Write-Host "Total savings: $([math]::Round(($totalOriginalSize - $newTotal) / 1MB, 2)) MB" -ForegroundColor Green
    
} else {
    Write-Host "ImageMagick not found. Using alternative compression..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To install ImageMagick, run:" -ForegroundColor Cyan
    Write-Host "  winget install ImageMagick.ImageMagick" -ForegroundColor White
    Write-Host ""
    Write-Host "Or manually compress images using:" -ForegroundColor Cyan
    Write-Host "  1. https://squoosh.app (recommended)" -ForegroundColor White
    Write-Host "  2. https://tinypng.com" -ForegroundColor White
    Write-Host ""
    Write-Host "Target sizes:" -ForegroundColor Yellow
    Write-Host "  - Thumbnail images (cards): < 50KB each" -ForegroundColor White
    Write-Host "  - Detail page images: < 150KB each" -ForegroundColor White
    Write-Host ""
    
    # List images that need optimization
    Write-Host "Images requiring compression:" -ForegroundColor Red
    foreach ($img in $images) {
        $sizeKB = [math]::Round($img.Length / 1KB, 0)
        if ($sizeKB -gt 100) {
            Write-Host "  - $($img.Name): $sizeKB KB -> target < 100KB" -ForegroundColor Red
        }
    }
}

Write-Host ""
Write-Host "Script complete!" -ForegroundColor Green
