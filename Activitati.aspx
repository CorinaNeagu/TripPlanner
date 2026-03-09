<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Activitati.aspx.cs" Inherits="TripPlanner.Activitati" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pagina Activitati</title>

</head>

<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Gestiune&nbsp; Activitati</h2>

            <div class="filter-section">
                <strong>Filtreaza dupa Categorie:</strong> 
                <asp:DropDownList ID="ddlFiltruCategorie" runat="server" AutoPostBack="True" AppendDataBoundItems="True">
                    <asp:ListItem Value="%">Toate categoriile</asp:ListItem>
                    <asp:ListItem>Cultural</asp:ListItem>
                    <asp:ListItem>Sport</asp:ListItem>
                    <asp:ListItem>Mancare</asp:ListItem>
                    <asp:ListItem>Relaxare</asp:ListItem>
                </asp:DropDownList>
            </div>

<asp:SqlDataSource ID="SqlDataSource1" runat="server" 
    ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
    DeleteCommand="DELETE FROM [Activitati] WHERE [activitate_id] = @activitate_id" 
    InsertCommand="INSERT INTO [Activitati] ([nume_activitate], [categorie], [pret], [destination]) VALUES (@nume_activitate, @categorie, @pret, (SELECT [destination] FROM [Calatorie] WHERE [trip_id] = @trip_id))" 
    SelectCommand="SELECT * FROM [Activitati] WHERE ([destination] = (SELECT [destination] FROM [Calatorie] WHERE [trip_id] = @trip_id)) AND ([categorie] LIKE @categorie_filter)" 
    UpdateCommand="UPDATE [Activitati] SET [nume_activitate] = @nume_activitate, [categorie] = @categorie, [pret] = @pret WHERE [activitate_id] = @activitate_id">
    
    <SelectParameters>
        <asp:ControlParameter ControlID="ddlFiltruCategorie" Name="categorie_filter" PropertyName="SelectedValue" Type="String" DefaultValue="%" />
        <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
    </SelectParameters>

    <InsertParameters>
        <asp:Parameter Name="nume_activitate" Type="String" />
        <asp:Parameter Name="categorie" Type="String" />
        <asp:Parameter Name="pret" Type="Decimal" />
        <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
    </InsertParameters>

    <UpdateParameters>
        <asp:Parameter Name="nume_activitate" Type="String" />
        <asp:Parameter Name="categorie" Type="String" />
        <asp:Parameter Name="pret" Type="Decimal" />
        <asp:Parameter Name="activitate_id" Type="Int32" />
    </UpdateParameters>
</asp:SqlDataSource>

            <h3>Lista Activitati</h3>
            <asp:GridView ID="GridView1" runat="server" DataKeyNames="activitate_id" DataSourceID="SqlDataSource1" AutoGenerateColumns="False" CssClass="modern-grid">
    <Columns>
        <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" CancelText="Anulează" UpdateText="Salvează" EditText="Editează" DeleteText="Șterge" />
        <asp:BoundField DataField="activitate_id" HeaderText="ID" ReadOnly="True" />
        <asp:BoundField DataField="nume_activitate" HeaderText="Activitate" />
        
        <asp:TemplateField HeaderText="Categorie">
            <ItemTemplate><%# Eval("categorie") %></ItemTemplate>
            <EditItemTemplate>
                <asp:DropDownList ID="ddlEditCategorie" runat="server" SelectedValue='<%# Bind("categorie") %>'>
                    <asp:ListItem>Cultural</asp:ListItem>
                    <asp:ListItem>Sport</asp:ListItem>
                    <asp:ListItem>Mancare</asp:ListItem>
                    <asp:ListItem>Relaxare</asp:ListItem>
                </asp:DropDownList>
            </EditItemTemplate>
        </asp:TemplateField>

        <asp:BoundField DataField="pret" HeaderText="Preț (€)" DataFormatString="{0:F2}" />

        <asp:TemplateField HeaderText="Actiune">
            <ItemTemplate>
                <asp:Button ID="btnSelecteaza" runat="server" Text="Alege" 
                    CausesValidation="False" 
                    OnClick="btnSelecteaza_Click" 
                    CommandArgument='<%# Eval("activitate_id") + "|" + Eval("nume_activitate") + "|" + Eval("pret") %>' />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

            <br />

            <asp:Label ID="lblError" runat="server" ForeColor="Red" Font-Bold="true" EnableViewState="false"></asp:Label>
            <h3>Adauga Activitate Noua</h3>
           <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSource1" DefaultMode="Insert">
    <Fields>
        <asp:TemplateField HeaderText="Nume:">
            <InsertItemTemplate>
                <asp:TextBox ID="txtNume" runat="server" Text='<%# Bind("nume_activitate") %>'></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNume" runat="server" 
                    ControlToValidate="txtNume" ErrorMessage="* Nume obligatoriu" 
                    ForeColor="Red" Display="Dynamic" 
                    ValidationGroup="GrupCatalog" /> 
            </InsertItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Categorie:">
            <InsertItemTemplate>
                <asp:DropDownList ID="ddlInsertCategorie" runat="server" SelectedValue='<%# Bind("categorie") %>'>
                    <asp:ListItem Value="">-- Alege --</asp:ListItem>
                    <asp:ListItem>Cultural</asp:ListItem>
                    <asp:ListItem>Sport</asp:ListItem>
                    <asp:ListItem>Mancare</asp:ListItem>
                    <asp:ListItem>Relaxare</asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvCat" runat="server" 
                    ControlToValidate="ddlInsertCategorie" InitialValue="" 
                    ErrorMessage="* Alege categoria" ForeColor="Red" Display="Dynamic" 
                    ValidationGroup="GrupCatalog" /> 
            </InsertItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Pret (€):">
            <InsertItemTemplate>
                <asp:TextBox ID="txtPret" runat="server" Text='<%# Bind("pret") %>'></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPret" runat="server" 
                    ControlToValidate="txtPret" ErrorMessage="* Preț obligatoriu" 
                    ForeColor="Red" Display="Dynamic" 
                    ValidationGroup="GrupCatalog" /> <
                <asp:RangeValidator ID="rvPret" runat="server" 
                    ControlToValidate="txtPret" MinimumValue="0" MaximumValue="10000" Type="Double" 
                    ErrorMessage="* Pret invalid" ForeColor="Red" Display="Dynamic" 
                    ValidationGroup="GrupCatalog" />
            </InsertItemTemplate>
        </asp:TemplateField>

        <asp:CommandField ShowInsertButton="True" InsertText="Salvează în Catalog" 
            ValidationGroup="GrupCatalog" /> 
    </Fields>
</asp:DetailsView>


                    <div style="margin-top: 20px; font-weight: bold; color: #2c3e50;">
                        <asp:Label ID="lblStatistici" runat="server" Text="Se calculeaza statisticile..."></asp:Label>
                    </div>

            <asp:Button ID="btnInapoiProgram" runat="server" CausesValidation="False" OnClick="btnInapoiProgram_Click" Text="Inapoi" />

            <br />
        </div>
    </form>
</body>
</html>
