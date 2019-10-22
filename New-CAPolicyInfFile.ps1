function New-CAPolicyInfFile {
    [CmdletBinding()]
    param (
        [ValidateScript({
            if (Test-Path $_)
            {
                return $true
            }
            else
            {
                throw "Directory $_ does not exist!"
            }
        })]
        [string]$Directory = '.',

        [Parameter(Mandatory)]
        [ValidateSet(2048,4096)]
        [int]$RenewalKeyLength,

        [ValidateSet('months','years')]
        [string]$RenewalValidityPeriod = 'years',

        [Parameter(Mandatory)]
        [ValidateRange(1,100)]
        [int]$RenewalValidityPeriodUnits,

        [Parameter(Mandatory)]
        [ValidateSet('hours','weeks','months','years')]
        [string]$CRLPeriod,

        [Parameter(Mandatory)]
        [ValidateRange(1,1000)]
        [int]$CRLPeriodUnits,

        [ValidateSet('hours','weeks','months','years')]
        [string]$CRLOverlapPeriod = 'weeks',

        [ValidateRange(1,1000)]
        [int]$CRLOverlapUnits = 0,

        [ValidateSet('hours','weeks','months','years')]
        [string]$CRLDeltaPeriod = 'hours',

        [ValidateRange(1,1000)]
        [int]$CRLDeltaPeriodUnits = 0

    )

    $FileName = 'CAPolicy.inf'

    New-Item -Path $Directory -Name $FileName -ItemType File -Force | Out-Null

    $FileContent = @"
    [Version]
    Signature="`$Windows NT$"
    
    [certsrv_server]
    Renewalkeylength=$RenewalKeyLength
"@

    Set-Content -Path "$Directory\$FileName" -Value $FileContent

    Write-Output $FileContent
}

$NewFileInfo = New-CAPolicyInfFile -RenewalKeyLength 4096 -RenewalValidityPeriodUnits 5 -CRLPeriod hours -RenewalValidityPeriod months -CRLPeriodUnits 10
