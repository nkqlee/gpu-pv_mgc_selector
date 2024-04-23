# GPU-PV Multiple Graphic Card Selector
A project dedicated to making GPU partitioning with multiple graphics cards on Windows 11 easier

## Prerequisites:
- Windows 11 Pro, Enterprise or Education. Windows 11 on host and VM is preferred due to better compatibility
- Matched Windows versions between the host and VM. Mismatches may cause compatibility issues, blue-screens, or other issues
- Desktop Computer with dedicated NVIDIA/AMD GPU
- Hyper-V fully enabled on the Windows 11 OS
- Allow Powershell scripts to run on your system

## Instructions
  1. Execute powershell script ./AddGraphicCardtoHyperVVM.ps1
  2. Follow the instructions on the script

## Important Note
  You are required to manually copy the driver folder to C:\Windows\system32\HostDriverStore\FileRepository in the guest VM.
  
  Host Driver Location
  
  Nvidia - C:\Windows\System32\DriverStore\FileRepository\nv_dispi.inf_amd64_<guid>
  
  AMD - C:\Windows\System32\DriverStore\FileRepository\u<digit>.inf_amd64_<guid>
