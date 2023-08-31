#!/bin/bash

# User constants
TARGET_KHZ=900000        # Desired frequency to overclock to
MIN_FREQ_KHZ=800000      # Minimum frequency in KHz
MAX_FREQ_KHZ=1200000     # Maximum frequency in KHz
INCREMENT_KHZ=25000      # Frequency increment in KHz

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
