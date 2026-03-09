<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Program.aspx.cs" Inherits="TripPlanner.Program" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2 class="section-title">Informații Călătorie</h2>
            
            <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
                SelectCommand="SELECT [destination], [start_date], [end_date] FROM [Calatorie] WHERE ([trip_id] = @trip_id)">
                <SelectParameters>
                    <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:DetailsView ID="DetailsView2" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSource2" Width="400px" GridLines="None">
                <Fields>
                    <asp:BoundField DataField="destination" HeaderText="Destinație:" />
                    <asp:TemplateField HeaderText="Perioadă:">
                        <ItemTemplate>
                            <asp:Label ID="lblDisplay" runat="server" Text='<%# Eval("start_date", "{0:dd/MM/yyyy}") + " - " + Eval("end_date", "{0:dd/MM/yyyy}") %>'></asp:Label>
                            <asp:HiddenField ID="hdnStart" runat="server" Value='<%# Eval("start_date", "{0:yyyy-MM-dd}") %>' />
                            <asp:HiddenField ID="hdnEnd" runat="server" Value='<%# Eval("end_date", "{0:yyyy-MM-dd}") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>

            <h2 class="section-title">Activități Planificate</h2>
            <asp:GridView ID="GridView1" runat="server" 
                    AutoGenerateColumns="False" 
                    DataKeyNames="itinerariu_id" 
                    DataSourceID="SqlDataSource1" 
                    Width="100%" 
                    EmptyDataText="Nu sunt activități.">
                <Columns>
                    <asp:BoundField DataField="data" HeaderText="Data" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="ora" HeaderText="Ora" />
                    <asp:BoundField DataField="descriere" HeaderText="Descriere" />
                    <asp:BoundField DataField="cost_total" HeaderText="Preț (€)" DataFormatString="{0:F2}" />
                    <asp:CommandField ShowDeleteButton="True" />
                </Columns>
            </asp:GridView>
            
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
    ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
    SelectCommand="GetItinerariuCuTotal" 
    SelectCommandType="StoredProcedure"
    OnSelected="SqlDataSource1_Selected"
    OnInserted="SqlDataSource1_Inserted"
    InsertCommand="INSERT INTO [Itinerariu] ([trip_id], [descriere], [data], [ora], [cost_total]) VALUES (@trip_id, @descriere, @data, @ora, @cost_total); SET @NewID = SCOPE_IDENTITY();" 
    DeleteCommand="DELETE FROM [Itinerariu] WHERE [itinerariu_id] = @itinerariu_id">
    
    <SelectParameters>
        <asp:QueryStringParameter Name="TripID" QueryStringField="TripID" Type="Int32" />
        <asp:Parameter Name="TotalBuget" Type="Decimal" Direction="Output" />
    </SelectParameters>

    <InsertParameters>
        <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
        <asp:Parameter Name="descriere" Type="String" />
        <asp:Parameter Name="data" DbType="Date" />
        <asp:Parameter Name="ora" DbType="Time" /> 
        <asp:Parameter Name="cost_total" Type="Decimal" />
        <asp:Parameter Name="NewID" Type="Int32" Direction="Output" />
    </InsertParameters>

    <DeleteParameters>
        <asp:Parameter Name="itinerariu_id" Type="Int32" />
    </DeleteParameters>
</asp:SqlDataSource>

            <h2 class="section-title">Adaugă Activitate Nouă</h2>
            <asp:DetailsView ID="DetailsView1" runat="server" 
                    AutoGenerateRows="False" 
                    DataSourceID="SqlDataSource1" 
                    DefaultMode="Insert" Width="400px" 
                    OnItemInserted="DetailsView1_ItemInserted" 
                    OnItemInserting="DetailsView1_ItemInserting"
                    OnItemCommand="DetailsView1_ItemCommand"
                    OnPreRender="DetailsView1_PreRender">
                <Fields>
                    <asp:TemplateField HeaderText="Descriere:">
                        <InsertItemTemplate>
                            <asp:CheckBox ID="cbActivitateNoua" runat="server" AutoPostBack="True" OnCheckedChanged="cbActivitateNoua_CheckedChanged" />
                            <asp:Label ID="Label1" runat="server" Text="Adauga manual"></asp:Label>
                            <br />
                            <asp:SqlDataSource ID="SqlDataSourceActivities" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" SelectCommand="GetActivitatiByOras" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:QueryStringParameter Name="TripID" QueryStringField="TripID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:DropDownList ID="ddlActivitati" runat="server" 
                                 DataSourceID="SqlDataSourceActivities" 
                                 DataTextField="descriere" 
                                 DataValueField="descriere">
                            </asp:DropDownList>
                            <asp:TextBox ID="txtDescriere" runat="server" Text='<%# Bind("descriere") %>' Visible="False"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtDescriere" ErrorMessage="*" ForeColor="Red" Enabled="False" />
                        </InsertItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Data:">
                        <InsertItemTemplate>
                            <asp:TextBox ID="txtData" runat="server" Text='<%# Bind("data") %>' TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvData" runat="server" ControlToValidate="txtData" ErrorMessage="*" ForeColor="Red" Display="Dynamic" />
                            <asp:RangeValidator ID="rvData" runat="server" 
                                ControlToValidate="txtData" Type="Date" ForeColor="Red" Display="Dynamic"
                                Enabled="false" MinimumValue="1900-01-01" MaximumValue="2100-01-01"
                                ErrorMessage="Data în afara sejurului!" />
                        </InsertItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Ora:">
                        <InsertItemTemplate>
                            <asp:TextBox ID="txtOra" runat="server" Text='<%# Bind("ora") %>' TextMode="Time"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvOra" runat="server" ControlToValidate="txtOra" ErrorMessage="*" ForeColor="Red" />
                        </InsertItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Preț (€):">
                        <InsertItemTemplate>
                            <asp:TextBox ID="txtCost" runat="server" Text='<%# Bind("cost_total") %>' TextMode="Number" step="0.01"></asp:TextBox>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    
                    <asp:CommandField ShowInsertButton="True" 
                          InsertText="Salvează" 
                          ShowCancelButton="True" 
                          CancelText="Anulează" 
                          CausesValidation="true" />
                </Fields>
            </asp:DetailsView>

            <div style="margin: 20px 0; font-size: 1.2em; font-weight: bold; color: #2c3e50;">
                <asp:Label ID="lblTotalGeneral" runat="server" Text="Total Buget: 0.00 €"></asp:Label>
            </div>

            <asp:Button ID="btnVeziActivitati" 
                    runat="server" 
                    CausesValidation="False" 
                    CssClass="btn-navigare" 
                    OnClick="btnVeziActivitati_Click" 
                    Text="Vezi Activitati" />
            <br />
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="Calatorii.aspx">⬅ Înapoi la listă</asp:HyperLink>
        </div>
    </form>
</body>
</html>
