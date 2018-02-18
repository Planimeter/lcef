-- CEF C API example
-- Project website: https://github.com/cztomczak/cefcapi

local ffi = require( "ffi" )
local cef = require( "../cef" )

-- ----------------------------------------------------------------------------
-- cef_app_t
-- ----------------------------------------------------------------------------

---
-- Implement this structure to provide handler implementations. Methods will be
-- called by the process and/or thread indicated.
---

---
-- Provides an opportunity to view and/or modify command-line arguments before
-- processing by CEF and Chromium. The |process_type| value will be NULL for
-- the browser process. Do not keep a reference to the cef_command_line_t
-- object passed to this function. The CefSettings.command_line_args_disabled
-- value can be used to start with an NULL command-line object. Any values
-- specified in CefSettings that equate to command-line arguments will be set
-- before this function is called. Be cautious when using this function to
-- modify command-line arguments for non-browser processes as this may result
-- in undefined behavior including crashes.
---
function on_before_command_line_processing(self, process_type, command_line)
    DEBUG_CALLBACK("on_before_command_line_processing\n");
end

---
-- Provides an opportunity to register custom schemes. Do not keep a reference
-- to the |registrar| object. This function is called on the main thread for
-- each process and the registered schemes should be the same across all
-- processes.
---
function on_register_custom_schemes(self, registrar)
    DEBUG_CALLBACK("on_register_custom_schemes\n");
end

---
-- Return the handler for resource bundle events. If
-- CefSettings.pack_loading_disabled is true (1) a handler must be returned.
-- If no handler is returned resources will be loaded from pack files. This
-- function is called by the browser and render processes on multiple threads.
---
function get_resource_bundle_handler(self)
    DEBUG_CALLBACK("get_resource_bundle_handler\n");
    return nil;
end

---
-- Return the handler for functionality specific to the browser process. This
-- function is called on multiple threads in the browser process.
---
function get_browser_process_handler(self)
    DEBUG_CALLBACK("get_browser_process_handler\n");
    return nil;
end

---
-- Return the handler for functionality specific to the render process. This
-- function is called on the render process main thread.
---
function get_render_process_handler(self)
    DEBUG_CALLBACK("get_render_process_handler\n");
    return nil;
end

function initialize_cef_app(app)
    ffi.C.printf("initialize_cef_app\n");
    -- app.base.size = ffi.sizeof( app );
    -- initialize_cef_base_ref_counted(ffi.cast( "cef_base_ref_counted_t*", app ));
    -- callbacks
    app.on_before_command_line_processing = on_before_command_line_processing;
    app.on_register_custom_schemes = on_register_custom_schemes;
    app.get_resource_bundle_handler = get_resource_bundle_handler;
    app.get_browser_process_handler = get_browser_process_handler;
    app.get_render_process_handler = get_render_process_handler;
end
