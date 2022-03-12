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

if [ ! -f "/media/fat/MiSTer" ]; 
then
	echo "This script must be run"
	echo "on a MiSTer system."
	exit 1
fi

if [ ! -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" ];
then
	echo "This script must be run"
	echo "on a kernel with cpufreq driver."
	exit 1
fi

echo "Warning: Active cooling required!"
echo "Warning: Overclock/underclock at your own risk!"
echo "This script comes with no warranty"
echo "Press UP to proceed, press DOWN to abort"

for (( ; ; )); do
	read -r -s -N 1 -t 1 key
	if [[ "${key}" == "A" ]]; then
		break
	elif [[ "${key}" == "B" ]]; then
		echo "Aborted script"
		exit 1
		break
	fi
done

echo "400000" > "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
echo "Max CPU frequency set to 400 MHz"
