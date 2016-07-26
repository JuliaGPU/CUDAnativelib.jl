__precompile__(false)
module CUDAnativelib
  export CURANDkernel
  include("codegen.jl")
  include("curand.jl")
  include("cublas/cublas.jl")
end # module

