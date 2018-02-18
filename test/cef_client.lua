-- CEF C API example
-- Project website: https://github.com/cztomczak/cefcapi

local ffi = require( "ffi" )
local cef = require( "../cef" )


-- ----------------------------------------------------------------------------
-- struct cef_client_t
-- ----------------------------------------------------------------------------

---
-- Implement this structure to provide handler implementations.
---

---
-- Return the handler for context menus. If no handler is
-- provided the default implementation will be used.
---

function get_context_menu_handler(self)
    DEBUG_CALLBACK("get_context_menu_handler\n");
    return nil;
end

---
-- Return the handler for dialogs. If no handler is provided the default
-- implementation will be used.
---
function get_dialog_handler(self)
    DEBUG_CALLBACK("get_dialog_handler\n");
    return nil;
end

---
-- Return the handler for browser display state events.
---
function get_display_handler(self)
    DEBUG_CALLBACK("get_display_handler\n");
    return nil;
end

---
-- Return the handler for download events. If no handler is returned downloads
-- will not be allowed.
---
function get_download_handler(self)
    DEBUG_CALLBACK("get_download_handler\n");
    return nil;
end

---
-- Return the handler for drag events.
---
function get_drag_handler(self)
    DEBUG_CALLBACK("get_drag_handler\n");
    return nil;
end

---
-- Return the handler for focus events.
---
function get_focus_handler(self)
    DEBUG_CALLBACK("get_focus_handler\n");
    return nil;
end

---
-- Return the handler for geolocation permissions requests. If no handler is
-- provided geolocation access will be denied by default.
---
function get_geolocation_handler(self)
    DEBUG_CALLBACK("get_geolocation_handler\n");
    return nil;
end

---
-- Return the handler for JavaScript dialogs. If no handler is provided the
-- default implementation will be used.
---
function get_jsdialog_handler(self)
    DEBUG_CALLBACK("get_jsdialog_handler\n");
    return nil;
end

---
-- Return the handler for keyboard events.
---
function get_keyboard_handler(self)
    DEBUG_CALLBACK("get_keyboard_handler\n");
    return nil;
end

---
-- Return the handler for browser life span events.
---
function get_life_span_handler(self)
    DEBUG_CALLBACK("get_life_span_handler\n");
    -- Implemented!
    return g_life_span_handler;
end

---
-- Return the handler for browser load status events.
---
function get_load_handler(self)
    DEBUG_CALLBACK("get_load_handler\n");
    return nil;
end

---
-- Return the handler for off-screen rendering events.
---
function get_render_handler(self)
    DEBUG_CALLBACK("get_render_handler\n");
    return nil;
end

---
-- Return the handler for browser request events.
---
function get_request_handler(self)
    DEBUG_CALLBACK("get_request_handler\n");
    return nil;
end

---
-- Called when a new message is received from a different process. Return true
-- (1) if the message was handled or false (0) otherwise. Do not keep a
-- reference to or attempt to access the message outside of this callback.
---
function on_process_message_received(self, browser, source_process, message)
    DEBUG_CALLBACK("on_process_message_received\n");
    return 0;
end

function initialize_cef_client(client)
    DEBUG_CALLBACK("initialize_client_handler\n");
    client.base.size = ffi.sizeof( client );
    initialize_cef_base_ref_counted(ffi.cast( "cef_base_ref_counted_t*", client ));
    -- callbacks
    client.get_context_menu_handler = get_context_menu_handler;
    client.get_dialog_handler = get_dialog_handler;
    client.get_display_handler = get_display_handler;
    client.get_download_handler = get_download_handler;
    client.get_drag_handler = get_drag_handler;
    client.get_focus_handler = get_focus_handler;
    client.get_geolocation_handler = get_geolocation_handler;
    client.get_jsdialog_handler = get_jsdialog_handler;
    client.get_keyboard_handler = get_keyboard_handler;
    client.get_life_span_handler = get_life_span_handler;  -- Implemented!
    client.get_load_handler = get_load_handler;
    client.get_render_handler = get_render_handler;
    client.get_request_handler = get_request_handler;
    client.on_process_message_received = on_process_message_received;
end
