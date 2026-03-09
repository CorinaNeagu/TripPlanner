<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cazare.aspx.cs" Inherits="TripPlanner.Cazare" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Gestionare Cazare</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Informații Călătorie Curentă</h2>
            
            <asp:SqlDataSource ID="SqlDataSourceInfo" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
                SelectCommand="SELECT [destination], [start_date], [end_date] FROM [Calatorie] WHERE ([trip_id] = @trip_id)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:DetailsView ID="dvInfo" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSourceInfo" GridLines="None">
                <Fields>
                    <asp:BoundField DataField="destination" HeaderText="Destinație:" />
                    <asp:TemplateField HeaderText="Perioadă:">
                        <ItemTemplate>
                            <asp:Label runat="server" Text='<%# Eval("start_date", "{0:dd/MM/yyyy}") + " - " + Eval("end_date", "{0:dd/MM/yyyy}") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>

            <hr />

            <h2>Opțiuni de Cazare</h2>
            <asp:GridView ID="gvCazare" runat="server" 
                AutoGenerateColumns="False" 
                DataKeyNames="cazare_id" 
                OnRowDeleting="gvCazare_RowDeleting" 
                OnRowEditing="gvCazare_RowEditing" 
                OnRowUpdating="gvCazare_RowUpdating" 
                OnRowCancelingEdit="gvCazare_RowCancelingEdit">
                <Columns>
                    <asp:BoundField DataField="hotel_name" HeaderText="Hotel" />
                    <asp:BoundField DataField="price" HeaderText="Preț per Noapte (€)" DataFormatString="{0:N2}" />
                    
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text="⭐ Selectat" 
                                Visible='<%# Convert.ToBoolean(Eval("is_selected")) %>' />
            
                            <asp:Button ID="btnSwap" runat="server" Text="Alege" 
                                CommandArgument='<%# Eval("cazare_id") %>' 
                                OnClick="btnSwap_Click" 
                                Visible='<%# !Convert.ToBoolean(Eval("is_selected")) %>' 
                                CssClass="btn-blue" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" HeaderText="Gestiune" 
                        EditText="Editează" DeleteText="Șterge" />
                </Columns>
                <EmptyDataTemplate>
                    Nu există hoteluri în catalog.
                </EmptyDataTemplate>
            </asp:GridView>

            <hr />

            <h3>Adaugă Hotel Nou</h3>
            Hotel: <asp:TextBox ID="txtHotel" runat="server"></asp:TextBox>
            Preț (€): <asp:TextBox ID="txtPret" runat="server"></asp:TextBox>
            <asp:Button ID="btnAdd" runat="server" Text="Adaugă în listă" OnClick="btnAdd_Click" />

            <br /><br />
            <asp:LinkButton ID="btnBack" runat="server" OnClick="btnAlegeCazare_Click">⬅ Înapoi la Programul Călătoriei</asp:LinkButton>
        </div>
    </form>
</body>
</html>