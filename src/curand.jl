module CURANDkernel
using ..Codegen

export curandState_t, curandStateSobol32_t
export curand_init, curand, curand_uniform, curand_normal, curand_log_normal, curand_poisson

const __current_compiler__ = Codegen.__current_compiler__

cxx"""
#include <curand_kernel.h>
"""

"""
    curandState_t

"""
typealias curandState_t cxxt"curandState_t"{48}

"""
    curandStateSobol32_t

"""
typealias curandStateSobol32_t cxxt"curandStateSobol32_t"{140}

"""
   curand_init(see, sequence, offset, state)

Initialisation for `curandState_t`

# Arguments
- `seed`
- `sequence`
- `offset`
- `state::Ptr{curandState_t}`
"""
function curand_init(seed, sequence, offset, state :: Ptr{curandState_t})
  @cxx curand_init(seed, sequence, offset, state)
end

"""
   curand_init(direction_vectors, offset, state)

Initialisation for `curandStateSobol32_t`
"""
function curand_init(direction_vectors, offset, state :: Ptr{curandStateSobol32_t})
  @cxx curand_init(direction_vectors, offset, state)
end

"""
   curand_init(direction_vectors, scamble_c, offset, state)

Initialisation for `curandStateSobol32_t`
"""
 function curand_init(direction_vectors, scramble_c, offset, state :: Ptr{curandStateSobol32_t})
   @cxx curand_init(direction_vectors, scramble_c, offset, state)
 end

"""
   curand(state)

"""
curand(state) = @cxx curand(state)

curand_uniform(::Type{Float32}, state) = @cxx curand_uniform(state)
curand_uniform(::Type{Float64}, state) = @cxx curand_uniform_double(state)

curand_normal(::Type{Float32}, state) = @cxx curand_normal(state)
curand_normal(::Type{Float64}, state) = @cxx curand_normal_double(state)

curand_log_normal(::Type{Float32}, state, mean, stddev) =
  @cxx curand_log_normal(state, mean, stddev)
curand_log_normal(::Type{Float64}, state, mean, stddev) =
  @cxx curand_log_normal_double(state, mean, stddev)

curand_poisson(state, lambda) = @cxx curand_poisson(state, lambda)

end
