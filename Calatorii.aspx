<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Calatorii.aspx.cs" Inherits="TripPlanner.Calatorii" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
<style>
    body { font: 14px sans-serif; background: whitesmoke; color: darkslategray; padding: 40px 20px; }
    
    .main-card { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px silver; }
    
    .section-header { font-size: 20px; font-weight: bold; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; color: black; }

    .modern-grid { width: 100%; border-collapse: collapse; }
    .modern-grid tr { display: flex; flex-direction: column; border: 1px solid lightgray; border-radius: 8px; margin-bottom: 12px; padding: 15px; }
    .modern-grid tr:hover { border-color: indigo; background: snow; }
    .modern-grid th { display: none; }
    .modern-grid td { border: none; padding: 2px 0; }

    .dest-name { font-size: 16px; font-weight: bold; color: black; }
    .dest-info { font-size: 12px; color: gray; }
    .dest-price { font-weight: bold; color: indigo; margin-top: 5px; }

    .input-field { width: 100%; padding: 10px; border: 1px solid silver; border-radius: 6px; margin-top: 5px; outline: none; }
    .input-field:focus { border-color: indigo; }
    
    .btn-primary { background: indigo; color: white; padding: 12px; border-radius: 6px; border: none; font-weight: bold; cursor: pointer; width: 100%; margin-top: 15px; }
    .btn-primary:hover { opacity: 0.8; }
    
    .btn-outline { color: gray; border: 1px solid silver; padding: 5px 10px; border-radius: 4px; font-size: 12px; text-decoration: none; display: inline-block; margin-top: 8px; }
    .btn-outline:hover { background: whitesmoke; color: indigo; border-color: indigo; }

    .filter-box { margin-bottom: 25px; display: flex; gap: 10px; }
</style>
</head>

<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container mt-4">
            <h2 class="text-primary">Management Calatorii</h2>
            <hr />

            <div class="row mb-4 p-3 bg-white shadow-sm rounded align-items-end">
                <div class="col-md-4">
                    <label class="form-label fw-bold">Filtrează după destinație:</label>
                    <asp:DropDownList ID="DropDownList1" runat="server" AutoPostBack="True" 
                        DataSourceID="SqlDataSourceFiltruCalatorie" 
                        DataTextField="destination" DataValueField="destination" 
                        CssClass="form-select" AppendDataBoundItems="True">
                        <asp:ListItem Value="%">-- Toate destinațiile --</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnShowAll" runat="server" Text="Vezi toate" 
                        OnClick="btnShowAll_Click" CausesValidation="false" 
                        CssClass="btn btn-secondary w-100" />
                </div>
            </div>

            <div class="card shadow-sm mb-5">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
                    DataKeyNames="trip_id" DataSourceID="SqlDataSourceCalatorii" 
                    CssClass="table table-hover table-striped mb-0">
                    <Columns>
                        <asp:BoundField DataField="destination" HeaderText="Destinație" SortExpression="destination" />
                        <asp:BoundField DataField="budget" HeaderText="Buget (RON)" SortExpression="budget" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="start_date" HeaderText="Data Start" SortExpression="start_date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="end_date" HeaderText="Data Final" SortExpression="end_date" DataFormatString="{0:yyyy-MM-dd}" />
                        
                        <asp:CommandField ButtonType="Button" ShowEditButton="True" ShowDeleteButton="True" 
                            CancelText="Anuleaza" DeleteText="Sterge" EditText="Editeaza" UpdateText="Salveaza" ShowSelectButton="True">
                            <ControlStyle CssClass="btn btn-sm btn-outline-primary" />
                        </asp:CommandField>
                        <asp:HyperLinkField DataNavigateUrlFields="trip_id" DataNavigateUrlFormatString="Program.aspx?TripID={0}" HeaderText="Program" Text="Vezi">
                        <ControlStyle CssClass="btn btn-info btn-sm text-white" />
                        </asp:HyperLinkField>
                        <asp:HyperLinkField DataNavigateUrlFormatString="Program.aspx?TripID={0}" />
                        <asp:HyperLinkField DataNavigateUrlFormatString="Program.aspx?TripID={0}" />
                    </Columns>
                </asp:GridView>
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceActivitatiByOras">
                    <Columns>
                        <asp:BoundField DataField="descriere" HeaderText="descriere" SortExpression="descriere" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceActivitatiByOras" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
                        SelectCommand="GetActivitatiByOras" 
                        SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GridView1" Name="TripID" PropertyName="SelectedValue" Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="card shadow-sm p-4 border-success">
                        <h4 class="text-success mb-3">Adauga Calatorie Noua</h4>
                        <asp:DetailsView ID="DetailsView1" runat="server" DataSourceID="SqlDataSourceCalatorii" 
                            DefaultMode="Insert" AutoGenerateRows="False" CssClass="table table-borderless" 
                            OnItemInserted="DetailsView1_ItemInserted">
                            <Fields>
                                <asp:TemplateField HeaderText="Destinație:">
                                    <InsertItemTemplate>
                                        <asp:TextBox ID="txtDest" runat="server" Text='<%# Bind("destination") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="rfvDest" runat="server" ControlToValidate="txtDest" 
                                            ErrorMessage="Destinația obligatorie!" ForeColor="Red" Display="Dynamic" 
                                            ValidationGroup="GrupAdaugare" />
                                    </InsertItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Buget:">
                                    <InsertItemTemplate>
                                        <asp:TextBox ID="txtBudget" runat="server" Text='<%# Bind("budget") %>' CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="rfvB" runat="server" ControlToValidate="txtBudget" 
                                            ErrorMessage="Puneți bugetul!" ForeColor="Red" Display="Dynamic" 
                                            ValidationGroup="GrupAdaugare" />
                                        <asp:RangeValidator ID="rvB" runat="server" ControlToValidate="txtBudget" 
                                            MinimumValue="1" MaximumValue="999999" Type="Double" 
                                            ErrorMessage="Buget invalid!" ForeColor="Red" Display="Dynamic" 
                                            ValidationGroup="GrupAdaugare" />
                                    </InsertItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Data Start:">
                                    <InsertItemTemplate>
                                        <asp:TextBox ID="txtStart" runat="server" Text='<%# Bind("start_date") %>' TextMode="Date" CssClass="form-control" />
                                        <asp:RequiredFieldValidator ID="rfvS" runat="server" ControlToValidate="txtStart" 
                                            ErrorMessage="Data start?" ForeColor="Red" Display="Dynamic" 
                                            ValidationGroup="GrupAdaugare" />
                                    </InsertItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Data Final:">
                                    <InsertItemTemplate>
                                        <asp:TextBox ID="txtEnd" runat="server" Text='<%# Bind("end_date") %>' TextMode="Date" CssClass="form-control" />
                                        <asp:CompareValidator ID="cvD" runat="server" ControlToValidate="txtEnd" ControlToCompare="txtStart" 
                                            Operator="GreaterThanEqual" Type="Date" ErrorMessage="Data finală eronată!" 
                                            ForeColor="Red" Display="Dynamic" ValidationGroup="GrupAdaugare" />
                                    </InsertItemTemplate>
                                </asp:TemplateField>

                                <asp:CommandField InsertText="Salvează Călătoria" ShowInsertButton="True" ValidationGroup="GrupAdaugare">
                                    <ControlStyle CssClass="btn btn-success w-100" />
                                </asp:CommandField>
                            </Fields>
                        </asp:DetailsView>
                    </div>
                </div>
            </div>

            <asp:SqlDataSource ID="SqlDataSourceFiltruCalatorie" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
                SelectCommand="SELECT DISTINCT [destination] FROM [Calatorie] ORDER BY [destination]">
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="SqlDataSourceCalatorii" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
                DeleteCommand="DELETE FROM [Calatorie] WHERE [trip_id] = @trip_id" 
                InsertCommand="INSERT INTO [Calatorie] ([destination], [budget], [start_date], [end_date]) VALUES (@destination, @budget, @start_date, @end_date)" 
                SelectCommand="SELECT * FROM [Calatorie] WHERE ([destination] LIKE @destination OR @destination = '%')" 
                UpdateCommand="UPDATE [Calatorie] SET [destination] = @destination, [budget] = @budget, [start_date] = @start_date, [end_date] = @end_date WHERE [trip_id] = @trip_id">
                <SelectParameters>
                    <asp:ControlParameter ControlID="DropDownList1" Name="destination" PropertyName="SelectedValue" Type="String" DefaultValue="%" />
                </SelectParameters>
                <DeleteParameters><asp:Parameter Name="trip_id" Type="Int32" /></DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="destination" Type="String" /><asp:Parameter Name="budget" Type="Decimal" />
                    <asp:Parameter DbType="Date" Name="start_date" /><asp:Parameter DbType="Date" Name="end_date" />
                </InsertParameters>
                <UpdateParameters>
                    <asp:Parameter Name="destination" Type="String" /><asp:Parameter Name="budget" Type="Decimal" />
                    <asp:Parameter DbType="Date" Name="start_date" /><asp:Parameter DbType="Date" Name="end_date" />
                    <asp:Parameter Name="trip_id" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <asp:Button ID="btnBackHome" runat="server" OnClick="btnBackHome_Click" Text="Inapoi" />
        </div>
    </form>
</body>
</html>
