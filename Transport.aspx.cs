using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TripPlanner
{
    public partial class Transport : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTransport();
            }
        }

        private void BindTransport()
        {
            string tripId = Request.QueryString["TripID"];
            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql = "SELECT transport_id, tip_transport, cost, directie FROM Transport WHERE trip_id = @tid";
                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.SelectCommand.Parameters.AddWithValue("@tid", tripId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvTransport.DataSource = dt;
                gvTransport.DataBind();
            }
        }

        protected void rblTransport_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlAvion.Visible = rblTransport.SelectedValue == "Avion";
            pnlTren.Visible = rblTransport.SelectedValue == "Tren";
            pnlAutobuz.Visible = rblTransport.SelectedValue == "Autobuz";
            pnlMasina.Visible = rblTransport.SelectedValue == "Masina";
        }

        protected void btnSalveaza_Click(object sender, EventArgs e)
        {
            string tripId = Request.QueryString["TripID"];

            if (!string.IsNullOrEmpty(tripId))
            {
                Response.Redirect("Program.aspx?TripID=" + tripId);
            }
            else
            {
                Response.Redirect("Trips.aspx");
            }
        }

        private void ResetForm()
        {
            rblTransport.SelectedIndex = -1;
            pnlAvion.Visible = pnlTren.Visible = pnlAutobuz.Visible = pnlMasina.Visible = false;
            txtPretAvion.Text = txtPretTren.Text = txtPretAutobuz.Text = txtPretMasina.Text = "";
        }


        protected void gvTransport_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            lblMesajEroare.Text = "";
            lblMesajEroare.Visible = false;

            try
            {
                int transportId = Convert.ToInt32(gvTransport.DataKeys[e.RowIndex].Value);

                using (SqlConnection con = new SqlConnection(cs))
                {
                    string sql = "DELETE FROM Transport WHERE transport_id = @id";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.AddWithValue("@id", transportId);

                    con.Open();
                    int rezultat = cmd.ExecuteNonQuery();

                    if (rezultat > 0)
                    {
                        lblMesajEroare.Text = "Inregistrarea a fost stearsa cu succes!";
                        lblMesajEroare.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                lblMesajEroare.Text = "Eroare la stergere: " + ex.Message;
                lblMesajEroare.Visible = true;
            }

            BindTransport();
        }

        protected void gvTransport_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvTransport.EditIndex = e.NewEditIndex;
            BindTransport();
        }

        protected void gvTransport_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvTransport.DataKeys[e.RowIndex].Value);
            string noulCostStr = ((TextBox)gvTransport.Rows[e.RowIndex].Cells[2].Controls[0]).Text;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("UPDATE Transport SET cost = @cost WHERE transport_id = @id", con);
                cmd.Parameters.AddWithValue("@cost", decimal.Parse(noulCostStr));
                cmd.Parameters.AddWithValue("@id", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            gvTransport.EditIndex = -1;
            BindTransport();
        }

        protected void gvTransport_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvTransport.EditIndex = -1;
            BindTransport();
        }

        protected void btnAdaugaTransport_Click(object sender, EventArgs e)
        {
            lblMesajEroare.Visible = false;
            lblMesajEroare.Text = "";

            string tripId = Request.QueryString["TripID"];
            if (string.IsNullOrEmpty(tripId) || rblTransport.SelectedIndex == -1)
            {
                lblMesajEroare.Text = "Selectati un mijloc de transport!";
                return;
            }

            string sens = rblSens.SelectedValue; 
            string tip = rblTransport.SelectedValue;

            decimal pret = 0;
            if (pnlAvion.Visible) decimal.TryParse(txtPretAvion.Text, out pret);
            else if (pnlTren.Visible) decimal.TryParse(txtPretTren.Text, out pret);
            else if (pnlAutobuz.Visible) decimal.TryParse(txtPretAutobuz.Text, out pret);
            else if (pnlMasina.Visible) decimal.TryParse(txtPretMasina.Text, out pret);

            if (pret <= 0)
            {
                lblMesajEroare.Text = "Introduceti un pret valid!";
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                string sqlCheck = "SELECT COUNT(*) FROM Transport WHERE trip_id = @tid AND directie = @dir";
                SqlCommand cmdCheck = new SqlCommand(sqlCheck, con);
                cmdCheck.Parameters.AddWithValue("@tid", tripId);
                cmdCheck.Parameters.AddWithValue("@dir", sens);

                int existaDeja = (int)cmdCheck.ExecuteScalar();

                if (existaDeja > 0)
                {
                    lblMesajEroare.Text = $"Aveti deja o optiune selectata pentru {sens}. Stergeti inregistrarea din tabel pentru a alege alta.";
                    lblMesajEroare.Visible = true; 
                    return; 
                }

                string sqlInsert = "INSERT INTO Transport (trip_id, tip_transport, cost, directie) VALUES (@tid, @tip, @cost, @dir)";
                SqlCommand cmd = new SqlCommand(sqlInsert, con);
                cmd.Parameters.AddWithValue("@tid", tripId);
                cmd.Parameters.AddWithValue("@tip", tip);
                cmd.Parameters.AddWithValue("@cost", pret);
                cmd.Parameters.AddWithValue("@dir", sens);

                cmd.ExecuteNonQuery();
            }

            BindTransport();
            ResetForm();
        }

       
    }
}