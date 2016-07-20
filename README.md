# CUDAnativelib

This package exposes the device standard library distributed with CUDA.
It requires a special [Julia version](http://github.com/JuliaGPU/julia), with support for Julia to CUDA code generation.

Other dependencies are:
 - [CUDAnative.jl](http://github.com/JuliaGPU/CUDAnative.jl)
 - [Cxx.jl](htttp://github.com/Keno/Cxx.jl)

These dependencies are experimental and need to be installed with `Pkg.clone`.

# Example

```julia
using CUDAdrv, CUDAnative
using CUDAnativelib
using .CURANDkernel # notice the dot prefix

@target ptx function fillRandom(out, states)
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
state = CuArray(curandState_t, (N,)
out = CuArray(Float32, (N,))
@cuda (N,1) fillRandom(out, state)
```

