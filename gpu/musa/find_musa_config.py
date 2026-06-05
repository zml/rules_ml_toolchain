#!/usr/bin/env python3
#
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

"""Finds and validates a Moore Threads MUSA toolkit installation."""

import os
import re
import subprocess
import sys


CORE_REQUIRED_LIBS = {
    "musart": "libmusart.so",
    "mublas": "libmublas.so",
}

OPTIONAL_LIBS = {
    "musa_driver": "libmusa.so",
    "mccl": "libmccl.so",
    "cuda2musa": "libcuda2musa.so",
}

MUDNN_LIB = {
    "mudnn": "libmudnn.so",
}


def _as_version_number(version):
    if not version:
        return "0"
    numbers = re.findall(r"\d+", version)
    if not numbers:
        return "0"
    parts = [int(p) for p in numbers[:3]]
    while len(parts) < 3:
        parts.append(0)
    return str(parts[0] * 10000 + parts[1] * 100 + parts[2])


def _run_version(mcc):
    try:
        out = subprocess.check_output([mcc, "--version"], stderr=subprocess.STDOUT, text=True)
    except Exception:
        return ""
    match = re.search(r"(\d+(?:\.\d+){1,3}|rc\d+(?:\.\d+){1,3})", out)
    return match.group(1) if match else ""


def _find_library(root, soname):
    for dirpath, _, filenames in os.walk(root):
        for filename in filenames:
            if filename == soname or filename.startswith(soname + "."):
                return os.path.join(dirpath, filename)
    return ""


def _rel(path, root):
    return os.path.relpath(path, root).replace(os.sep, "/")


def _normalize_device(device):
    return device.removeprefix("MTT ").upper()


def _mudnn_is_optional(version, device):
    device = _normalize_device(device)
    return device in {"S80", "S3000"} or version.startswith("rc3.")


def main():
    musa_path = os.environ.get("MUSA_PATH", "")
    if len(sys.argv) > 1:
        musa_path = sys.argv[1]
    musa_path = os.path.realpath(musa_path)

    mcc_path = os.path.join(musa_path, "bin", "mcc")
    include_dir = os.path.join(musa_path, "include")
    version = os.environ.get("MUSA_VERSION", "") or _run_version(mcc_path)
    device = os.environ.get("MUSA_DEVICE", "")
    required_libs = dict(CORE_REQUIRED_LIBS)
    optional_libs = dict(OPTIONAL_LIBS)
    if _mudnn_is_optional(version, device):
        optional_libs.update(MUDNN_LIB)
    else:
        required_libs.update(MUDNN_LIB)

    missing = []
    if not os.path.exists(mcc_path):
        missing.append("bin/mcc")
    if not os.path.isdir(include_dir):
        missing.append("include")

    found_required = {}
    for name, soname in required_libs.items():
        lib = _find_library(musa_path, soname)
        if lib:
            found_required[name] = _rel(lib, musa_path)
        else:
            missing.append(soname)

    if missing:
        sys.stderr.write(
            "Invalid MUSA toolkit at '{}'. Missing required components: {}\n".format(
                musa_path,
                ", ".join(missing),
            )
        )
        return 1

    found_optional = {}
    for name, soname in optional_libs.items():
        lib = _find_library(musa_path, soname)
        found_optional[name] = _rel(lib, musa_path) if lib else ""

    library_paths = sorted(
        {
            os.path.dirname(path)
            for path in list(found_required.values()) + list(found_optional.values())
            if path
        }
    )

    print("musa_toolkit_path: {}".format(musa_path))
    print("musa_version_number: {}".format(_as_version_number(version)))
    print("musa_version: {}".format(version))
    print("mcc_path: {}".format(_rel(mcc_path, musa_path)))
    print("library_paths: {}".format(repr(library_paths)))
    for name in sorted(found_required):
        print("{}_path: {}".format(name, found_required[name]))
    for name in sorted(found_optional):
        print("{}_path: {}".format(name, found_optional[name]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
