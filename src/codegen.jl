module Codegen
using Reexport
@reexport using Cxx

import CUDAnativelib.Version: __sm__, __triple__, CUDA_VERSION, LLVM_VERSION, CUDA_HOME

function new_cuda_compiler(;target = __triple__, sm = __sm__)
  C = Cxx.setup_instance(makeCCompiler = false, target = target, CPU = sm)

  if CUDA_VERSION >= 8000 && LLVM_VERSION < v"4.0.0"
    warn("CUDA 8.0+ requires at least LLVM 4.0. Using the compatibility headers from 4.0")
    warn("Forefully disabling intrinsics from SM_60")
    addHeaderDir(C,
                 joinpath(@__DIR__, "..", "deps", "include", "clang40"),
                 kind = C_ExternCSystem)
  elseif LLVM_VERSION < v"3.8.1"
    error("LLVM is to old. At least version 3.8.1 is required.")
  end

  Cxx.initialize_instance!(C; register_boot=false)
  push!(Cxx.active_instances, C)
  return Cxx.CxxInstance{length(Cxx.active_instances)}()
end

const __current_compiler__ = new_cuda_compiler()
addHeaderDir(__current_compiler__, joinpath(CUDA_HOME, "include"), kind = C_System)


cxxinclude(__current_compiler__, "__clang_cuda_runtime_wrapper.h")

# Cxx.jl needs to have this function defined and this is fine as long as we don't call it.
cxx"""
extern "C" {
extern int __cxxjl_personality_v0();
}
"""
end # module
