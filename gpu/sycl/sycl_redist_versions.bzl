# Copyright 2025 Google LLC
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

REDIST_DICT = {
    "oneapi": {
        "ubuntu_24.10_2026.0": [
            "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/71180075-e4e3-4c6f-bbbb-19017ed0cf7d/intel-oneapi-toolkit-2026.0.0.198_offline.sh",
            "155a52896bd24239ddc733f487eccb2af5cad9957eed1e2bfe60ce1453694e5b",
            "",
            "installer",
        ],
        "ubuntu_24.04_2026.0": [
            "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/71180075-e4e3-4c6f-bbbb-19017ed0cf7d/intel-oneapi-toolkit-2026.0.0.198_offline.sh",
            "155a52896bd24239ddc733f487eccb2af5cad9957eed1e2bfe60ce1453694e5b",
            "",
            "installer",
        ],
        "ubuntu_22.04_2026.0": [
            "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/71180075-e4e3-4c6f-bbbb-19017ed0cf7d/intel-oneapi-toolkit-2026.0.0.198_offline.sh",
            "155a52896bd24239ddc733f487eccb2af5cad9957eed1e2bfe60ce1453694e5b",
            "",
            "installer",
        ],
    },
    "level_zero": {
        "ubuntu_24.10_2026.0": [
            "https://github.com/oneapi-src/level-zero/releases/download/v1.28.6/libze-dev_1.28.6%2Bu24.04_amd64.deb",
            "93034c2a8396ad43a6bafb42469839940cfc9dc1ab64781fca3b62cc31b0df82",
            "",
            "deb",
        ],
        "ubuntu_24.04_2026.0": [
            "https://github.com/oneapi-src/level-zero/releases/download/v1.28.6/libze-dev_1.28.6%2Bu24.04_amd64.deb",
            "93034c2a8396ad43a6bafb42469839940cfc9dc1ab64781fca3b62cc31b0df82",
            "",
            "deb",
        ],
        "ubuntu_22.04_2026.0": [
            "https://github.com/oneapi-src/level-zero/releases/download/v1.28.6/libze-dev_1.28.6%2Bu22.04_amd64.deb",
            "97a7be5583ccda04aeb059b826b13a70be177a4e285be3862f63dd8673427dd4",
            "",
            "deb",
        ],
    },
    "zero_loader": {
        "ubuntu_24.10_2026.0": [
            "https://github.com/oneapi-src/level-zero/releases/download/v1.28.6/libze1_1.28.6%2Bu24.04_amd64.deb",
            "8af9dc06d9684a20a3f43754fe109968fba2ba085cfa572a4cc6ef0272f9bcd1",
            "",
            "deb",
        ],
        "ubuntu_24.04_2026.0": [
            "https://github.com/oneapi-src/level-zero/releases/download/v1.28.6/libze1_1.28.6%2Bu24.04_amd64.deb",
            "8af9dc06d9684a20a3f43754fe109968fba2ba085cfa572a4cc6ef0272f9bcd1",
            "",
            "deb",
        ],
        "ubuntu_22.04_2026.0": [
            "https://github.com/oneapi-src/level-zero/releases/download/v1.28.6/libze1_1.28.6%2Bu22.04_amd64.deb",
            "52c5fd2b37a749770bbb4939fbb3cb5a855018a55171b9c8806c838fe5e67cc2",
            "",
            "deb",
        ],
    },
}

BUILD_TEMPLATES = {
    "oneapi": {
        "repo_name": "oneapi",
        "version_to_template": {
            "ubuntu_24.10_2026.0": "//gpu/sycl:oneapi.BUILD",
            "ubuntu_24.04_2026.0": "//gpu/sycl:oneapi.BUILD",
            "ubuntu_22.04_2026.0": "//gpu/sycl:oneapi.BUILD",
        },
    },
    "level_zero": {
        "repo_name": "level_zero",
        "version_to_template": {
            "ubuntu_24.10_2026.0": "//gpu/sycl:level_zero.BUILD",
            "ubuntu_24.04_2026.0": "//gpu/sycl:level_zero.BUILD",
            "ubuntu_22.04_2026.0": "//gpu/sycl:level_zero.BUILD",
        },
    },
    "zero_loader": {
        "repo_name": "zero_loader",
        "version_to_template": {
            "ubuntu_24.10_2026.0": "//gpu/sycl:zero_loader.BUILD",
            "ubuntu_24.04_2026.0": "//gpu/sycl:zero_loader.BUILD",
            "ubuntu_22.04_2026.0": "//gpu/sycl:zero_loader.BUILD",
        },
    },
}
