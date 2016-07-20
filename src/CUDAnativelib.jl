__precompile__(false)
module CUDAnativelib
  export CURANDkernel
  include("codegen.jl")
  include("curand.jl")
end # module

