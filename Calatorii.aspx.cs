using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TripPlanner
{
    public partial class Calatorii : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void DetailsView1_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
        {

        }

        protected void DetailsView1_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {
            GridView1.DataBind();
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            DropDownList1.SelectedIndex = 0;
            SqlDataSourceCalatorii.SelectParameters["destination"].DefaultValue = "%";
            GridView1.DataBind();
        }

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Default");
        }
    }
}