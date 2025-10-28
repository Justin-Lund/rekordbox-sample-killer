### Kill Rekordbox Samples ###
### Gets rid of those annoying auto-added RekordBox samples. Simply set your RekordBox directory in the $basePath variable below if it differs from default, & run this script every time you update. ###

### Script Author: Martian Moon | https://soundcloud.com/martianmoon

# ------------------------------------------------------------------------ #

# Path to the RekordBox installation directory (adjust as needed)
$basePath = "C:\Program Files\rekordbox"

# ------------------------------------------------------------------------ #

# Junk RekordBox files to kill
$junkFiles = @(
    "DemoTrack.zip",
    "GROOVE_CIRCUIT_FACTORY_SAMPLES.spp",
    "MERGE FX.zip",
    "OSC_SAMPLER.zip"
)

# Match folders like "rekordbox 7.1.3", "rekordbox 7.12.0", etc.
$versionDirs = Get-ChildItem -Path $basePath -Directory | Where-Object {
    $_.Name -match '^rekordbox \d+\.\d+\.\d+$'
}

if (-not $versionDirs) {
    Write-Error "No version directories found in '$basePath'."
    exit 1
}

foreach ($dir in $versionDirs) {
    $versionPath = Join-Path $basePath $dir.Name
    Write-Output "`n==> Processing: $($dir.Name)"

    foreach ($file in $junkFiles) {
        $fullPath = Join-Path $versionPath $file
        $oldPath = "$fullPath.old"

        if (Test-Path $oldPath) {
            Write-Output "Already Killed: $file"
        }
        elseif (Test-Path $fullPath) {
            Rename-Item -Path $fullPath -NewName ($file + ".old") -Force
            Write-Output "Killed: $file -> $($file).old"
        }
        else {
            Write-Output "Not found: $file"
        }
    }
}
