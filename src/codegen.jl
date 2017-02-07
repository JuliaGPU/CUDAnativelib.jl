module Codegen
using Reexport
@reexport using Cxx

import CUDAnativelib.Version: __sm__, __triple__, CUDA_VERSION, LLVM_VERSION, CUDA_HOME

const __current_compiler__ = Cxx.new_clang_instance(false, false, target = __triple__, CPU = __sm__)
addHeaderDir(__current_compiler__, joinpath(CUDA_HOME, "include"), kind = C_System)

if CUDA_VERSION >= 8000 && LLVM_VERSION < v"4.0.0"
  error("For CUDA 8.0+ we require at least LLVM 4.0")
elseif LLVM_VERSION < v"3.8.1"
  error("LLVM is to old. At least version 3.8.1 is required.")
end

cxxinclude(__current_compiler__, "__clang_cuda_runtime_wrapper.h")

# Cxx.jl needs to have this function defined and this is fine as long as we don't call it.
cxx"""
extern "C" {
extern int __cxxjl_personality_v0();
}
"""
end # module
