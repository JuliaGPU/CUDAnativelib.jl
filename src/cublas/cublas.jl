module CUBLASkernel
using ..Codegen

const __current_compiler__ = Codegen.__current_compiler__

cxx"""
#include <cublas_v2.h>
"""

include("libcublas_types.jl")
include("api_helper.jl")

end
