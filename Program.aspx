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
                            <%-- Afișăm datele frumos --%>
                            <asp:Label ID="lblDisplay" runat="server" Text='<%# Eval("start_date", "{0:dd/MM/yyyy}") + " - " + Eval("end_date", "{0:dd/MM/yyyy}") %>'></asp:Label>
                            
                            <%-- Salvăm datele în HiddenFields pentru validator (format yyyy-MM-dd este obligatoriu aici) --%>
                            <asp:HiddenField ID="hdnStart" runat="server" Value='<%# Eval("start_date", "{0:yyyy-MM-dd}") %>' />
                            <asp:HiddenField ID="hdnEnd" runat="server" Value='<%# Eval("end_date", "{0:yyyy-MM-dd}") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Fields>
            </asp:DetailsView>

            <h2 class="section-title">Activități Planificate</h2>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="itinerariu_id" DataSourceID="SqlDataSource1" Width="100%" EmptyDataText="Nu sunt activități.">
                <Columns>
                    <asp:BoundField DataField="data" HeaderText="Data" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="descriere" HeaderText="Descriere" />
                    <asp:CommandField ShowDeleteButton="True" />
                </Columns>
            </asp:GridView>

            <h2 class="section-title">Adaugă Activitate Nouă</h2>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
                InsertCommand="INSERT INTO [Itinerariu] ([trip_id], [descriere], [data]) VALUES (@trip_id, @descriere, @data)" 
                SelectCommand="SELECT [descriere], [data], [itinerariu_id] FROM [Itinerariu] WHERE ([trip_id] = @trip_id)"
                DeleteCommand="DELETE FROM [Itinerariu] WHERE [itinerariu_id] = @itinerariu_id">
                <InsertParameters>
                    <asp:Parameter Name="descriere" Type="String" />
                    <asp:Parameter DbType="Date" Name="data" />
                    <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
                </InsertParameters>
                <SelectParameters>
                    <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataSourceID="SqlDataSource1" DefaultMode="Insert" Width="400px" OnItemInserted="DetailsView1_ItemInserted">
                <Fields>
                    <asp:TemplateField HeaderText="Descriere:">
                        <InsertItemTemplate>
                            <asp:TextBox ID="txtDescriere" runat="server" Text='<%# Bind("descriere") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfv1" runat="server" ControlToValidate="txtDescriere" ErrorMessage="*" ForeColor="Red" />
                        </InsertItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Data:">
                        <InsertItemTemplate>
                            <asp:TextBox ID="txtData" runat="server" Text='<%# Bind("data") %>' TextMode="Date"></asp:TextBox>
                            <asp:RangeValidator ID="rvData" runat="server" 
    ControlToValidate="txtData" 
    Type="Date" 
    ForeColor="Red" 
    Display="Dynamic"
    Enabled="false"
    EnableClientScript="false"
    MinimumValue="1900-01-01" 
    MaximumValue="2100-01-01"
    ErrorMessage="Data trebuie să fie în perioada sejurului!">
</asp:RangeValidator>
                        </InsertItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowInsertButton="True" InsertText="Salvează" CausesValidation="true" />
                </Fields>
            </asp:DetailsView>

            <br />
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="Calatorii.aspx">⬅ Înapoi la listă</asp:HyperLink>
        </div>
    </form>
</body>
</html>
