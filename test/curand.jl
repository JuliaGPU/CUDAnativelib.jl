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

