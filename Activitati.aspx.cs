    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;

    namespace TripPlanner
    {
        public partial class Activitati : System.Web.UI.Page
        {
            protected void Page_Load(object sender, EventArgs e)
            {
                CalculareStatisticiReader();

            }

            private void CalculareStatisticiReader()
            {
                string connString = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string sql = "SELECT pret FROM Activitati WHERE categorie LIKE @filtre";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@filtre", ddlFiltruCategorie.SelectedValue);

                    try
                    {
                        conn.Open();
                        SqlDataReader reader = cmd.ExecuteReader();

                        decimal suma = 0;
                        int contor = 0;

                        while (reader.Read())
                        {
                            suma += reader.GetDecimal(0);
                            contor++;
                        }

                        if (contor > 0)
                        {
                            decimal medie = suma / contor;
                            lblStatistici.Text = string.Format("Statistici categorie: {0} activități găsite. Preț mediu: {1:F2} €", contor, medie);
                        }
                        else
                        {
                            lblStatistici.Text = "Nu există activități în această categorie.";
                        }

                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        lblStatistici.Text = "Eroare la calcularea statisticilor.";
                    }
                }
            }

            protected void DetailsView1_ItemInserting(object sender, DetailsViewInsertEventArgs e)
            {
                Page.Validate("GrupCatalog");

                if (!Page.IsValid)
                {
                    e.Cancel = true;
                }

            string numeNou = e.Values["nume_activitate"].ToString().Trim();
                string connString = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string sql = "SELECT activitate_id FROM Activitati WHERE LOWER(nume_activitate) = LOWER(@nume)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@nume", numeNou);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            lblError.Text = "Eroare: Activitatea '" + numeNou + "' exista deja in catalog!";

                            e.Cancel = true;
                        }
                    }
                }
            }

        protected void btnInapoiProgram_Click(object sender, EventArgs e)
        {

            string tripId = Request.QueryString["TripID"];
            if (!string.IsNullOrEmpty(tripId))
            {
                Response.Redirect("Program.aspx?TripID=" + tripId);
            }
        }

        protected void btnSelecteaza_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            string argumente = btn.CommandArgument;
            string tripId = Request.QueryString["TripID"];

            if (!string.IsNullOrEmpty(argumente) && !string.IsNullOrEmpty(tripId))
            {
                string[] parti = argumente.Split('|');

                string idActivitate = parti[0];
                string numeActivitate = parti[1];
                string pretActivitate = parti[2];

                Response.Redirect($"Program.aspx?TripID={tripId}&ActID={idActivitate}&SelectedAct={Server.UrlEncode(numeActivitate)}&PretAct={pretActivitate}");
            }
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }


    }
    }