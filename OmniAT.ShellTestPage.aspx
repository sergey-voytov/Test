<%@ Page Language="c#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="AssetTracking.Web.AppCode.Utils" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Omni AT Shell</title>
    <style type="text/css">
        html, body
        {
            height: 100%;
            overflow: auto;
        }
        body
        {
            padding: 0;
            margin: 0;
        }
        #silverlightControlHost
        {
            height: 100%;
            text-align: center;
        }
    </style>
    <script type="text/javascript" src="Silverlight.js"></script>
    <script type="text/javascript">
        function onSilverlightError(sender, args) {
            var appSource = "";
            if (sender != null && sender != 0) {
                appSource = sender.getHost().Source;
            }

            var errorType = args.ErrorType;
            var iErrorCode = args.ErrorCode;

            if (errorType == "ImageError" || errorType == "MediaError") {
                return;
            }

            var errMsg = "Unhandled Error in Silverlight Application " + appSource + "\n";

            errMsg += "Code: " + iErrorCode + "    \n";
            errMsg += "Category: " + errorType + "       \n";
            errMsg += "Message: " + args.ErrorMessage + "     \n";

            if (errorType == "ParserError") {
                errMsg += "File: " + args.xamlFile + "     \n";
                errMsg += "Line: " + args.lineNumber + "     \n";
                errMsg += "Position: " + args.charPosition + "     \n";
            }
            else if (errorType == "RuntimeError") {
                if (args.lineNumber != 0) {
                    errMsg += "Line: " + args.lineNumber + "     \n";
                    errMsg += "Position: " + args.charPosition + "     \n";
                }
                errMsg += "MethodName: " + args.methodName + "     \n";
            }

            throw new Error(errMsg);
        }

        function setFocusOnSilverlight() {
            var silverlightObject = document.getElementById('silverlightControlObject');
            if (silverlightObject) { silverlightObject.tabIndex = 0; silverlightObject.focus(); }
        }
    </script>
</head>
<script runat="server">
    public string GetInitParameters()
    {
        NameValueCollection appSettings = ConfigurationManager.GetSection("clientAppSettings") as NameValueCollection;
        
        var res = new List<string>();
        foreach (string key in appSettings.AllKeys)
        {
           res.Add(string.Format("{0}={1}", key, Server.UrlEncode(appSettings[key])));
        }
        return string.Join(", ", res);
    }

</script>
<body onload="setFocusOnSilverlight();">
    <form id="form1" runat="server" style="height: 100%">
    <div id="silverlightControlHost">
        <object id="silverlightControlObject" data="data:application/x-silverlight-2," type="application/x-silverlight-2"
            width="100%" height="100%">
            <param name="source" value="ClientBin/AssetTracking.Shell.xap?CacheKey=<%= new FileInfo(Server.MapPath("~/ClientBin/AssetTracking.Shell.xap")).LastWriteTime.ToString("s") %>" />
            <param name="onError" value="onSilverlightError" />
            <param name="background" value="white" />
            <param name="minRuntimeVersion" value="4.0.50826.0" />
            <param name="autoUpgrade" value="true" />
            <param name="uiculture" value="<%=Thread.CurrentThread.CurrentCulture.Name %>" />
            <param name="culture" value="<%=Thread.CurrentThread.CurrentCulture.Name %>" />
            <param name="InitParams" value="<%= this.GetInitParameters()%>" />
            <a href="http://go.microsoft.com/fwlink/?LinkID=149156&v=4.0.50826.0" style="text-decoration: none">
                <img src="http://go.microsoft.com/fwlink/?LinkId=161376" alt="Get Microsoft Silverlight"
                    style="border-style: none" />
            </a>
        </object><iframe id="_sl_historyFrame" style="visibility: hidden; height: 0px; width: 0px;border: 0px"></iframe></div>
    </form>
</body>
</html>
