"""
    cublasCreate()

Creates a cublasHandle_t

# TODO:
- check return status
"""
function cublasCreate()
  icxx"""
  cublasHandle_t handle;
  cublaseStatus_t status = cublasCreate(&handle);
  return handle;
  // return make_tuple(status,handle);
  """
end

"""
    cublasDestroy(handle)
"""
cublasDestroy(handle) = icxx"cublasDestroy($handle)"

"""
    cublasGetVersion(handle)

# TODO:
- Check return status
"""
function cublasGetVersion(handle)
  icxx"""
  int version;
  cublasStatus_t cublasGetVersion($handle, &version);
  return version;
  """
end

"""
    cublasSetStream(handle, streamId)
"""
cublasSetStream(handle, streamId) = icxx"""cublasSetStream($handle, $streamId);"""

"""
    cublasGetStream(handle)

# TODO
- check status
"""
function cublasGetStream(handle)
  icxx"""
  cudaStream_t streamId;
  cublasStatus_t status = cublasGetStream($handle, &streamId);
  return streamId;
  """
end


"""
    cublasGetPointerMode(handle)

# TODO
- check status
"""
function cublasGetPointerMode(handle)
  icxx"""
  cublasPointerMode_t mode;
  cublasStatus_t status = cublasGetPointerMode($handle, &mode);
  return mode;
  """
end

"""
    cublasSetPointerMode(handle, mode)
"""
cublasSetPointerMode(handle, mode) = icxx"""cublasSetPointerMode($handle, $mode);"""

###
# Note:
# Get/Set Vector/Matrix are not implemented as of yet, because the seem to be of little use for device-level only API.
###

"""
    cublasGetAtomicsMode(handle)

# TODO
- check status
"""
function cublasGetAtomicsMode(handle)
  icxx"""
  cublasAtomicsMode_t mode;
  cublasStatus_t status = cublasGetAtomicsMode($handle, &mode);
  return mode;
  """
end

"""
    cublasSetAtomicsMode(handle, mode)
"""
cublasAtomicsMode(handle, mode) = icxx"""cublasAtomicsMode($handle, $mode);"""
