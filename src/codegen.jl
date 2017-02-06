module Codegen
using CUDAdrv
using Reexport
@reexport using Cxx

# TODO: Make this configurable
const __cap = capability(CuDevice(0))
const __cpu = "sm_$(__cap.major)$(__cap.minor)"
const __triple = Int === Int64 ? "nvptx64-nvidia-cuda" : "nvptx-nvidia-cuda"
const __current_compiler__ = Cxx.new_clang_instance(false, false, target = __triple, CPU = __cpu)

const candidates = ["/usr/local/cuda", "/opt/cuda"]
cuda_home = ""
if haskey(ENV, "CUDA_HOME")
    cuda_home = ENV["CUDA_HOME"]
else
  for dir in candidates
    if isdir(dir)
      cuda_home = dir
      break
    end
  end
end

isempty(cuda_home) && error("Please set CUDA_HOME to the location of your CUDA installation.")
addHeaderDir(__current_compiler__, joinpath(cuda_home, "include"), kind = C_System)

const LLVM_VERSION = VersionNumber(Base.libllvm_version)
if CUDAdrv.version() == v"8.0.0" && LLVM_VERSION < v"4.0.0"
  error("For CUDA 8.0 we require at least LLVM 4.0")
elseif LLVM_VERSION < v"3.8.1"
  error("LLVM version is to low. At least version 3.8.1 is required.")
end

cxxinclude(__current_compiler__, "__clang_cuda_runtime_wrapper.h")

# Cxx.jl needs to have this function defined and this is fine as long as we don't call it.
cxx"""
extern "C" {
extern int __cxxjl_personality_v0();
}
"""
end # module
