<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TripPlanner._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <div class="text-center" style="margin-top: 50px;">
            <h1>✈️ Trip Planner </h1>
            <p class="lead">Gestioneaza calatoriile, itinerariile si activitatile dintr-un singur loc.</p>
            <hr />
        </div>

        <div class="row text-center" style="margin-top: 30px;">
            <div class="row justify-content-center text-center" style="margin-top: 30px;">
                <div class="col-md-4" style="margin-bottom: 20px;">
                    <h3>Calatorii</h3>
                    <p>Adauga destinatii și perioade de vacanta.</p>
                    <asp:Button ID="btnCalatorii" runat="server" Text="Deschide" PostBackUrl="~/Calatorii.aspx" CssClass="btn btn-primary btn-lg" />
                </div> 
            </div>
         </div>
    </main>

</asp:Content>
