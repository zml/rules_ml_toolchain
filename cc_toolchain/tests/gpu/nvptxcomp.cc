#include <nvPTXCompiler.h>
#include <iostream>
#include <vector>
#include <cstring>

const char* ptx_code = R"(
.version 6.0
.target sm_30
.address_size 64

.visible .entry add_kernel(
    .param .u64 a,
    .param .u64 b,
    .param .u64 c
)
{
    .reg .u64 t1, t2, t3;
    ld.param.u64  t1, [a];
    ld.param.u64  t2, [b];
    add.u64       t3, t1, t2;
    st.param.u64  [c], t3;
    ret;
}
)";

int main() {
    nvPTXCompilerHandle compiler = nullptr;
    nvPTXCompileResult result = nvPTXCompilerCreate(&compiler, strlen(ptx_code), ptx_code);
    if (result != NVPTXCOMPILE_SUCCESS) {
        std::cerr << "Failed to create PTX compiler: " << result << std::endl;
        return 1;
    }

    // Compile PTX
    result = nvPTXCompilerCompile(compiler, 0, nullptr);
    if (result != NVPTXCOMPILE_SUCCESS) {
        size_t logSize;
        nvPTXCompilerGetErrorLogSize(compiler, &logSize);
        std::vector<char> log(logSize + 1, 0); // null-terminate
        nvPTXCompilerGetErrorLog(compiler, log.data());
        std::cerr << "PTX compilation failed:\n" << log.data() << std::endl;
        nvPTXCompilerDestroy(&compiler);
        return 2;
    }

    size_t outputSize;
    nvPTXCompilerGetCompiledProgramSize(compiler, &outputSize);
    std::vector<char> cubin(outputSize);
    nvPTXCompilerGetCompiledProgram(compiler, cubin.data());

    std::cout << "PTX compiled to CUBIN (size " << outputSize << " bytes)" << std::endl;

    nvPTXCompilerDestroy(&compiler);
    return 0;
}