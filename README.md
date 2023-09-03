# MiSTer FPGA Overclock Scripts

Works in conjunction with the [MiSTer FPGA Overclock Kernel](https://github.com/coolbho3k/Linux-Kernel_MiSTer/releases/) to overclock or underclock your MiSTer system. The driver has been merged into the main MiSTer kernel, so after the next official kernel release, a special kernel won't be required.

## Warning
- Active cooling (heatsink + fan) or very good passive cooling (ie. aluminum passively cooled case) required!
- Overclock/underclock at your own risk!
- These scripts are licensed under GPLv3, so they come with no warranty.

## How to use
Copy all the scripts to the `Scripts` directory on your SD card.

The kernel driver's default behavior is to keep the MiSTer at 800 MHz (stock) until you run one of these scripts.

- Run `set_cpu_max_1200.sh` to set max clock speed to 1.2 GHz
- Run `set_cpu_max_1000.sh` to set max clock speed to 1.0 GHz
- Run `set_cpu_max_800.sh` to set max clock speed to 800 MHz (stock)
- Run `set_cpu_max_400.sh` to set max clock speed to 400 MHz

## Memory overclock
`mister_mem_oc.sh` contains a script that will change your DDR3 clock.

Change the `TARGET_KHZ` line in `mister_mem_oc.sh` before copying it over to your SD card with your desired frequency (in KHz).

These must be in increments of `25000`. For example:

`TARGET_KHZ=800000` 800 MHz, same as stock.

`TARGET_KHZ=850000` 850 MHz

`TARGET_KHZ=900000` 900 MHz

`TARGET_KHZ=950000` 950 MHz

`TARGET_KHZ=1000000` 1000 MHz

`TARGET_KHZ=1050000` 1050 MHz

`TARGET_KHZ=1100000` 1100 MHz

## Memory timings
`mister_mem_timings.sh` contains a script that will change your DDR3 timings.

The timings are set to stock by default. Change the timings at the top of the file before copying it over to your SD card with your desired timings.
