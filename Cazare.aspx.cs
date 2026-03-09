using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace TripPlanner
{
    public partial class Cazare : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindCazare();
        }

        private void BindCazare()
        {
            string tid = Request.QueryString["TripID"];
            if (string.IsNullOrEmpty(tid)) return;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql = @"
                SELECT DISTINCT c.cazare_id, c.hotel_name, c.price, c.trip_id, c.is_selected 
                FROM Cazare c
                JOIN Calatorie cal_h ON c.trip_id = cal_h.trip_id
                WHERE cal_h.destination = (SELECT destination FROM Calatorie WHERE trip_id = @tid)";

                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@tid", tid);
                con.Open();
                gvCazare.DataSource = cmd.ExecuteReader();
                gvCazare.DataBind();
            }
        }

        protected void btnSwap_Click(object sender, EventArgs e)
        {
            string tid = Request.QueryString["TripID"];
            string cid = ((Button)sender).CommandArgument;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string sql = @"
                UPDATE Cazare SET is_selected = 0 WHERE trip_id = @tid;
                UPDATE Cazare SET is_selected = 1 WHERE cazare_id = @cid;";

                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@tid", tid);
                    cmd.Parameters.AddWithValue("@cid", cid);
                    cmd.ExecuteNonQuery();
                }
            }
            BindCazare();
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtHotel.Text) || string.IsNullOrWhiteSpace(txtPret.Text)) return;

            string tripId = Request.QueryString["TripID"];

            string sql = "INSERT INTO Cazare (hotel_name, price, trip_id, is_selected) VALUES (@h, @p, @tid, 0)";

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddWithValue("@h", txtHotel.Text);
                cmd.Parameters.AddWithValue("@p", decimal.Parse(txtPret.Text));
                cmd.Parameters.AddWithValue("@tid", tripId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtHotel.Text = txtPret.Text = "";
            BindCazare();
        }

        private void ExecuteNonQuery(string sql, params SqlParameter[] parameters)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(sql, con);
                cmd.Parameters.AddRange(parameters);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void gvCazare_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvCazare.DataKeys[e.RowIndex].Value);
            ExecuteNonQuery("DELETE FROM Cazare WHERE cazare_id = @id", new SqlParameter("@id", id));
            BindCazare();
        }

        protected void gvCazare_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCazare.EditIndex = e.NewEditIndex;
            BindCazare();
        }

        protected void gvCazare_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCazare.EditIndex = -1;
            BindCazare();
        }

        protected void gvCazare_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvCazare.DataKeys[e.RowIndex].Value);
            string hotel = ((TextBox)gvCazare.Rows[e.RowIndex].Cells[0].Controls[0]).Text;
            string pret = ((TextBox)gvCazare.Rows[e.RowIndex].Cells[1].Controls[0]).Text;

            ExecuteNonQuery("UPDATE Cazare SET hotel_name = @hotel, price = @pret WHERE cazare_id = @id",
                new SqlParameter("@hotel", hotel),
                new SqlParameter("@pret", decimal.Parse(pret)),
                new SqlParameter("@id", id));

            gvCazare.EditIndex = -1;
            BindCazare();
        }

        protected void btnAlegeCazare_Click(object sender, EventArgs e)
        {
            string tripId = Request.QueryString["TripID"];
            Response.Redirect(string.IsNullOrEmpty(tripId) ? "Trips.aspx" : "Program.aspx?TripID=" + tripId);
        }
    }
}