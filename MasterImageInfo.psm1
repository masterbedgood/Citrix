Add-PSSnapin citrix*

#Requires -pssnapin Citrix.MachineCreation.Admin.V2

<#
.SYNOPSIS
Gets a list of all or provided Citrix Images' master images and the current snapshot.
#>
function Get-CitrixMasterImage
{
    param(
        [string[]]$CitrixImage
    )

    #Defines an empty object to append return information - this is used for the final return object
    $CollectionObject = @()

    #If a value(s) is provided for the CitrixImage string array, updates CollectionObject with only values matching that criteria
    if($CitrixImage)
    {
        $CollectionObject += $CitrixImage | %{Get-ProvScheme -ProvisioningSchemeName $_ | Select-Object ProvisioningSchemeName, MasterImageVM}
    }
    #If no value provided for CitrixImage, gets information on all Citrix images
    else{$CollectionObject += (Get-ProvScheme | Select-Object ProvisioningSchemeName, MasterImageVM)}

    <#
        Runs through each item in the Collection Object & creates a return object containing
            > the image name
            > master image
            > current snapshot
        MasterImage & Snapshot parsed from MasterImageVM property value
    #>
    $CollectionObject | %{
        New-Object PSObject -Property @{
            CitrixImage = $_.ProvisioningSchemeName
            MasterImage = ($_.MasterImageVM -Split '\\' | Select-String '.vm')
            CurrentSnapshot = ($_.MasterImageVM -Split '\\' | Select-Object -Last 1)
        } | Select-Object CitrixImage, MasterImage, CurrentSnapshot
    }
}
