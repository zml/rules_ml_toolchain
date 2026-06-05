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

"""Repository rule for Moore Threads MUSA toolkit autoconfiguration."""

load("@bazel_skylib//lib:paths.bzl", "paths")
load(
    "//common:common.bzl",
    "err_out",
    "execute",
    "files_exist",
    "get_bash_bin",
    "get_python_bin",
)
load("//gpu/musa:musa_redist.bzl", "select_musa_redist")

_DISTRIBUTION_PATH = "musa/musa_dist"
_DEFAULT_MUSA_PATH = "/usr/local/musa"
_TF_NEED_MUSA = "TF_NEED_MUSA"
_MUSA_PATH = "MUSA_PATH"
_MUSA_HOME = "MUSA_HOME"
_MUSA_VERSION = "MUSA_VERSION"
_MUSA_DEVICE = "MUSA_DEVICE"
_MUSA_OS = "MUSA_OS"
_MUSA_PACKAGE = "MUSA_PACKAGE"
_MUSA_DISTRO_URL = "MUSA_DISTRO_URL"
_MUSA_DISTRO_HASH = "MUSA_DISTRO_HASH"
_MUSA_DISTRO_STRIP_PREFIX = "MUSA_DISTRO_STRIP_PREFIX"
_MUSA_DISTRO_ROOT = "MUSA_DISTRO_ROOT"
_MUSA_GPU_ARCHS = "MUSA_GPU_ARCHS"

def auto_configure_fail(msg):
    red = "\033[0;31m"
    no_color = "\033[0m"
    fail("\n%sMUSA Configuration Error:%s %s\n" % (red, no_color, msg))

def auto_configure_warning(msg):
    yellow = "\033[1;33m"
    no_color = "\033[0m"
    print("\n%sAuto-Configuration Warning:%s %s\n" % (yellow, no_color, msg))

def _enable_musa(repository_ctx):
    if repository_ctx.os.environ.get(_TF_NEED_MUSA) == "1":
        return True
    for name in [_MUSA_PATH, _MUSA_HOME, _MUSA_VERSION, _MUSA_PACKAGE, _MUSA_DISTRO_URL]:
        value = repository_ctx.os.environ.get(name, "")
        if value and value.strip():
            return True
    return False

def _tpl_path(repository_ctx, labelname):
    if labelname.startswith("musa:"):
        return repository_ctx.path(Label("//gpu/musa:%s.tpl" % labelname[5:]))
    return repository_ctx.path(Label("//gpu/musa:%s.tpl" % labelname))

def _tpl(repository_ctx, tpl, substitutions = {}, out = None):
    if not out:
        out = tpl.replace(":", "/")
    repository_ctx.template(
        out,
        _tpl_path(repository_ctx, tpl),
        substitutions,
    )

def _canonical_path(p):
    parts = [x for x in p.split("/") if x != ""]
    return paths.join(*parts)

def _remove_root_dir(path, root_dir):
    if path.startswith(root_dir + "/"):
        return path[len(root_dir) + 1:]
    return path

def _split_archs(repository_ctx):
    archs = repository_ctx.os.environ.get(_MUSA_GPU_ARCHS, "")
    return [a.strip() for a in archs.split(",") if a.strip()]

def _find_musa_config(repository_ctx, musa_path):
    python_bin = get_python_bin(repository_ctx)
    result = execute(
        repository_ctx,
        [python_bin, repository_ctx.attr._find_musa_config, musa_path],
        allow_failure = True,
        env_vars = {
            _MUSA_PATH: musa_path,
            _MUSA_DEVICE: repository_ctx.os.environ.get(_MUSA_DEVICE, ""),
            _MUSA_VERSION: repository_ctx.os.environ.get(_MUSA_VERSION, ""),
        },
    )
    if result.return_code:
        auto_configure_fail("Failed to inspect MUSA toolkit: %s" % err_out(result))
    return dict([tuple(x.split(": ", 1)) for x in result.stdout.splitlines()])

def _download_musa_archive(repository_ctx, url, sha256, strip_prefix = ""):
    if not sha256:
        auto_configure_fail("{} is required when {} is set".format(_MUSA_DISTRO_HASH, _MUSA_DISTRO_URL))
    repository_ctx.report_progress("Downloading and extracting MUSA toolkit from {}".format(url))
    kwargs = {
        "url": url,
        "output": _DISTRIBUTION_PATH,
        "sha256": sha256,
    }
    if strip_prefix:
        kwargs["stripPrefix"] = strip_prefix
    repository_ctx.download_and_extract(**kwargs)

def _setup_musa_distro(repository_ctx):
    distro_url = repository_ctx.os.environ.get(_MUSA_DISTRO_URL, "")
    distro_hash = repository_ctx.os.environ.get(_MUSA_DISTRO_HASH, "")
    strip_prefix = repository_ctx.os.environ.get(_MUSA_DISTRO_STRIP_PREFIX, "")

    if distro_url:
        _download_musa_archive(repository_ctx, distro_url, distro_hash, strip_prefix)
        root = repository_ctx.os.environ.get(_MUSA_DISTRO_ROOT, ".")
        return _DISTRIBUTION_PATH if root in ["", "."] else _canonical_path("{}/{}".format(_DISTRIBUTION_PATH, root))

    version = repository_ctx.os.environ.get(_MUSA_VERSION, "")
    package = repository_ctx.os.environ.get(_MUSA_PACKAGE, "")
    if version or package:
        key, entry = select_musa_redist(
            version = version,
            device = repository_ctx.os.environ.get(_MUSA_DEVICE, ""),
            os_name = repository_ctx.os.environ.get(_MUSA_OS, ""),
            package = package,
        )
        if not entry.url or not entry.sha256:
            auto_configure_fail(
                (
                    "MUSA package '{}' ({}, resource_id={}) is in the public metadata matrix but has no direct URL/sha256. " +
                    "Set {} and {}, or add an approved URL and sha256 to gpu/musa/musa_redist.bzl."
                ).format(
                    key,
                    entry.title,
                    entry.resource_id,
                    _MUSA_DISTRO_URL,
                    _MUSA_DISTRO_HASH,
                )
            )
        _download_musa_archive(repository_ctx, entry.url, entry.sha256, entry.strip_prefix)
        return _DISTRIBUTION_PATH if entry.root in ["", "."] else _canonical_path("{}/{}".format(_DISTRIBUTION_PATH, entry.root))

    bash_bin = get_bash_bin(repository_ctx)
    local_path = repository_ctx.os.environ.get(_MUSA_PATH, "") or repository_ctx.os.environ.get(_MUSA_HOME, "") or _DEFAULT_MUSA_PATH
    if not files_exist(repository_ctx, [local_path], bash_bin)[0]:
        auto_configure_fail(
            (
                "MUSA toolkit was requested but '{}' does not exist. Set MUSA_PATH or MUSA_HOME, " +
                "or provide MUSA_DISTRO_URL and MUSA_DISTRO_HASH."
            ).format(local_path)
        )
    auto_configure_warning("Using non-hermetic MUSA from {}".format(local_path))
    repository_ctx.symlink(local_path, _DISTRIBUTION_PATH)
    return _DISTRIBUTION_PATH

def _create_dummy_repository(repository_ctx):
    repository_ctx.file("musa/empty/.keep", "")
    stub = {
        "%{musa_root}": "empty",
        "%{musa_gpu_architectures}": "[]",
        "%{musa_version}": "0",
        "%{musa_version_number}": "0",
        "%{mcc_path}": "__missing_mcc__",
        "%{musa_path}": "empty",
        "%{musa_library_paths}": "[]",
        "%{musart_path}": "",
        "%{mublas_path}": "",
        "%{mudnn_path}": "",
        "%{musa_driver_path}": "",
        "%{mccl_path}": "",
        "%{cuda2musa_path}": "",
    }
    _tpl(repository_ctx, "musa:BUILD", stub)
    _tpl(repository_ctx, "musa:build_defs.bzl", stub)

def _setup_musa_repository(repository_ctx):
    musa_toolkit_path = _setup_musa_distro(repository_ctx)
    config = _find_musa_config(repository_ctx, musa_toolkit_path)

    if musa_toolkit_path == _DISTRIBUTION_PATH:
        musa_root = "musa_dist"
    else:
        musa_root = _remove_root_dir(musa_toolkit_path, "musa")

    repository_dict = {
        "%{musa_root}": musa_root,
        "%{musa_gpu_architectures}": str(_split_archs(repository_ctx)),
        "%{musa_version}": config.get("musa_version", ""),
        "%{musa_version_number}": config.get("musa_version_number", "0"),
        "%{mcc_path}": config.get("mcc_path", "bin/mcc"),
        "%{musa_path}": "musa_dist" if musa_root == "musa_dist" else musa_root,
        "%{musa_library_paths}": config.get("library_paths", "[]"),
        "%{musart_path}": config.get("musart_path", ""),
        "%{mublas_path}": config.get("mublas_path", ""),
        "%{mudnn_path}": config.get("mudnn_path", ""),
        "%{musa_driver_path}": config.get("musa_driver_path", ""),
        "%{mccl_path}": config.get("mccl_path", ""),
        "%{cuda2musa_path}": config.get("cuda2musa_path", ""),
    }
    _tpl(repository_ctx, "musa:BUILD", repository_dict)
    _tpl(repository_ctx, "musa:build_defs.bzl", repository_dict)

def _musa_autoconf_impl(repository_ctx):
    if not _enable_musa(repository_ctx):
        _create_dummy_repository(repository_ctx)
    else:
        _setup_musa_repository(repository_ctx)

musa_configure = repository_rule(
    implementation = _musa_autoconf_impl,
    environ = [
        _TF_NEED_MUSA,
        _MUSA_PATH,
        _MUSA_HOME,
        _MUSA_VERSION,
        _MUSA_DEVICE,
        _MUSA_OS,
        _MUSA_PACKAGE,
        _MUSA_DISTRO_URL,
        _MUSA_DISTRO_HASH,
        _MUSA_DISTRO_STRIP_PREFIX,
        _MUSA_DISTRO_ROOT,
        _MUSA_GPU_ARCHS,
    ],
    attrs = {
        "_find_musa_config": attr.label(
            default = Label("//gpu/musa:find_musa_config.py"),
        ),
    },
)
