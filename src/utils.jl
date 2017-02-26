@generated function alloca{T}(::Type{T})
  len = sizeof(T)
  return quote
    Base.@__inline_meta
    Base.unsafe_convert(Ptr{$T}, Base.llvmcall(
    $"""
    %1 = alloca i8, i32 $(len)
    ret %1
    """, Ptr{UInt8}, Tuple{}))
  end
end
