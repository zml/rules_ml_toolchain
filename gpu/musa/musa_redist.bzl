# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

"""Moore Threads MUSA SDK redistributable metadata.

The developer site publishes the version/device/OS matrix, but direct binary
URLs are returned through the site download flow. Keep the public metadata here
and add URL plus sha256 only for artifacts that are explicitly mirrored or
approved for hermetic download.
"""

def _entry(version, driver_versions, devices, oses, resource_id, title, package_format = "", url = "", sha256 = "", strip_prefix = "", root = "."):
    return struct(
        version = version,
        driver_versions = driver_versions,
        devices = devices,
        oses = oses,
        resource_id = resource_id,
        title = title,
        package_format = package_format,
        url = url,
        sha256 = sha256,
        strip_prefix = strip_prefix,
        root = root,
    )

MUSA_REDIST = {
    "musa_sdk_5_1_0_cc3_1_rpm": _entry("5.1.0", ["5.1.0"], ["MTT S5000"], ["Alibaba Cloud Linux", "openEuler", "TencentOS Server", "VesselOS", "Kylin"], "2051969507064418304", "MUSA_SDK_5.1.0.CC3.1.RPM", "rpm"),
    "musa_sdk_5_1_0_cc2_2_rpm": _entry("5.1.0", ["5.1.0"], ["MTT S4000"], ["openEuler"], "2051960972511416320", "MUSA_SDK_5.1.0.CC2.2.RPM", "rpm"),
    "musa_sdk_5_1_0_cc2_2_deb": _entry("5.1.0", ["5.1.0"], ["MTT S4000"], ["Ubuntu"], "2051875072112726016", "MUSA_SDK_5.1.0.CC2.2.DEB", "deb"),
    "musa_sdk_5_1_0_cc3_1_deb": _entry("5.1.0", ["5.1.0"], ["MTT S5000"], ["Ubuntu"], "2051966049083068416", "MUSA_SDK_5.1.0.CC3.1.DEB", "deb"),
    "musa_sdk_4_3_6_cc3_1_deb": _entry("4.3.6", ["3.3.6"], ["MTT S5000"], ["Ubuntu"], "2036089021880471552", "MUSA_SDK_4.3.6.CC3.1.DEB", "deb"),
    "musa_sdk_4_3_5_cc3_1_rpm": _entry("4.3.5", ["3.3.5"], ["MTT S5000"], ["Kylin", "Alibaba Cloud Linux", "openEuler", "TencentOS Server", "VesselOS"], "2033369903637073920", "MUSA_SDK_4.3.5.CC3.1.RPM", "rpm"),
    "musa_sdk_4_3_5_cc3_1_deb": _entry("4.3.5", ["3.3.5"], ["MTT S5000"], ["Ubuntu", "Debian GNU/Linux"], "2033373166688145408", "MUSA_SDK_4.3.5.CC3.1.DEB", "deb"),
    "musa_sdk_4_3_5_cc2_2": _entry("4.3.5", ["3.3.5"], ["MTT S4000"], ["Ubuntu"], "2033372874059943936", "MUSA_SDK_4.3.5.CC2.2"),
    "musa_sdk_4_3_4_cc3_1_rpm": _entry("4.3.4", ["3.3.4"], ["MTT S5000"], ["Kylin", "Alibaba Cloud Linux", "openEuler", "TencentOS Server"], "2011864450558201856", "MUSA_SDK_4.3.4.CC3.1.RPM", "rpm"),
    "musa_sdk_4_3_4_cc3_1_deb": _entry("4.3.4", ["3.3.4"], ["MTT S5000"], ["Ubuntu", "Debian GNU/Linux"], "2011860619380264960", "MUSA_SDK_4.3.4.CC3.1.DEB", "deb"),
    "musa_sdk_4_3_2_cc3_1_rpm": _entry("4.3.2", ["3.3.2"], ["MTT S5000"], ["Alibaba Cloud Linux", "openEuler"], "2011849940669698048", "MUSA_SDK_4.3.2.CC3.1.RPM", "rpm"),
    "musa_sdk_4_3_2_cc3_1_deb": _entry("4.3.2", ["3.3.2"], ["MTT S5000"], ["Debian GNU/Linux", "Ubuntu"], "2011848908048830464", "MUSA_SDK_4.3.2.CC3.1.DEB", "deb"),
    "musa_sdk_4_3_2_cc2_2": _entry("4.3.2", ["3.3.2"], ["MTT S4000"], ["Ubuntu"], "2011842485701185536", "MUSA_SDK_4.3.2.CC2.2"),
    "musa_sdk_4_3_0_cc2_1": _entry("4.3.0", ["3.1.0"], ["MTT S3000", "MTT S80"], ["Ubuntu"], "1976956447782735872", "MUSA_SDK_4.3.0.CC2.1"),
    "musa_sdk_4_3_0_cc2_2": _entry("4.3.0", ["3.1.0"], ["MTT S4000"], ["Ubuntu"], "1977707546873565184", "MUSA_SDK_4.3.0.CC2.2"),
    "musa_sdk_4_2_0_s4000": _entry("4.2.0", ["2.1.0"], ["MTT S4000"], ["Ubuntu"], "1950922897052798976", "MUSA SDK 4.2.0"),
    "musa_sdk_4_2_0_s80_s3000": _entry("4.2.0", ["2.1.0"], ["MTT S80", "MTT S3000"], ["Ubuntu"], "1950933435380011008", "MUSA SDK 4.2.0"),
    "musa_sdk_4_1_0_s4000": _entry("4.1.0", ["3.0.0"], ["MTT S4000"], ["Ubuntu"], "1945420337772630016", "MUSA SDK v4.1.0"),
    "musa_sdk_4_0_1_hygon_kylin": _entry("4.0.1", ["3.0.0"], ["MTT S3000", "MTT X300"], ["Kylin"], "1910241520766816256", "v4.0.1_Hygon_CPU_Kylin"),
    "musa_sdk_4_0_1_intel_ubuntu": _entry("4.0.1", ["3.0.0"], ["MTT S80", "MTT S3000", "MTT X300"], ["Ubuntu"], "1910239937270255616", "v4.0.1_Intel_CPU_Ubuntu"),
    "musa_sdk_4_0_0_s4000": _entry("4.0.0", ["3.0.0"], ["MTT S4000"], ["Ubuntu"], "1916502388441747456", "MUSA SDK v4.0.0"),
    "musa_sdk_rc3_1_1": _entry(
        "rc3.1.1",
        ["2.7.0"],
        ["MTT S80", "MTT S3000", "MTT S4000"],
        ["Ubuntu"],
        "1889995243214999552",
        "MUSA SDK rc3.1.1",
        url = "https://github.com/neudinger/rules-ml-toolchain-redists/releases/download/musa-vrc3.1.1-musa_sdk_rc3_1_1-ubuntu-x86_64/musa-toolkit-rc3.1.1-musa_sdk_rc3_1_1-ubuntu-x86_64.tar.zst",
        sha256 = "4f76277bd7e32614d2beab7e48c2efa57d9b25543c01be313b4ed88beaabe51f",
        strip_prefix = "",
        root = "musa",
    ),
    "musa_sdk_rc3_1_0": _entry("rc3.1.0", ["2.7.0"], ["MTT S3000", "MTT S4000", "MTT S80"], ["Ubuntu"], "1848260740813819904", "MUSA SDK rc3.1.0"),
    "musa_sdk_rc3_0_1": _entry("rc3.0.1", ["2.7.0"], ["MTT S80", "MTT S3000", "MTT S4000"], ["Ubuntu"], "1829751594628026368", "MUSA SDK rc3.0.1"),
    "musa_sdk_rc2_1_0_chunxiao": _entry("rc2.1.0", ["2.7.0"], ["MTT S80", "MTT S3000"], ["Ubuntu"], "1780570644312887296", "rc2.1.0_Intel_CPU_Ubuntu_chunxiao"),
    "musa_sdk_rc2_1_0_quyuan": _entry("rc2.1.0", ["2.7.0"], ["MTT S4000"], ["Ubuntu"], "1780589332604784640", "rc2.1.0_Intel_CPU_Ubuntu_quyuan"),
    "musa_sdk_rc2_0_0": _entry("rc2.0.0", ["2.6.0"], ["MTT S80", "MTT S3000", "MTT S4000"], ["Ubuntu"], "1765383559952076800", "rc2.0.0_Intel_CPU_Ubuntu"),
    "musa_sdk_1_5_2_install_guide": _entry("1.5.2", ["2.5.0"], ["MTT S3000", "MTT S80", "MTT S4000"], ["Ubuntu", "Kylin"], "1761254105197711360", "v1.5.2 Installation guide for MUSA SDK", "doc"),
    "musa_sdk_1_5_2_intel_ubuntu": _entry("1.5.2", ["2.5.0"], ["MTT S3000", "MTT S80", "MTT S4000"], ["Ubuntu"], "1761261667875950592", "v1.5.2_Intel_CPU_Ubuntu"),
    "musa_sdk_1_5_2_hygon_kylin": _entry("1.5.2", ["2.5.0"], ["MTT S3000"], ["Kylin"], "1761263309149048832", "v1.5.2_Hygon_CPU_Kylin_V10"),
    "musa_sdk_1_5_2_kunpeng_kylin": _entry("1.5.2", ["2.5.0"], ["MTT S3000"], ["Kylin"], "1761265004759355392", "v1.5.2_Kunpeng920_Kylin_V10"),
}

def _contains(value, values):
    if not value:
        return True
    value = value.lower()
    return value in [v.lower() for v in values]

def select_musa_redist(version = "", device = "", os_name = "", package = ""):
    """Selects one MUSA redist entry from the public metadata matrix."""
    if package:
        if package not in MUSA_REDIST:
            fail("Unknown MUSA_PACKAGE '{}'. Available packages: {}".format(package, ", ".join(sorted(MUSA_REDIST.keys()))))
        return package, MUSA_REDIST[package]

    matches = []
    for key, entry in MUSA_REDIST.items():
        if version and entry.version.lower() != version.lower():
            continue
        if not _contains(device, entry.devices):
            continue
        if not _contains(os_name, entry.oses):
            continue
        matches.append(key)

    if len(matches) == 1:
        key = matches[0]
        return key, MUSA_REDIST[key]

    if len(matches) == 0:
        fail("No MUSA redist entry matched version='{}', device='{}', os='{}'.".format(version, device, os_name))

    fail("MUSA redist selection is ambiguous for version='{}', device='{}', os='{}'. Matching packages: {}".format(
        version,
        device,
        os_name,
        ", ".join(matches),
    ))
