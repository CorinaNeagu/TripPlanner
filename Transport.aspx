<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transport.aspx.cs" Inherits="TripPlanner.Transport" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Transport</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" runat="server" Text="Selectați Detalii Transport"></asp:Label>

            <p>Direcție:</p>
            <asp:RadioButtonList ID="rblSens" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Value="DUS" Selected="True"> Dus</asp:ListItem>
                <asp:ListItem Value="INTORS"> Întors</asp:ListItem>
            </asp:RadioButtonList>

            <p>Mijloc Transport:</p>
            <asp:RadioButtonList ID="rblTransport" runat="server" AutoPostBack="true" 
                OnSelectedIndexChanged="rblTransport_SelectedIndexChanged" RepeatDirection="Horizontal">
                <asp:ListItem Value="Avion"> Avion</asp:ListItem>
                <asp:ListItem Value="Tren"> Tren</asp:ListItem>
                <asp:ListItem Value="Autobuz"> Autobuz</asp:ListItem>
                <asp:ListItem Value="Masina"> Mașină</asp:ListItem>
            </asp:RadioButtonList>

            <asp:Panel ID="pnlAvion" runat="server" Visible="false">
                Preț Avion: <asp:TextBox ID="txtPretAvion" runat="server"></asp:TextBox>
            </asp:Panel>
            <asp:Panel ID="pnlTren" runat="server" Visible="false">
                Preț Tren: <asp:TextBox ID="txtPretTren" runat="server"></asp:TextBox>
            </asp:Panel>
            <asp:Panel ID="pnlAutobuz" runat="server" Visible="false">
                Preț Autobuz: <asp:TextBox ID="txtPretAutobuz" runat="server"></asp:TextBox>
            </asp:Panel>
            <asp:Panel ID="pnlMasina" runat="server" Visible="false">
                Preț Mașină: <asp:TextBox ID="txtPretMasina" runat="server"></asp:TextBox>
            </asp:Panel>

            <br />
            <asp:Button ID="btnAdaugaTransport" runat="server" OnClick="btnAdaugaTransport_Click" Text="Adauga Transport" />

            <br /><br />

            <asp:GridView ID="gvTransport" runat="server" AutoGenerateColumns="False" DataKeyNames="transport_id"
                OnRowEditing="gvTransport_RowEditing" 
                OnRowUpdating="gvTransport_RowUpdating" 
                OnRowCancelingEdit="gvTransport_RowCancelingEdit" 
                OnRowDeleting="gvTransport_RowDeleting">
                <Columns>
                    <asp:BoundField DataField="directie" HeaderText="Direcție" ReadOnly="true" />
                    <asp:BoundField DataField="tip_transport" HeaderText="Tip" ReadOnly="true" />
                    <asp:BoundField DataField="cost" HeaderText="Cost" />
                    <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" 
                        EditText="Editează" DeleteText="Șterge" UpdateText="Salvează" CancelText="Renunță" />
                </Columns>
            </asp:GridView>
            <asp:Button ID="btnSalveaza" runat="server" Text="Confirma Selectia si Salveaza" OnClick="btnSalveaza_Click" />

        </div>
    </form>
</body>
</html>