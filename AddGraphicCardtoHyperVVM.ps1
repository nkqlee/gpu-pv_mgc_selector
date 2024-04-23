$GetVM = $(Get-VM).Name
ForEach ($vm in $GetVM) {
    $confirmation = Read-Host "Are you sure you want to proceed with the" $vm "Virtual Machine?"
    if ($confirmation.ToLower() -eq 'y') {
        $VMAdapter = (Get-VMGpuPartitionAdapter -VMName $vm -ErrorAction SilentlyContinue)
        if ($VMAdapter) {
            Remove-VMGpuPartitionAdapter -VMName $vm -ErrorAction SilentlyContinue
        }
        $DisplayCards = Get-PnpDevice -Class Display -Status Ok | Select-Object FriendlyName, @{n = 'InstanceId'; e = { $_.InstanceId.Split('\')[1] } }
        
        :loop1
        ForEach ($DisplayCard in $DisplayCards) {
            :loop2
            ForEach ($GPU in $(Get-VMHostPartitionableGpu)) {
                if ( ($GPU).Name -Match $($DisplayCard).InstanceId) {
                    $confirmation1 = Read-Host "Are you sure you want to add a" $($DisplayCard).FriendlyName "to the" VM [$vm] "?"
                    if ($confirmation1.ToLower() -eq 'y') {
                        Add-VMGpuPartitionAdapter -VMName $vm -InstancePath ($GPU).Name
                        $ParConfig = @{
                            MinRsrc     = 1000000000
                            MaxRsrc     = 1000000000
                            OptimalRsrc = 1000000000
                        }
                        Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionVRAM $ParConfig.MinRsrc -MaxPartitionVRAM $ParConfig.MaxRsrc -OptimalPartitionVRAM $ParConfig.OptimalRsrc
                        Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionEncode $ParConfig.MinRsrc -MaxPartitionEncode $ParConfig.MaxRsrc -OptimalPartitionEncode $ParConfig.OptimalRsrc
                        Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionDecode $ParConfig.MinRsrc -MaxPartitionDecode $ParConfig.MaxRsrc -OptimalPartitionDecode $ParConfig.OptimalRsrc
                        Set-VMGpuPartitionAdapter -VMName $vm -MinPartitionCompute $ParConfig.MinRsrc -MaxPartitionCompute $ParConfig.MaxRsrc -OptimalPartitionCompute $ParConfig.OptimalRsrc
                        $SetVMParams = @{
                            VMName                      = $vm
                            GuestControlledCacheTypes   = $true
                            AutomaticStopAction         = "TurnOff"
                            AutomaticCheckpointsEnabled = $False
                            LowMemoryMappedIoSpace      = 3GB
                            HighMemoryMappedIoSpace     = 33280Mb
                        }
                        Set-VM @SetVMParams
                        break loop1
                    }
                }
            }
        }
    }
}

