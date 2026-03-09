<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Program.aspx.cs" Inherits="TripPlanner.Program" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title> 
</head>

<body>
    <form id="form1" runat="server">
        <div>
            <h2 class="section-title">Informatii Calatorie</h2>
            <div class="budget-status-container" style="margin: 20px 0; padding: 10px; border-radius: 5px; background-color: #f8f9fa;">
                <strong>Status Buget: </strong>
                <asp:Label ID="lblStatusBuget" runat="server" Font-Bold="true" Text="Se încarcă..."></asp:Label>
            </div>
            
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

            <h2 class="section-title">Activitati Planificate</h2>
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

            <h2 class="section-title">Adauga Activitate Noua</h2>
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

            <hr />

            <div style="display: flex; justify-content: space-between; align-items: stretch; gap: 20px; margin-top: 30px;">
    
    <div style="flex: 1; border: 1px solid #ddd; padding: 15px; border-radius: 8px; background-color: #f9f9f9;">
        <h3 style="margin-top:0; border-bottom: 1px solid #ccc; padding-bottom: 5px;">Cazare</h3>
        <asp:SqlDataSource ID="dsCazareAfisare" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ConnectionStringCalatorii %>" 
            SelectCommand="SELECT [hotel_name], [price] FROM [Cazare] WHERE ([trip_id] = @trip_id AND [is_selected] = 1)">
            <SelectParameters>
                <asp:QueryStringParameter Name="trip_id" QueryStringField="TripID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
        
        <asp:DetailsView ID="dvCazare" runat="server" AutoGenerateRows="False" DataSourceID="dsCazareAfisare" Width="100%" GridLines="None" EmptyDataText="Fără cazare selectată.">
            <Fields>
                <asp:BoundField DataField="hotel_name" HeaderText="Hotel:" />
                <asp:BoundField DataField="price" HeaderText="Preț (€):" DataFormatString="{0:F2}" />
            </Fields>
        </asp:DetailsView>
        <div style="margin-top: 10px;">
            <asp:Button ID="btnAlegeCazare" runat="server" CausesValidation="False" OnClick="btnAlegeCazare_Click" Text="Alege Cazare" Width="100%" />
        </div>
    </div>

    <div style="flex: 1; border: 1px solid #ddd; padding: 15px; border-radius: 8px; background-color: #f9f9f9;">
        <h3 style="margin-top:0; border-bottom: 1px solid #ccc; padding-bottom: 5px;">Transport</h3>
        <asp:Label ID="lblCostTransport" runat="server" Text="Status zboruri:" Font-Size="Small" ForeColor="#666"></asp:Label>
        <asp:DetailsView ID="DetailsView3" runat="server" AutoGenerateRows="False" GridLines="None" Width="100%" AllowPaging="True" OnPageIndexChanging="DetailsView3_PageIndexChanging">
            <PagerSettings Mode="NextPrevious" NextPageText="Intors" PreviousPageText="Dus" />
            <Fields>
                <asp:BoundField DataField="directie" HeaderText="Dir:" />
                <asp:BoundField DataField="cost" HeaderText="Pret (€):" DataFormatString="{0:N2}" />
            </Fields>
        </asp:DetailsView>
        <div style="margin-top: 10px;">
            <asp:Button ID="btnTransport" runat="server" CausesValidation="False" OnClick="btnTransport_Click" Text="Optiuni Transport" Width="100%" />
        </div>
    </div>

    <div style="flex: 1; border: 1px solid #ddd; padding: 15px; border-radius: 8px; background-color: #f0f4f8;">
        <h3 style="margin-top:0; border-bottom: 1px solid #ccc; padding-bottom: 5px;">Actiuni</h3>
        <asp:Button ID="btnVeziActivitati" runat="server" CausesValidation="False" OnClick="btnVeziActivitati_Click" Text="Vezi Catalog Activitati" Width="100%" />
        
        <div style="margin-top: 30px; padding: 10px; background: white; border-radius: 5px; text-align: center; border: 1px solid indigo;">
            <span style="font-size: 0.9em; color: #666;">Total Estimat:</span><br />
            <asp:Label ID="lblTotalGeneral" runat="server" Text="Total: 0.00 €" style="font-size: 1.4em; font-weight: bold; color: indigo;"></asp:Label>
        </div>
    </div>

</div>
            

            <asp:Button ID="btnGenereazaRaport" runat="server" Text="Vezi Oferta" 
                CssClass="btn-raport" 
                OnClick="btnGenereazaRaport_Click" 
                CausesValidation="False" />

                <asp:Panel ID="pnlModalRaport" runat="server" Visible="false">
                    <div class="modal-background">
                        <div class="modal-content">
                            <pre><asp:Literal ID="litRaportText" runat="server"></asp:Literal></pre>
            
                            <asp:Button ID="btnClose" runat="server" Text="Închide" 
                                OnClick="btnClose_Click" CssClass="btn-close" />
                        </div>
                    </div>
                </asp:Panel>

            <asp:SqlDataSource ID="SqlDataSource3" runat="server"></asp:SqlDataSource>
        </div>

        <label for="ddlChartType"><strong>Alege tipul de graf:</strong> </label>
            <asp:DropDownList ID="ddlChartType" runat="server" AutoPostBack="true" 
                OnSelectedIndexChanged="ddlChartType_SelectedIndexChanged">
                <asp:ListItem Text="-- Selectează Grafic --" Value="" Selected="True" />
                <asp:ListItem Text="Distribuție Costuri (Pie)" Value="Pie" />
                <asp:ListItem Text="Buget per Destinație (Bars)" Value="Bars" />
                <asp:ListItem Text="Evoluție Activități (Line)" Value="Line" />
            </asp:DropDownList>

        <p style="margin-top:30px">
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="Calatorii.aspx">⬅ Înapoi la listă</asp:HyperLink>
        </p>
    </form>
</body>
</html>
