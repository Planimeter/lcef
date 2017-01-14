--=========== Copyright © 2017, Planimeter, All rights reserved. =============--
--
-- Purpose:
--
--============================================================================--

local ffi = require( "ffi" )
io.input( "cef_app_capi.h" )
ffi.cdef( io.read( "*all" ) )
return ffi.load( "cef" )
