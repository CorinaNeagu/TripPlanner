using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TripPlanner
{
    public partial class Program : System.Web.UI.Page
    {
        private int noulIdItinerariu = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            ConfigurareValidator();

            if (!IsPostBack)
            {
                IncarcaDateTransport();

                string activitateDinCatalog = Request.QueryString["SelectedAct"];
                if (!string.IsNullOrEmpty(activitateDinCatalog))
                {
                    CheckBox chk = (CheckBox)DetailsView1.FindControl("cbActivitateNoua");
                    TextBox txt = (TextBox)DetailsView1.FindControl("txtDescriere");
                    DropDownList ddl = (DropDownList)DetailsView1.FindControl("ddlActivitati");

                    if (chk != null && txt != null && ddl != null)
                    {
                        chk.Checked = true; 
                        txt.Visible = true;
                        ddl.Visible = false;
                        txt.Text = activitateDinCatalog; 
                    }
                }
            }

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ConfigurareValidator();
        }

        protected void SqlDataSource1_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.Command.Parameters["@NewID"].Value != DBNull.Value)
            {
                noulIdItinerariu = Convert.ToInt32(e.Command.Parameters["@NewID"].Value);
            }
        }


        protected void DetailsView1_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            if (e.Exception == null)
            {
                string tripId = Request.QueryString["TripID"];
                string actId = Request.QueryString["ActID"];

                if (!string.IsNullOrEmpty(actId) && noulIdItinerariu > 0)
                {
                    SalvareInTabelaLegatura(actId, noulIdItinerariu);
                }

                Response.Redirect("Program.aspx?TripID=" + tripId);
            }
            else
            {
    
                System.Diagnostics.Debug.WriteLine("Eroare Insert Itinerariu: " + e.Exception.Message);
                e.ExceptionHandled = true;
            }
        }


        private void SalvareInTabelaLegatura(string actId, int itinerariuId)
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                TextBox txtO = (TextBox)DetailsView1.FindControl("txtOra");
                TextBox txtC = (TextBox)DetailsView1.FindControl("txtCost");

                string sql = @"INSERT INTO ItinerariuActivitati (itinerariu_id, activitate_id, ora_activitate, pret_total) 
                               VALUES (@itID, @actID, @ora, @pret)";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@itID", itinerariuId);
                cmd.Parameters.AddWithValue("@actID", actId);
                cmd.Parameters.AddWithValue("@ora", string.IsNullOrEmpty(txtO.Text) ? (object)DBNull.Value : txtO.Text);

                decimal pretVal = 0;
                if (txtC != null && !string.IsNullOrEmpty(txtC.Text)) decimal.TryParse(txtC.Text, out pretVal);
                cmd.Parameters.AddWithValue("@pret", pretVal);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected void DetailsView1_DataBound(object sender, EventArgs e)
        {
            if (DetailsView1.CurrentMode == DetailsViewMode.Insert)
            {
                string activitateDinCatalog = Request.QueryString["SelectedAct"];

                if (!string.IsNullOrEmpty(activitateDinCatalog))
                {
                    CheckBox chk = (CheckBox)DetailsView1.FindControl("cbActivitateNoua");
                    TextBox txt = (TextBox)DetailsView1.FindControl("txtDescriere");
                    DropDownList ddl = (DropDownList)DetailsView1.FindControl("ddlActivitati");

                    if (chk != null && txt != null && ddl != null)
                    {
                        chk.Checked = true;
                        txt.Visible = true;
                        ddl.Visible = false;
                        txt.Text = Server.UrlDecode(activitateDinCatalog);
                    }
                }
            }
        }

        protected void DetailsView1_PreRender(object sender, EventArgs e)
        {
            ConfigurareValidator();

            if (DetailsView1.CurrentMode == DetailsViewMode.Insert)
            {
                string activitateDinCatalog = Request.QueryString["SelectedAct"];
                string pretDinCatalog = Request.QueryString["PretAct"];

                if (!string.IsNullOrEmpty(activitateDinCatalog))
                {
                    CheckBox chk = (CheckBox)DetailsView1.FindControl("cbActivitateNoua");
                    TextBox txt = (TextBox)DetailsView1.FindControl("txtDescriere");
                    DropDownList ddl = (DropDownList)DetailsView1.FindControl("ddlActivitati");
                    TextBox txtC = (TextBox)DetailsView1.FindControl("txtCost");

                    if (chk != null && txt != null && ddl != null)
                    {
                        chk.Checked = true;
                        txt.Visible = true;
                        ddl.Visible = false;

                        if (string.IsNullOrEmpty(txt.Text))
                        {
                            txt.Text = Server.UrlDecode(activitateDinCatalog).Replace("+", " ");
                        }

                        if (txtC != null && !string.IsNullOrEmpty(pretDinCatalog))
                        {
                            txtC.Text = pretDinCatalog;
                        }
                    }
                }
            }

            AfiseazaTotalPrinProcedura();
        }

        private void AfiseazaTotalPrinProcedura()
        {
            string connString = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;
            string tripIdStr = Request.QueryString["TripID"];

            if (string.IsNullOrEmpty(tripIdStr)) return;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlCommand cmd = new SqlCommand("GetItinerariuCuTotal", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@TripID", int.Parse(tripIdStr));

                SqlParameter totalParam = new SqlParameter("@TotalBuget", SqlDbType.Decimal);
                totalParam.Precision = 10;
                totalParam.Scale = 2;
                totalParam.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(totalParam);

                conn.Open();
                cmd.ExecuteNonQuery();

                decimal total = (cmd.Parameters["@TotalBuget"].Value != DBNull.Value)
                                ? (decimal)cmd.Parameters["@TotalBuget"].Value
                                : 0;

                lblTotalGeneral.Text = $"Buget Total: {total:F2} €";
            }
        }

        protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            if (e.Command.Parameters["@TotalBuget"].Value != DBNull.Value)
            {
                decimal total = Convert.ToDecimal(e.Command.Parameters["@TotalBuget"].Value);

                lblTotalGeneral.Text = string.Format("Buget Total Planificat: {0:F2} €", total);


            }
        }

        private void ConfigurareValidator()
        {
            HiddenField hStart = (HiddenField)DetailsView2.FindControl("hdnStart");
            HiddenField hEnd = (HiddenField)DetailsView2.FindControl("hdnEnd");

            RangeValidator rv = (RangeValidator)DetailsView1.FindControl("rvData");

            if (hStart != null && hEnd != null && rv != null)
            {
                if (!string.IsNullOrEmpty(hStart.Value) && !string.IsNullOrEmpty(hEnd.Value))
                {
                    rv.MinimumValue = hStart.Value;
                    rv.MaximumValue = hEnd.Value;
                    rv.Enabled = true;

                    rv.Type = ValidationDataType.Date;
                }
            }
        }

        protected void btnVeziActivitati_Click(object sender, EventArgs e)
        {
            string tripId = Request.QueryString["TripID"];

            if (!string.IsNullOrEmpty(tripId))
            {
                Response.Redirect("Activitati.aspx?TripID=" + tripId);
            }
        }

        protected void cbActivitateNoua_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chk = (CheckBox)sender;
            DropDownList ddl = (DropDownList)DetailsView1.FindControl("ddlActivitati");
            TextBox txt = (TextBox)DetailsView1.FindControl("txtDescriere");
            RequiredFieldValidator rfv = (RequiredFieldValidator)DetailsView1.FindControl("rfv1");

            if (chk.Checked)
            {
                ddl.Visible = false;
                txt.Visible = true;
                rfv.Enabled = true;
            }
            else
            {
                ddl.Visible = true;
                txt.Visible = false;
                rfv.Enabled = false;
            }
        }

        protected void DetailsView1_ItemInserting(object sender, DetailsViewInsertEventArgs e)
        {
            CheckBox cb = (CheckBox)DetailsView1.FindControl("cbActivitateNoua");
            DropDownList ddl = (DropDownList)DetailsView1.FindControl("ddlActivitati");
            TextBox txt = (TextBox)DetailsView1.FindControl("txtDescriere");

            TextBox txtC = (TextBox)DetailsView1.FindControl("txtCost");

            if (cb != null)
            {
                if (!cb.Checked)
                {
                    e.Values["descriere"] = ddl.SelectedValue;
                }
                else
                {
                    e.Values["descriere"] = txt.Text;
                }
            }

            if (txtC != null && !string.IsNullOrEmpty(txtC.Text))
            {
                decimal pret;
                if (decimal.TryParse(txtC.Text, out pret))
                {
                    e.Values["cost_total"] = pret;
                }
                else
                {
                    e.Values["cost_total"] = 0; 
                }
            }
        }

        protected void DetailsView1_ItemCommand(object sender, DetailsViewCommandEventArgs e)
        {
            if (e.CommandName == "Cancel")
            {
                string tripId = Request.QueryString["TripID"];

                if (!string.IsNullOrEmpty(tripId))
                {

                    Response.Redirect("Program.aspx?TripID=" + tripId);
                }
            }
        }

        protected void btnTransport_Click(object sender, EventArgs e)
        {
            string tripId = Request.QueryString["TripID"];

            if (!string.IsNullOrEmpty(tripId))
            {
                Response.Redirect("Transport.aspx?TripID=" + tripId);
            }
        }

        private void IncarcaDateTransport()
        {
            string cs = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;

            string tripId = Request.QueryString["TripID"];
            if (string.IsNullOrEmpty(tripId)) return;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string sql = "SELECT directie, tip_transport, cost FROM Transport WHERE trip_id = @tid";
                SqlDataAdapter da = new SqlDataAdapter(sql, con);
                da.SelectCommand.Parameters.AddWithValue("@tid", tripId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                DetailsView3.DataSource = dt;
                DetailsView3.DataBind();

                decimal total = 0;
                foreach (DataRow row in dt.Rows)
                {
                    if (row["cost"] != DBNull.Value)
                    {
                        total += Convert.ToDecimal(row["cost"]);
                    }
                }

                lblCostTransport.Text = total.ToString("N2") + " €";
            }
        }

        protected void DetailsView3_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
        {
            DetailsView3.PageIndex = e.NewPageIndex;
            IncarcaDateTransport();
        }
    }
}