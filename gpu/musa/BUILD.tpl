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

load("@rules_cc//cc:defs.bzl", "cc_library")

licenses(["restricted"])

package(default_visibility = ["//visibility:private"])

exports_files(
    ["musa_dist"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "all_files",
    srcs = glob(["%{musa_root}/**"], allow_empty = True),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "musa_root",
    srcs = [":all_files"],
    visibility = ["//visibility:public"],
)

filegroup(
    name = "mcc",
    srcs = glob(["%{musa_root}/%{mcc_path}"], allow_empty = True),
    visibility = ["//visibility:public"],
)

filegroup(
    name = "toolchain_data",
    srcs = glob(
        [
            "%{musa_root}/bin/**",
            "%{musa_root}/include/**",
            "%{musa_root}/lib/**",
            "%{musa_root}/lib64/**",
            "%{musa_root}/mtgpu/**",
        ],
        allow_empty = True,
    ),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "musa_headers",
    hdrs = glob(["%{musa_root}/include/**/*.h"], allow_empty = True),
    includes = ["%{musa_root}/include"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "musa_runtime",
    hdrs = glob(["%{musa_root}/include/**/*.h"], allow_empty = True),
    includes = ["%{musa_root}/include"],
    srcs = glob(["%{musa_root}/**/libmusart.so*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

alias(
    name = "musart",
    actual = ":musa_runtime",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "musa_driver",
    srcs = glob(["%{musa_root}/**/libmusa.so*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "mublas",
    hdrs = glob(["%{musa_root}/include/**/*.h"], allow_empty = True),
    includes = ["%{musa_root}/include"],
    srcs = glob(["%{musa_root}/**/libmublas.so*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "mudnn",
    hdrs = glob(["%{musa_root}/include/**/*.h"], allow_empty = True),
    includes = ["%{musa_root}/include"],
    srcs = glob(["%{musa_root}/**/libmudnn.so*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "mccl",
    hdrs = glob(["%{musa_root}/include/**/*.h"], allow_empty = True),
    includes = ["%{musa_root}/include"],
    srcs = glob(["%{musa_root}/**/libmccl.so*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cuda2musa",
    hdrs = glob(["%{musa_root}/include/**/*.h"], allow_empty = True),
    includes = ["%{musa_root}/include"],
    srcs = glob(["%{musa_root}/**/libcuda2musa.so*"], allow_empty = True),
    visibility = ["//visibility:public"],
)

config_setting(
    name = "using_musa",
    define_values = {
        "using_musa": "true",
    },
    visibility = ["//visibility:public"],
)
