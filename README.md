# CUDAnativelib
Based on [CUDAnative.jl](http://github.com/JuliaGPU/CUDAnative.jl) and [Cxx.jl](htttp://github.com/Keno/Cxx.jl)
this package provides an interface to NVIDIA's device libraries from Julia. It is also meant as an example
on how to interface to legacy C++ CUDA from Julia on the device level.

Contributions to this package to are welcomed.

# CUDA support
Julia v0.6 currently uses LLVM 3.9.1, this means we only supports CUDA 7.0 & 7.5.
CUDA 8.0 support requires at least LLVM 4.0.

# Example

```julia
using CUDAdrv, CUDAnative
using CUDAnativelib
using .CURANDkernel # notice the dot prefix

function fillRandom(out, states)
  i = (blockIdx().x-1) * blockDim().x + threadIdx().x
  if i < min(length(out), length(states))
    # Initialise state
    state = pointer(states, i)
    curand_init(0, i, 0, state) # one should use a decent seed here ;)

    @inbounds out[i] = curand_uniform(eltype(out), state) # @inbounds is optional
  end
  return nothing
end

# code_warntype(STDOUT, fillRandom, (CuDeviceArray{Float32,1}, CuDeviceArray{curandState_t,1}))
# code_warntype(STDOUT, fillRandom, (CuDeviceArray{Float64,1}, CuDeviceArray{curandState_t,1}))

# code_llvm(STDOUT, fillRandom, (CuDeviceArray{Float32,1}, CuDeviceArray{curandState_t,1}))
# code_llvm(STDOUT, fillRandom, (CuDeviceArray{Float64,1}, CuDeviceArray{curandState_t,1}))

dev = CuDevice(0)
ctx = CuContext(dev)
N = 100
state = CuArray{curandState_t}(N)
out = CuArray{Float32}(N)
@cuda (N,1) fillRandom(out, state)
```

