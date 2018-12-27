Set-StrictMode -Version Latest

# [CmdletBinding(DefaultParameterSetName = 'Parameter Set 1', 
#     SupportsShouldProcess = $false, 
#     PositionalBinding = $false,
#     HelpUri = 'https://technet.microsoft.com/en-us/library/bb613488(v=vs.85).aspx and https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.host/start-transcript?view=powershell-5.1',
#     ConfirmImpact = 'Medium')]
# [Alias('gfl')]
# [OutputType([String])]
# Param(
#     [parameter(Mandatory = $false, ParameterSetName = 'Parameter Set 1')]
#     [Alias("sfp")]
#     [string]$SearchFilePath = "\Projects",

#     [parameter(Mandatory = $false, ParameterSetName = 'Parameter Set 1')]
#     [Alias("sfex")]
#     [string[]]$SearchFileExclude = @("*.bak", "*.log", "*.txt", "*.tmp"),

#     [parameter(Mandatory = $false, ParameterSetName = 'Parameter Set 1')]
#     [Alias("r")]
#     [Switch]$SearchRecurse,

#     [Parameter(Mandatory = $false, ParameterSetName = 'Parameter Set 1')]
#     # [ValidateUserDrive()]
#     [Alias("ofp")]
#     [string]$OutputFilePath = "\Projects",

#     [Parameter(Mandatory = $false, ParameterSetName = 'Parameter Set 1')]
#     [Alias("ofn")]
#     [string]$OutputFileName = $env:COMPUTERNAME,

#     [Parameter(Mandatory = $false, ParameterSetName = 'Parameter Set 1')]
#     [ValidateSet("Short", "Long")]
#     [Alias("om")]
#     [string]$OutputMode = "Short"
# )

<#
.Synopsis
   Setup PowerShell Profile for current user and enable "Start-Transcript" as default for powershell console.
.DESCRIPTION
   Meant to be an example script for people new to PowerShell will setup PowerShell Profiles and Enable "Start-Trnscript". Also to be used as an example script to help teach novice script some baisc best practices and scripting. If you notice some best practices messsing within the script, please fill free to updated.
.EXAMPLE
   Get-FileListing10 -SearchFilePath "\Projects" -SearchRecurse -OutputFilePath "\Projects" -OutputFileName "jbdir" -OutputMode "Long" -verbose
.NOTES
   This is a script to get file information, fill free to make it even better.
.COMPONENT
   The component this cmdlet belongs to
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functisonality that best describes this cmdlet
#>
function Get-FileListing10 { 
    Param(
        [parameter(Mandatory = $false)]
        [Alias("sfp")]
        $SearchFilePath = "\Projects",

        [parameter(Mandatory = $false)]
        [Alias("sfex")]
        $SearchFileExclude = "*.bak, *.log, *.txt, *.tmp",

        [parameter(Mandatory = $false)]
        [Alias("r")]
        [Switch]$SearchRecurse,

        [Parameter(Mandatory = $false)]
        # [ValidateUserDrive()]
        [Alias("ofp")]
        $OutputFilePath = "\Projects",

        [Parameter(Mandatory = $false)]
        [Alias("ofn")]
        $OutputFileName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false)]
        [ValidateSet("Short", "Long")]
        [Alias("om")]
        $OutputMode = "Short"
    )

    Begin {
        ########################
        # Set Script variables #
        ########################

        $SearchSyntax = "Get-ChildItem -Path $($SearchFilePath) " 
        If ($SearchRecurse) {
            $SearchSyntax = $SearchSyntax + " -Recurse"
        }
        ############################
        # Display Script Variables #
        ############################
        #Clear-Host
        Write-Verbose "`$SearchSyntax = $SearchSyntax"
        Write-Verbose "`$OutputFilePath = $OutputFilePath"
        Write-Verbose "`$OutputFileName = $OutputFileName"
        Write-Verbose "`$SearchFilePath = $SearchFilePath" 
        Write-Verbose "`$SearchFileExclude = $SearchFileExclude" 
        Write-Verbose "`$SearchRecurse = $SearchRecurse" 
        Write-Verbose "`$OutputMode = $OutputMode"
    }
    Process {
        #$files = $($SearchSyntax) | Where-Object {!$_.PSIsContainer}
        $files = Invoke-Expression("$SearchSyntax") | Where-Object {!$_.PSIsContainer}
        #Process results of $files
        Write-Verbose "Step 2"

        switch ($OutputMode) {
            "Short" {
                Write-Verbose "Step 3-Short"

                $files = $files | Select-Object DirectoryName, Name, BaseName, Extension, Length 
                $files = $files | Export-Csv -notypeinformation -path "$OutputFilePath\$OutputFileName-short.csv"
            }   
            "Long" {
                Write-Verbose "Step 4-Long"

                $files = $files | Select-Object DirectoryName, Name, BaseName, Extension, CreationTime, LastWriteTime, Length 
                $files = $files | Export-Csv -notypeinformation -path "$OutputFilePath\$OutputFileName-long.csv"
            }
        }
    }
    End {
        Write-Verbose "Step End"
    }
}

##############
# Run Script #
##############
Get-FileListing10 -SearchFilePath "\" -SearchRecurse -OutputFilePath "\Projects" -OutputFileName "alldir" -OutputMode "Long" -verbose
