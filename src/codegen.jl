module Codegen
using Reexport
@reexport using Cxx

const __current_compiler__ = Cxx.new_clang_instance(false, false, target = "nvptx64-nvdia-cuda", CPU = "sm_35")

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
# Needs at least LLVM_VER=3.8
cxxinclude(__current_compiler__, "__clang_cuda_runtime_wrapper.h")

# Cxx.jl needs to have this function defined and this is fine as long as we don't call it.
cxx"""
extern "C" {
extern int __cxxjl_personality_v0();
}
"""
end # module
