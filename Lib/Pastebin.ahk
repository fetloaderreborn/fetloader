; Description: Upload logfile to Pastebin!
#include Lib\Multipart.ahk
#include Lib\WinHTTPRequest.ahk

class Pastebin 
{
    UploadLog()
    {
        if (!pastebin_key)
        {
            MsgBox, 0, %script% Logs Uploader, %string_empty_pastebin_key%
            return
        }
        IfNotExist, logs\%A_DD%-%A_MM%-%A_YYYY%.log
        {
            MsgBox, 0, %script% Logs Uploader, %string_no_logs_found%
            return
        }
        Multipart.Make(PostData, PostHeader
            , "api_option=paste"
            , "api_dev_key="+pastebin_key
            , "api_paste_private=0"
            , "api_paste_name=" script " Logs"
            , "api_paste_expire_date=N"
            , "api_paste_code=<logs\" A_DD "-" A_MM "-" A_YYYY ".log")
        WinHttpRequest("https://pastebin.com/api/api_post.php", PostData, PostHeader, "+NO_AUTO_REDIRECT+SaveAs:logs_upload.tmp")
        FileRead, logurl, logs_upload.tmp
        FileDelete, logs_upload.tmp
        if (InStr(logurl, "Bad API request"))
        {
            MsgBox, 0, %script% Logs Uploader, %logurl%
            return
        }
        MsgBox, 0, %script% Logs Uploader, %string_logs_uploaded%  
        Run, %logurl%
        Return
    }
}
