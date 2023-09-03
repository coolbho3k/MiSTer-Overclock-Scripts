#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Primary timings
readonly tCL=7   # Default 7
readonly tRP=6   # Default 6
readonly tRCD=6  # Default 6
readonly tRAS=14 # Default 14

# Secondary timings
readonly tRFC=120 # Default 120
readonly tFAW=15  # Default 15
readonly tRRD=3   # Default 3
readonly tAL=0    # Default 0
readonly tCW=7    # Default 7

readonly tWTR=4     # Default 4
readonly tWR=6      # Default 6
readonly tREFI=3120 # Default 3120

readonly tCCD=4 # Default 4
readonly tMRD=4 # Default 4
readonly tRC=20 # Default 20
readonly tRTP=3 # Default 3

readonly minpwrsavecycles=0 # Default 0
readonly tXPDLL=3           # Default 3
readonly tXS=512            # Default 512

if [ ! -f "/media/fat/MiSTer" ]; 
then
  echo "This script must be run"
  echo "on a MiSTer system."
  exit 1
fi

insert_bits() {
    local value=$1
    local start=$2
    local end=$3
    local insert_value=$4
    local mask=$(( ((1 << (end - start + 1)) - 1) << start ))
    echo $(( (value & ~mask) | (insert_value << start) ))
}

print_timings() {
    local current_tCL current_tRP current_tRCD current_tRAS
    local current_tRFC current_tFAW current_tRRD current_tAL current_tCW
    local current_tWTR current_tWR current_tREFI
    local current_tCCD current_tMRD current_tRC current_tRTP
    local current_minpwrsavecycles current_tXPDLL current_tXS

    for reg_addr in 0xFFC25004 0xFFC25008 0xFFC2500C 0xFFC25010; do
        orig_value=$(devmem $reg_addr)

        case $reg_addr in
        0xFFC25004)
            current_tRFC=$(( (orig_value >> 24) & 0xFF ))
            current_tFAW=$(( (orig_value >> 18) & 0x3F ))
            current_tRRD=$(( (orig_value >> 14) & 0xF ))
            current_tCL=$(( (orig_value >> 9) & 0x1F ))
            current_tAL=$(( (orig_value >> 4) & 0x1F ))
            current_tCW=$(( orig_value & 0xF ))
            ;;
        0xFFC25008)
            current_tWTR=$(( (orig_value >> 25) & 0xF ))
            current_tWR=$(( (orig_value >> 21) & 0xF ))
            current_tRP=$(( (orig_value >> 17) & 0xF ))
            current_tRCD=$(( (orig_value >> 13) & 0xF ))
            current_tREFI=$(( orig_value & 0x1FFF ))
            ;;
        0xFFC2500C)
            current_tCCD=$(( (orig_value >> 19) & 0xF ))
            current_tMRD=$(( (orig_value >> 15) & 0xF ))
            current_tRC=$(( (orig_value >> 9) & 0x3F ))
            current_tRAS=$(( (orig_value >> 4) & 0x1F ))
            current_tRTP=$(( orig_value & 0xF ))
            ;;
        0xFFC25010)
            current_minpwrsavecycles=$(( (orig_value >> 20) & 0xF ))
            current_tXPDLL=$(( (orig_value >> 10) & 0x3FF ))
            current_tXS=$(( orig_value & 0x3FF ))
            ;;
        esac
    done
    echo -e "  \033[1mtCL=$current_tCL, tRP=$current_tRP, tRCD=$current_tRCD, tRAS=$current_tRAS\033[0m"
    echo "  tRFC=$current_tRFC, tFAW=$current_tFAW, tRRD=$current_tRRD, tAL=$current_tAL, tCW=$current_tCW"
    echo "  tWTR=$current_tWTR, tWR=$current_tWR, tREFI=$current_tREFI"
    echo "  tCCD=$current_tCCD, tMRD=$current_tMRD, tRC=$current_tRC, tRTP=$current_tRTP"
    echo "  Min Power Save Cycles=$current_minpwrsavecycles, tXPDLL=$current_tXPDLL, tXS=$current_tXS"
}

echo -e "\033[1;32m***** BEFORE *****\033[0m"
print_timings

# Modify and write to registers if needed
for reg_addr in 0xFFC25004 0xFFC25008 0xFFC2500C 0xFFC25010; do
    orig_value=$(devmem $reg_addr)
    new_value=$orig_value

    case $reg_addr in
    0xFFC25004)
        new_value=$(insert_bits $new_value 24 31 $tRFC)
        new_value=$(insert_bits $new_value 18 23 $tFAW)
        new_value=$(insert_bits $new_value 14 17 $tRRD)
        new_value=$(insert_bits $new_value 9 13 $tCL)
        new_value=$(insert_bits $new_value 4 8 $tAL)
        new_value=$(insert_bits $new_value 0 3 $tCW)
        ;;
    0xFFC25008)
        new_value=$(insert_bits $new_value 25 28 $tWTR)
        new_value=$(insert_bits $new_value 21 24 $tWR)
        new_value=$(insert_bits $new_value 17 20 $tRP)
        new_value=$(insert_bits $new_value 13 16 $tRCD)
        new_value=$(insert_bits $new_value 0 12 $tREFI)
        ;;
    0xFFC2500C)
        new_value=$(insert_bits $new_value 19 22 $tCCD)
        new_value=$(insert_bits $new_value 15 18 $tMRD)
        new_value=$(insert_bits $new_value 9 14 $tRC)
        new_value=$(insert_bits $new_value 4 8 $tRAS)
        new_value=$(insert_bits $new_value 0 3 $tRTP)
        ;;
    0xFFC25010)
        new_value=$(insert_bits $new_value 20 23 $minpwrsavecycles)
        new_value=$(insert_bits $new_value 10 19 $tXPDLL)
        new_value=$(insert_bits $new_value 0 9 $tXS)
        ;;
    esac

    devmem $reg_addr 32 $new_value
done

echo
echo -e "\033[1;32m***** AFTER *****\033[0m"
print_timings
