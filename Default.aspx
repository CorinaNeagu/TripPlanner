<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TripPlanner._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <div class="text-center" style="margin-top: 50px;">
            <h1>✈️ Trip Planner </h1>
            <p class="lead">Gestionează-ți călătoriile, itinerariile și activitățile dintr-un singur loc.</p>
            <hr />
        </div>

        <div class="row text-center" style="margin-top: 30px;">
            <div class="col-md-4" style="margin-bottom: 20px;">
                <h3>🌍 Călătorii</h3>
                <p>Adaugă destinații și perioade de vacanță.</p>
                <asp:Button ID="btnCalatorii" runat="server" Text="Deschide" PostBackUrl="~/Calatorii.aspx" CssClass="btn btn-primary btn-lg" />
            </div>

            <div class="col-md-4" style="margin-bottom: 20px;">
                <h3>🏨 Cazări</h3>
                <p>Gestionează rezervările la hotel.</p>
                <asp:Button ID="btnCazari" runat="server" Text="Deschide" PostBackUrl="~/Cazari.aspx" CssClass="btn btn-info btn-lg" />
            </div>

            <div class="col-md-4" style="margin-bottom: 20px;">
                <h3>🚗 Transport</h3>
                <p>Detalii despre zboruri sau închirieri auto.</p>
                <asp:Button ID="btnTransport" runat="server" Text="Deschide" PostBackUrl="~/Transport.aspx" CssClass="btn btn-warning btn-lg" />
            </div>
        </div>

        <div class="row text-center" style="margin-top: 20px;">
            <div class="col-md-6" style="margin-bottom: 20px;">
                <h3>📅 Itinerariu</h3>
                <p>Planifică activitățile pe zile.</p>
                <asp:Button ID="btnItinerariu" runat="server" Text="Vezi Zile" PostBackUrl="~/Itinerariu.aspx" CssClass="btn btn-success btn-lg" />
            </div>

            <div class="col-md-6" style="margin-bottom: 20px;">
                <h3>🎭 Activități</h3>
                <p>Catalogul de experiențe și prețuri.</p>
                <asp:Button ID="btnActivitati" runat="server" Text="Vezi Catalog" PostBackUrl="~/Activitati.aspx" CssClass="btn btn-danger btn-lg" />
            </div>
        </div>
    </main>

</asp:Content>
