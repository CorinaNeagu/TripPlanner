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

            <p>Directie:</p>
            <asp:RadioButtonList ID="rblSens" runat="server" RepeatDirection="Horizontal">
                <asp:ListItem Value="DUS" Selected="True"> Dus</asp:ListItem>
                <asp:ListItem Value="INTORS"> Intors</asp:ListItem>
            </asp:RadioButtonList>

            <p>Mijloc Transport:</p>
            <asp:RadioButtonList ID="rblTransport" runat="server" AutoPostBack="true" 
                OnSelectedIndexChanged="rblTransport_SelectedIndexChanged" RepeatDirection="Horizontal">
                <asp:ListItem Value="Avion"> Avion</asp:ListItem>
                <asp:ListItem Value="Tren"> Tren</asp:ListItem>
                <asp:ListItem Value="Autobuz"> Autobuz</asp:ListItem>
                <asp:ListItem Value="Masina"> Masina</asp:ListItem>
            </asp:RadioButtonList>

            <asp:Panel ID="pnlAvion" runat="server" Visible="false">
                Pret Avion: <asp:TextBox ID="txtPretAvion" runat="server" TextMode="Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvAvion" runat="server" 
                    ControlToValidate="txtPretAvion" ErrorMessage="Introduceti pretul!" 
                    ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
    
                <asp:CompareValidator ID="cvAvion" runat="server" 
                    ControlToValidate="txtPretAvion" Operator="DataTypeCheck" Type="Double" 
                    ErrorMessage="Introduceti un numar valid!" ForeColor="Red" Display="Dynamic">
                </asp:CompareValidator>
            </asp:Panel>

            <asp:Panel ID="pnlTren" runat="server" Visible="false">
                Preț Tren: <asp:TextBox ID="txtPretTren" runat="server" TextMode="Number"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="txtPretTren" ErrorMessage="Introduceti pretul!" 
                    ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
    
                <asp:CompareValidator ID="CompareValidator1" runat="server" 
                    ControlToValidate="txtPretTren" Operator="DataTypeCheck" Type="Double" 
                    ErrorMessage="Introduceti un numar valid!" ForeColor="Red" Display="Dynamic">
                </asp:CompareValidator>
            </asp:Panel>

            <asp:Panel ID="pnlAutobuz" runat="server" Visible="false">
                Preț Autobuz: <asp:TextBox ID="txtPretAutobuz" runat="server" TextMode="Number" ></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="txtPretAutobuz" ErrorMessage="Introduceti pretul!" 
                    ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
    
                <asp:CompareValidator ID="CompareValidator2" runat="server" 
                    ControlToValidate="txtPretAutobuz" Operator="DataTypeCheck" Type="Double" 
                    ErrorMessage="Introduceti un numar valid!" ForeColor="Red" Display="Dynamic">
                </asp:CompareValidator>
            </asp:Panel>

            <asp:Panel ID="pnlMasina" runat="server" Visible="false">
                Pret Masina: <asp:TextBox ID="txtPretMasina" runat="server" TextMode="Number"></asp:TextBox>
                 <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                     ControlToValidate="txtPretMasina" ErrorMessage="Introduceti pretul" 
                     ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
    
                 <asp:CompareValidator ID="CompareValidator3" runat="server" 
                     ControlToValidate="txtPretMasina" Operator="DataTypeCheck" Type="Double" 
                     ErrorMessage="Introduceti un numar valid!" ForeColor="Red" Display="Dynamic">
                 </asp:CompareValidator>
            </asp:Panel>

            <br />
            <asp:Label ID="lblMesajEroare" runat="server" ForeColor="Red" Font-Bold="true" EnableViewState="false"></asp:Label>
            <br />
            <asp:Button ID="btnAdaugaTransport" runat="server" OnClick="btnAdaugaTransport_Click" Text="Adauga Transport" />

            <br /><br />

            <asp:GridView ID="gvTransport" runat="server" AutoGenerateColumns="False" DataKeyNames="transport_id"
                OnRowEditing="gvTransport_RowEditing" 
                OnRowUpdating="gvTransport_RowUpdating" 
                OnRowCancelingEdit="gvTransport_RowCancelingEdit" 
                OnRowDeleting="gvTransport_RowDeleting" >
                <Columns>
                    <asp:BoundField DataField="directie" HeaderText="Directie" ReadOnly="true" />
                    <asp:BoundField DataField="tip_transport" HeaderText="Tip" ReadOnly="true" />
                    <asp:BoundField DataField="cost" HeaderText="Cost" />
                    <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" 
                        EditText="Editeaza" DeleteText="Sterge" UpdateText="Salveaza" CancelText="Renunță" />
                </Columns>
            </asp:GridView>
            <asp:Button ID="btnSalveaza" runat="server" Text="Confirma Selectia si Salveaza" OnClick="btnSalveaza_Click" />

        </div>
    </form>
</body>
</html>