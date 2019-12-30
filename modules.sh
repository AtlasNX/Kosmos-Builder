#!/bin/bash
#
# Kosmos
# Copyright (C) 2019 Nichole Mattera
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

# Downloads the latest Atmosphere release and extracts it.
# Params:
#   - Directory to extract to
#   - GitHub Login
# Returns:
#   The version number.
download_atmosphere () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "Atmosphere-NX" "Atmosphere" "1")

    asset=$(./common.sh find_asset "${latest_release}" "atmosphere*" "*.zip")
    file=$(./common.sh download_file "${asset}")

    unzip -qq "${file}" -d "${1}"
    rm -f "${1}/switch/reboot_to_payload.nro"
    rm -f "${1}/atmosphere/reboot_payload.bin"
    rm -f "${file}"

    asset=$(./common.sh find_asset "${latest_release}" "fusee*" "*.bin")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/bootloader/payloads"
    mv ${file} "${1}/bootloader/payloads/fusee-primary.bin"
    cp "./Modules/atmosphere/system_settings.ini" "${1}/atmosphere/config/system_settings.ini"

    echo $(./common.sh get_version_number "${latest_release}")
}

# Downloads the latest Hekate release and extracts it.
# Params:
#   - Directory to extract to
#   - The Kosmos version number
#   - GitHub Login
# Returns:
#   The version number.
download_hekate () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${3}" "CTCaer" "hekate" "1")

    asset=$(./common.sh find_asset "${latest_release}" "hekate*" "*.zip")
    file=$(./common.sh download_file "${asset}")

    unzip -qq "${file}" -d "${1}"
    rm -f "${file}"

    payload=$(./common.sh glob "${1}/hekate*.bin")
    cp "${payload}" "${1}/bootloader/update.bin"
    mkdir -p "${1}/atmosphere"
    cp "${payload}" "${1}/atmosphere/reboot_payload.bin"

    cp "./Modules/hekate/bootlogo.bmp" "${1}/bootloader/bootlogo.bmp"
    
    sed "s/KOSMOS_VERSION/${2}/g" "./Modules/hekate/hekate_ipl.ini" >> "${1}/bootloader/hekate_ipl.ini"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_appstore () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "vgmoose" "hb-appstore" "1")

    asset=$(./common.sh find_asset "${latest_release}" "*.nro")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/switch/appstore"
    mv ${file} "${1}/switch/appstore/appstore.nro"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_edizon () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "WerWolv" "EdiZon" "0")

    asset=$(./common.sh find_asset "${latest_release}" "*.zip")
    if [ ! -z "${asset}" ]
    then
        file=$(./common.sh download_file "${asset}")

        unzip -qq "${file}" -d "${1}"
        rm -f "${file}"
    else
        asset=$(./common.sh find_asset "${latest_release}" "*.nro")
        file=$(./common.sh download_file "${asset}")

        mkdir -p "${1}/switch/EdiZon"
        mv "${file}" "${1}/switch/EdiZon/EdiZon.nro"
    fi

    echo $(./common.sh get_version_number "${latest_release}")
}

download_emuiibo () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "XorTroll" "emuiibo" "1")

    asset=$(./common.sh find_asset "${latest_release}" "emuiibo*" "*.zip")
    file=$(./common.sh download_file "${asset}")

    unzip -qq "${file}" -d "${1}"
    rm -f "${1}/contents/0100000000000352/flags/boot2.flag"
    rm -f "${file}"
    mkdir -p "${1}/atmosphere/contents"
    mv "${1}/contents/0100000000000352" "${1}/atmosphere/contents/"
    rm -rf "${1}/contents"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_goldleaf () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "XorTroll" "Goldleaf" "1")

    asset=$(./common.sh find_asset "${latest_release}" "*.nro")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/switch/Goldleaf"
    mv ${file} "${1}/switch/Goldleaf/Goldleaf.nro"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_kosmos_toolbox () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "AtlasNX" "Kosmos-Toolbox" "1")

    asset=$(./common.sh find_asset "${latest_release}" "*.nro")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/switch/KosmosToolbox"
    mv "${file}" "${1}/switch/KosmosToolbox/KosmosToolbox.nro"
    cp "./Modules/kosmos-toolbox/config.json" "${1}/switch/KosmosToolbox/config.json"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_kosmos_updater () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${3}" "AtlasNX" "Kosmos-Updater" "0")

    asset=$(./common.sh find_asset "${latest_release}" "*.nro")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/switch/KosmosUpdater"
    mv ${file} "${1}/switch/KosmosUpdater/KosmosUpdater.nro"
    sed "s/KOSMOS_VERSION/${2}/g" "./Modules/kosmos-updater/internal.db" >> "${1}/switch/KosmosUpdater/internal.db"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_ldn_mitm () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "spacemeowx2" "ldn_mitm" "1")

    asset=$(./common.sh find_asset "${latest_release}" "ldn_mitm*" "*.zip")
    file=$(./common.sh download_file "${asset}")

    unzip -qq "${file}" -d "${1}"
    rm -f "${1}/atmosphere/contents/4200000000000010/flags/boot2.flag"
    rm -f "${file}"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_lockpick () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "shchmue" "Lockpick" "1")

    asset=$(./common.sh find_asset "${latest_release}" "*.nro")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/switch/Lockpick"
    mv ${file} "${1}/switch/Lockpick/Lockpick.nro"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_lockpick_rcm () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "shchmue" "Lockpick_RCM" "1")

    asset=$(./common.sh find_asset "${latest_release}" "*.bin")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/bootloader/payloads"
    mv ${file} "${1}/bootloader/payloads/Lockpick_RCM.bin"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_sys_clk () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "retronx-team" "sys-clk" "1")

    asset=$(./common.sh find_asset "${latest_release}" "sys-clk*" "*.zip")
    file=$(./common.sh download_file "${asset}")

    unzip -qq "${file}" -d "${1}"
    mv "${1}/atmosphere/titles/00FF0000636C6BFF" "${1}/atmosphere/contents/00FF0000636C6BFF"
    rm -rf "${1}/atmosphere/titles"
    rm -f "${1}/atmosphere/contents/00FF0000636C6BFF/flags/boot2.flag"
    rm -f "${1}/README.html"
    rm -f "${1}/README.md"
    rm -f "${file}"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_sys_ftpd_light () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "cathery" "sys-ftpd-light" "1")

    asset=$(./common.sh find_asset "${latest_release}" "sys-ftpd-light*" "*.zip")
    file=$(./common.sh download_file "${asset}")

    unzip -qq "${file}" -d "${1}"
    rm -f "${1}/atmosphere/contents/420000000000000E/flags/boot2.flag"
    rm -f "${file}"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_nxdumptool () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "DarkMatterCore" "nxdumptool" "1")

    asset=$(./common.sh find_asset "${latest_release}" "nxdumptool*" "*.nro")
    file=$(./common.sh download_file "${asset}")

    mkdir -p "${1}/switch/NXDumpTool"
    mv ${file} "${1}/switch/NXDumpTool/NXDumpTool.nro"

    echo $(./common.sh get_version_number "${latest_release}")
}

download_sys_con () {
    mkdir -p ${1}
    latest_release=$(./common.sh get_latest_release "${2}" "cathery" "sys-con" "1")

    asset=$(./common.sh find_asset "${latest_release}" "sys-con-*" "*.zip")
    file=$(./common.sh download_file "${asset}")

    unzip -qq "${file}" -d "${1}"
    rm -f "${file}"
    rm -f "${1}/atmosphere/contents/690000000000000D/flags/boot2.flag"

    echo $(./common.sh get_version_number "${latest_release}")
}

remove_configs () {
    # Atmosphere
    rm -f "${1}/atmosphere/config/BCT.ini"
    rm -f "${1}/atmosphere/config/system_settings.ini"

    # System Modules
    rm -f "${1}/config/hid_mitm/config.ini"
    rm -f "${1}/config/sys-clk/config.ini"
    rm -f "${1}/config/sys-ftpd/config.ini"

    # Apps
    rm -f "${1}/switch/KosmosToolbox/config.json"
    rm -f "${1}/switch/KosmosUpdater/settings.cfg"
}

# =============================================================================
# Main Script
# =============================================================================

if [ $# -le 1 ]
then
    echo "This is not meant to be called by end users and is used by the kosmos.sh and sdsetup.sh scripts."
    exit 1
fi

# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi
