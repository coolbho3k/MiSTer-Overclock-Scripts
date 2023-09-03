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

# User constants
TARGET_KHZ=900000        # Desired frequency to overclock to
MIN_FREQ_KHZ=800000      # Minimum frequency in KHz
MAX_FREQ_KHZ=1200000     # Maximum frequency in KHz
INCREMENT_KHZ=25000      # Frequency increment in KHz

if [ ! -f "/media/fat/MiSTer" ]; 
then
  echo "This script must be run"
  echo "on a MiSTer system."
  exit 1
fi

current_reg_value=$(devmem 0xFFD040C0)
current_numer=$(( (current_reg_value >> 3) & 0x1FFF ))
current_freq_khz=$(( (current_numer + 1) * 25000 ))

echo "Current frequency is $((current_freq_khz)) KHz"

target_freq_khz=$((TARGET_KHZ))

if (( target_freq_khz % 25000 != 0 )); then
  echo "Invalid frequency. Must be divisible by 25 MHz."
  exit 1
fi

if (( target_freq_khz < MIN_FREQ_KHZ || target_freq_khz > MAX_FREQ_KHZ )); then
  echo "Invalid frequency $((TARGET_KHZ)). Allowed range is $((MIN_FREQ_KHZ)) KHz to $((MAX_FREQ_KHZ)) KHz."
  exit 1
fi

target_numer=$(( (target_freq_khz / 25000) - 1 ))

while [ $current_freq_khz -ne $target_freq_khz ]; do
  if [ $current_freq_khz -lt $target_freq_khz ]; then
    current_freq_khz=$(( current_freq_khz + INCREMENT_KHZ ))
    if [ $current_freq_khz -gt $target_freq_khz ]; then
      current_freq_khz=$target_freq_khz
    fi
  else
    current_freq_khz=$(( current_freq_khz - INCREMENT_KHZ ))
    if [ $current_freq_khz -lt $target_freq_khz ]; then
      current_freq_khz=$target_freq_khz
    fi
  fi

  current_numer=$(( (current_freq_khz / 25000) - 1 ))

  new_reg_value=$(( (current_numer << 3) | 0x2 ))

  new_reg_value_hex=$(printf '0x%08X' $new_reg_value)

  devmem 0xFFD040C0 w $new_reg_value_hex  
done

echo "Frequency successfully set to $((current_freq_khz)) KHz."
