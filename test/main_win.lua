argc = 0
for k, v in pairs( arg ) do argc = argc + 1 end
-- CEF C API example
-- Project website: https://github.com/cztomczak/cefcapi

local ffi = require( "ffi" )
ffi.cdef [[
    int printf(const char *fmt, ...);
    struct HINSTANCE__{int unused;}; typedef struct HINSTANCE__ *HINSTANCE;
    typedef HINSTANCE HMODULE;
    typedef char            CHAR;
    typedef const CHAR      *LPCSTR, *PCSTR;
    typedef LPCSTR          PCTSTR, LPCTSTR, PCUTSTR, LPCUTSTR;
    HMODULE GetModuleHandleW(
      LPCTSTR lpModuleName
    );
]]

local cef = require( "../cef" )
require( "test.cef_base" )
require( "test.cef_client" )
require( "test.cef_life_span_handler" )

-- Globals
g_life_span_handler = ffi.new( "cef_life_span_handler_t" );


-- This executable is called many times, because it
-- is also used for subprocesses. Let's print args
-- so we can differentiate between main process and
-- subprocesses. If one of the first args is for
-- example "--type=renderer" then it means that
-- this is a Renderer process. There may be more
-- subprocesses like GPU (--type=gpu-process) and
-- others. On Linux there are also special Zygote
-- processes.
ffi.C.printf("\nProcess args: ");
if (argc == 1) then
    ffi.C.printf("none (Main process)");
else
    for i = -1, argc - 2 do
        if (string.len(arg[i]) > 128) then
            ffi.C.printf("... ");
        else
            ffi.C.printf("%s ", arg[i]);
        end
    end
end
ffi.C.printf("\n\n");

-- CEF version
if (argc == 0) then
    ffi.C.printf("CEF version: %s\n", "3.3282.1733.g9091548");
end

-- Main args
local main_args = ffi.new( "cef_main_args_t" );
main_args.instance = ffi.C.GetModuleHandleW(nil);

-- Cef app
local app = ffi.new( "cef_app_t" );
-- initialize_cef_app(app);

-- Application settings. It is mandatory to set the
-- "size" member.
local settings = ffi.new( "cef_settings_t" );
settings.size = ffi.sizeof( settings );
settings.log_severity = ffi.C.LOGSEVERITY_WARNING; -- Show only warnings/errors
settings.no_sandbox = 1;
-- Specify the path for the sub-process executable.
local browser_subprocess_path = "cef.exe";
local cef_browser_subprocess_path = ffi.new( "cef_string_t" );
cef.cef_string_utf8_to_utf16(browser_subprocess_path,
                             string.len(browser_subprocess_path),
                             cef_browser_subprocess_path);
settings.browser_subprocess_path = cef_browser_subprocess_path;

-- Initialize CEF
ffi.C.printf("cef_initialize\n");
cef.cef_initialize(main_args, settings, app, nil);

-- Window info
local window_info = ffi.new( "cef_window_info_t" );
window_info.style = bit.bor( bit.bor( 0x00000000, 0x00C00000, 0x00080000,
        0x00040000, 0x00020000, 0x00010000 ), 0x02000000, 0x04000000,
        0x10000000 );
window_info.parent_window = nil;
window_info.x = 0x80000000;
window_info.y = 0x80000000;
window_info.width = 0x80000000;
window_info.height = 0x80000000;

-- Window info - window title
local window_name = "cefcapi example";
local cef_window_name = ffi.new( "cef_string_t" );
cef.cef_string_utf8_to_utf16(window_name, string.len(window_name),
                             cef_window_name);
window_info.window_name = cef_window_name;

-- Initial url
local url = "https://www.google.com/ncr";
local cef_url = ffi.new( "cef_string_t" );
cef.cef_string_utf8_to_utf16(url, string.len(url), cef_url);

-- Browser settings. It is mandatory to set the
-- "size" member.
local browser_settings = ffi.new( "cef_browser_settings_t" );
browser_settings.size = ffi.sizeof( browser_settings );

-- Client handlers
local client = ffi.new( "cef_client_t" );
initialize_cef_client(client);
initialize_cef_life_span_handler(g_life_span_handler);

-- Create browser asynchronously. There is also a
-- synchronous version of this function available.
ffi.C.printf("cef_browser_host_create_browser\n");
cef.cef_browser_host_create_browser(window_info, client, cef_url,
                                    browser_settings, nil);

-- Message loop. There is also cef_do_message_loop_work()
-- that allow for integrating with existing message loops.
-- On Windows for best performance you should set
-- cef_settings_t.multi_threaded_message_loop to true.
-- Note however that when you do that CEF UI thread is no
-- more application main thread and using CEF API is more
-- difficult and require using functions like cef_post_task
-- for running tasks on CEF UI thread.
ffi.C.printf("cef_run_message_loop\n");
cef.cef_run_message_loop();

-- Shutdown CEF
ffi.C.printf("cef_shutdown\n");
cef.cef_shutdown();

os.exit(0);
