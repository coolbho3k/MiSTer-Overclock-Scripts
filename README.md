# MiSTer FPGA Overclock Scripts

Works in conjunction with the [MiSTer FPGA Overclock Kernel](https://github.com/coolbho3k/Linux-Kernel_MiSTer/releases/) to overclock or underclock your MiSTer system.

## Warning
- Active cooling or very good passive cooling required!
- Overclock/underclock at your own risk!
- These scripts are licensed under GPLv3, so they come with no warranty.

## How to use
Copy all the scripts to the `Scripts` directory on your SD card.

The kernel driver's default behavior is to keep the MiSTer at 800 MHz (stock) until you run one of these scripts.

- Run `set_cpu_max_1200.sh` to set max clock speed to 1.2 GHz
- Run `set_cpu_max_1000.sh` to set max clock speed to 1.0 GHz
- Run `set_cpu_max_800.sh` to set max clock speed to 800 MHz (stock)
- Run `set_cpu_max_400.sh` to set max clock speed to 400MHz
