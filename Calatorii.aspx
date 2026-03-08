<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Calatorii.aspx.cs" Inherits="TripPlanner.Calatorii" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container mt-4">
            
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="trip_id" DataSourceID="SqlDataSourceCalatorii" CssClass="table table-hover">
                <Columns>
                    <asp:BoundField DataField="destination" HeaderText="Destinație" SortExpression="destination" />
                    <asp:BoundField DataField="budget" HeaderText="Buget" SortExpression="budget" DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="start_date" HeaderText="Data Start" SortExpression="start_date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="end_date" HeaderText="Data Final" SortExpression="end_date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="trip_id" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="trip_id" Visible="False" />
                    
                    <asp:CommandField ButtonType="Button" CancelText="Renunță" DeleteText="Șterge" EditText="Editează" ShowDeleteButton="True" ShowEditButton="True" UpdateText="Salvează">
                        <ControlStyle CssClass="btn btn-sm btn-outline-primary" />
                    </asp:CommandField>
                </Columns>
            </asp:GridView>

            <asp:SqlDataSource ID="SqlDataSourceCalatorii" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
                DeleteCommand="DELETE FROM [Calatorie] WHERE [trip_id] = @trip_id" 
                InsertCommand="INSERT INTO [Calatorie] ([destination], [budget], [start_date], [end_date]) VALUES (@destination, @budget, @start_date, @end_date)" 
                SelectCommand="SELECT [destination], [budget], [start_date], [end_date], [trip_id] FROM [Calatorie]" 
                UpdateCommand="UPDATE [Calatorie] SET [destination] = @destination, [budget] = @budget, [start_date] = @start_date, [end_date] = @end_date WHERE [trip_id] = @trip_id">
                <DeleteParameters>
                    <asp:Parameter Name="trip_id" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="destination" Type="String" />
                    <asp:Parameter Name="budget" Type="Decimal" />
                    <asp:Parameter DbType="Date" Name="start_date" />
                    <asp:Parameter DbType="Date" Name="end_date" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="destination" Type="String" />
                    <asp:Parameter Name="budget" Type="Decimal" />
                    <asp:Parameter DbType="Date" Name="start_date" />
                    <asp:Parameter DbType="Date" Name="end_date" />
                    <asp:Parameter Name="trip_id" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>

            <hr />
            <h3>Adaugă Călătorie Nouă</h3>

            <asp:DetailsView ID="DetailsView1" runat="server" DataSourceID="SqlDataSourceCalatorii" DefaultMode="Insert" AutoGenerateRows="False" CssClass="table table-bordered w-50" OnItemInserted="DetailsView1_ItemInserted">
                   <Fields>
        <asp:TemplateField HeaderText="Destinație:">
            <InsertItemTemplate>
                <asp:TextBox ID="txtDest" runat="server" Text='<%# Bind("destination") %>' CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvDest" runat="server" ControlToValidate="txtDest" 
                    ErrorMessage="Destinația este obligatorie!" ForeColor="Red" Display="Dynamic" />
            </InsertItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Buget:">
            <InsertItemTemplate>
                <asp:TextBox ID="txtBudget" runat="server" Text='<%# Bind("budget") %>' CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvBudget" runat="server" ControlToValidate="txtBudget" 
                    ErrorMessage="Introduceți bugetul!" ForeColor="Red" Display="Dynamic" />
                <asp:RangeValidator ID="rvBudget" runat="server" ControlToValidate="txtBudget" 
                    MinimumValue="1" MaximumValue="1000000" Type="Double" 
                    ErrorMessage="Bugetul trebuie să fie între 1 și 1.000.000!" ForeColor="Red" Display="Dynamic" />
            </InsertItemTemplate>
        </asp:TemplateField>
    
        <asp:TemplateField HeaderText="Data Start:">
            <InsertItemTemplate>
                <asp:TextBox ID="txtStart" runat="server" Text='<%# Bind("start_date") %>' TextMode="Date" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvStart" runat="server" ControlToValidate="txtStart" 
                    ErrorMessage="Alegeți data de start!" ForeColor="Red" Display="Dynamic" />
            </InsertItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Data Final:">
            <InsertItemTemplate>
                <asp:TextBox ID="txtEnd" runat="server" Text='<%# Bind("end_date") %>' TextMode="Date" CssClass="form-control"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEnd" runat="server" ControlToValidate="txtEnd" 
                    ErrorMessage="Alegeți data finală!" ForeColor="Red" Display="Dynamic" />
            
                <asp:CompareValidator ID="cvDates" runat="server" 
                    ControlToValidate="txtEnd" 
                    ControlToCompare="txtStart" 
                    Operator="GreaterThanEqual" 
                    Type="Date" 
                    ErrorMessage="Data finală nu poate fi înainte de data de start!" 
                    ForeColor="Red" Display="Dynamic" />
            </InsertItemTemplate>
        </asp:TemplateField>

        <asp:CommandField InsertText="Salvează Călătoria" ShowInsertButton="True">
            <ControlStyle CssClass="btn btn-success" />
        </asp:CommandField>
    </Fields>   
            </asp:DetailsView>
        </div>
    </form>
</body>
</html>
