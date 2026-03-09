<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Charts.aspx.cs" Inherits="TripPlanner.Charts" %>
<%@ Register TagPrefix="zgc" Namespace="ZedGraph.Web" Assembly="ZedGraph.Web" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Statistici Calatorie</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="padding: 20px; text-align: center;">
            <h2>Vizualizare</h2>
           
            <zgc:ZedGraphWeb ID="ZedGraphWeb1" runat="server" 
                Width="700" Height="500" 
                OnRenderGraph="ZedGraphWeb1_RenderGraph" />

            <br /><br />
            <asp:HyperLink ID="lnkBack" runat="server" Text="Inapoi" 
                NavigateUrl="~/Program.aspx" style="text-decoration:none; color:blue;" />
        </div>
    </form>
</body>
</html>