# CUDAnativelib
**[Build status](https://ci.maleadt.net/buildbot/julia/waterfall?tag=CUDAnativelib)** (Linux x86-64): [![](https://ci.maleadt.net/buildbot/julia/png?builder=CUDAnativelib.jl:%20Julia%20master%20(x86-64))](https://ci.maleadt.net/buildbot/julia/builders/CUDAnativelib.jl%3A%20Julia%20master%20%28x86-64%29)

Based on [CUDAnative.jl](http://github.com/JuliaGPU/CUDAnative.jl) and [Cxx.jl](http://github.com/Keno/Cxx.jl)
this package provides an interface to NVIDIA's device libraries from Julia.

It is also meant as an example on how to interface to legacy C++ CUDA from Julia on the device level.

Contributions to this package are welcomed.

# CUDA support
Julia v0.6 currently uses LLVM 3.9.1, this means we only supports CUDA 7.0 & 7.5.
Full CUDA 8.0 support requires at least LLVM 4.0, but we provide some compatibility headers
to partially support CUDA 8 on LLVM 3.9.1. If this does not work for you we recommend to parallely
install CUDA 7.X and use the environment variable `CUDA_HOME` to change the CUDA version `CUDAnativelib` uses.

# Example

```julia
using CUDAdrv, CUDAnative
using CUDAnativelib
using .CURANDkernel # notice the dot prefix

function fillRandom(out)
  i = (blockIdx().x-1) * blockDim().x + threadIdx().x
  if i <= length(out)
    # Initialise state
    state = new(curandState_t)
    curand_init(0, i, 0, state) # one should use a decent seed here ;)
    @inbounds out[i] = curand_uniform(eltype(out), state) # @inbounds is optional
    delete(state)
  end
  return nothing
end

##
# Uncomment the following lines to see how the above function is lowered
# Also note how we use multiple dispatch to select the right `curand_uniform` function.
##

# code_warntype(STDOUT, fillRandom, (CuDeviceArray{Float32,1},))
# code_warntype(STDOUT, fillRandom, (CuDeviceArray{Float64,1},))

# CUDAnative.code_llvm(STDOUT, fillRandom, (CuDeviceArray{Float32,1},))
# CUDAnative.code_llvm(STDOUT, fillRandom, (CuDeviceArray{Float64,1},))

dev = CuDevice(0)
ctx = CuContext(dev)
N = 100
out = CuArray{Float32}(N)
@cuda (N,1) fillRandom(out)
c = Array(out) # force sync
```

