__precompile__(false)
module CUDAnativelib
  export CURANDkernel

  module Version
    using CUDAdrv
    using Cxx

    export __triple__, __sm__, CUDA_HOME, CUDA_VERSION, LLVM_VERSION

    # TODO: make this configurable
    const __cap__ = capability(CuDevice(0))
    const __sm__ = "sm_$(__cap__.major)$(__cap__.minor)"
    const __triple__ = Int === Int64 ? "nvptx64-nvidia-cuda" : "nvptx-nvidia-cuda"

    const candidates = ["/usr/local/cuda", "/opt/cuda", "/usr"]
    CUDA_HOME = ""
    if haskey(ENV, "CUDA_HOME")
        CUDA_HOME = ENV["CUDA_HOME"]
    else
      for dir in candidates
        if isdir(dir) && isfile(joinpath(dir, "include", "cuda.h"))
          CUDA_HOME = dir
          break
        end
      end
    end


    isempty(CUDA_HOME) && error("Please set CUDA_HOME to the location of your CUDA installation.")
    addHeaderDir(joinpath(CUDA_HOME, "include"), kind = C_System)

    cxxinclude("cuda.h")
    const CUDA_VERSION = icxx"CUDA_VERSION;"
    const LLVM_VERSION = VersionNumber(Base.libllvm_version)
  end

  include("codegen.jl")
  include("curand.jl")
end # module

