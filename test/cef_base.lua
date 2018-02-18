-- CEF C API example
-- Project website: https://github.com/cztomczak/cefcapi

local ffi = require( "ffi" )
local cef = require( "../cef" )

-- Set to 1 to check if add_ref() and release()
-- are called and to track the total number of calls.
-- add_ref will be printed as "+", release as "-".
DEBUG_REFERENCE_COUNTING = false

-- Print only the first execution of the callback,
-- ignore the subsequent.
function DEBUG_CALLBACK(x)
    first_call = first_call or {}
    if (first_call[x] == nil) then
        first_call[x] = 1;
        ffi.C.printf(x);
    end
end

-- ----------------------------------------------------------------------------
-- cef_base_ref_counted_t
-- ----------------------------------------------------------------------------

---
-- Structure defining the reference count implementation functions.
-- All framework structures must include the cef_base_ref_counted_t
-- structure first.
---

---
-- Increment the reference count.
---
function add_ref(self)
    DEBUG_CALLBACK("cef_base_ref_counted_t.add_ref\n");
    if (DEBUG_REFERENCE_COUNTING) then
        ffi.C.printf("+");
    end
end

---
-- Decrement the reference count.  Delete this object when no references
-- remain.
---
function release(self)
    DEBUG_CALLBACK("cef_base_ref_counted_t.release\n");
    if (DEBUG_REFERENCE_COUNTING) then
        ffi.C.printf("-");
    end
    return 1;
end

---
-- Returns the current number of references.
---
function has_one_ref(self)
    DEBUG_CALLBACK("cef_base_ref_counted_t.has_one_ref\n");
    if (DEBUG_REFERENCE_COUNTING) then
        ffi.C.printf("=");
    end
    return 1;
end

function initialize_cef_base_ref_counted(base)
    ffi.C.printf("initialize_cef_base_ref_counted\n");
    -- Check if "size" member was set.
    local size = base.size;
    -- Let's print the size in case sizeof was used
    -- on a pointer instead of a structure. In such
    -- case the number will be very high.
    ffi.C.printf("cef_base_ref_counted_t.size = %lu\n", size);
    if (size <= 0) then
        ffi.C.printf("FATAL: initialize_cef_base failed, size member not set\n");
        os.exit(1);
    end
    base.add_ref = add_ref;
    base.release = release;
    base.has_one_ref = has_one_ref;
end
