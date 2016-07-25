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

export new, delete
new(::Type{curandState_t}) = icxx"return (curandState_t*) malloc(sizeof(curandState_t));"
delete(x) = icxx"free($x);"

"""
   curand_init(see, sequence, offset, state)

Initialisation for `curandState_t`

# Arguments
- `seed`
- `sequence`
- `offset`
- `state` Cxx pointer to a state
"""
function curand_init(seed, sequence, offset, state)
  icxx"""
    curand_init($seed, $sequence, $offset, $state);
  """
end

"""
   curand(state)

"""
curand(state) = icxx"curand($state);"

curand_uniform(::Type{Float32}, state) = icxx"curand_uniform($state);"
curand_uniform(::Type{Float64}, state) = icxx"curand_uniform_double($state);"

curand_normal(::Type{Float32}, state) = icxx"curand_normal($state);"
curand_normal(::Type{Float64}, state) = icxx"curand_normal_double($state);"

curand_log_normal(::Type{Float32}, state, mean, stddev) =
  icxx"curand_log_normal($state, $mean, $stddev);"
curand_log_normal(::Type{Float64}, state, mean, stddev) =
  icxx"curand_log_normal_double($state, $mean, $stddev);"

curand_poisson(state, lambda) = icxx"curand_poisson($state, $lambda);"

end
