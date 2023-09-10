{ pkgs, config, ... }:

{
  config = {
    # Configuring Thinkpad P53s hardware
    hardware = {
      # Configuring Bluetooth
      bluetooth.enable = true;

      # Enabling Intel microcode if needed
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

      # Configuring noVideo card
      nvidia.prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:60:0:0";
      };

      # Installing OpenGL drivers
      opengl.extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
        vaapiIntel
        vaapiVdpau
      ];

      # Configuring Trackpoint
      trackpoint = {
        enable = true;
        emulateWheel = true;
      };
    };

    # Configuring network hardware
    networking = {
      # Setting hostname for device
      hostName = "thinkpad-p53s";

      # Enabling DHCP for interfaces
      interfaces.enp0s31f6.useDHCP = true;
      interfaces.wlp0s20f3.useDHCP = true;

      # Configuring network manager
      networkmanager.enable = true;
      wireless.interfaces = [ "wlp0s20f3" ];
    };

    # Configuring some useful services for Thinkpad P53s
    services = {
      # Configuring service for fingerprint scanner
      fprintd.enable = true;

      # Configuring service for better SSD usage
      fstrim.enable = true;

      # Configuring Intel CPU throttling
      throttled = {
        enable = true;
        # LANG: ini
        extraConfig = ''
          [GENERAL]
          # Enable or disable the script execution
          Enabled: True
          # SYSFS path for checking if the system is running on AC power
          Sysfs_Power_Path: /sys/class/power_supply/AC*/online
          # Auto reload config on changes
          Autoreload: True
        
          ## Settings to apply while connected to Battery power
          [BATTERY]
          # Update the registers every this many seconds
          Update_Rate_s: 30
          # Max package power for time window #1
          PL1_Tdp_W: 29
          # Time window #1 duration
          PL1_Duration_s: 28
          # Max package power for time window #2
          PL2_Tdp_W: 29
          # Time window #2 duration
          PL2_Duration_S: 0.002
          # Max allowed temperature before throttling
          Trip_Temp_C: 75
          # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
          cTDP: 0
          # Disable BDPROCHOT (EXPERIMENTAL)
          Disable_BDPROCHOT: False
        
          ## Settings to apply while connected to AC power
          [AC]
          # Update the registers every this many seconds
          Update_Rate_s: 5
          # Max package power for time window #1
          PL1_Tdp_W: 29
          # Time window #1 duration
          PL1_Duration_s: 28
          # Max package power for time window #2
          PL2_Tdp_W: 29
          # Time window #2 duration
          PL2_Duration_S: 0.002
          # Max allowed temperature before throttling
          Trip_Temp_C: 75
          # Set HWP energy performance hints to 'performance' on high load (EXPERIMENTAL)
          HWP_Mode: False
          # Set cTDP to normal=0, down=1 or up=2 (EXPERIMENTAL)
          cTDP: 0
          # Disable BDPROCHOT (EXPERIMENTAL)
          Disable_BDPROCHOT: False
        
          # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)! 
          [UNDERVOLT.BATTERY]
          # CPU core voltage offset (mV)
          CORE: -100
          # Integrated GPU voltage offset (mV)
          GPU: -60
          # CPU cache voltage offset (mV)
          CACHE: -100
          # System Agent voltage offset (mV)
          UNCORE: 0
          # Analog I/O voltage offset (mV)
          ANALOGIO: 0
        
          # All voltage values are expressed in mV and *MUST* be negative (i.e. undervolt)!
          [UNDERVOLT.AC]
          # CPU core voltage offset (mV)
          CORE: -100
          # Integrated GPU voltage offset (mV)
          GPU: -60
          # CPU cache voltage offset (mV)
          CACHE: -100
          # System Agent voltage offset (mV)
          UNCORE: 0
          # Analog I/O voltage offset (mV)
          ANALOGIO: 0
        
          # [ICCMAX.AC]
          # # CPU core max current (A)
          # CORE: 
          # # Integrated GPU max current (A)
          # GPU: 
          # # CPU cache max current (A)
          # CACHE: 
        
          # [ICCMAX.BATTERY]
          # # CPU core max current (A)
          # CORE: 
          # # Integrated GPU max current (A)
          # GPU: 
          # # CPU cache max current (A)
          # CACHE: 
        '';
      };

      # Configuring service for better power management
      tlp.enable = true;

      # Configuring noVideo drivers
      xserver.videoDrivers = [ "nvidia" ];
    };

    # Setting "powersave" governor for this machine
    powerManagement.cpuFreqGovernor = "powersave";
  };
}
