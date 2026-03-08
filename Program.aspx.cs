using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TripPlanner
{
    public partial class Program : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ConfigurareValidator();

        }
        protected void DetailsView1_ItemInserted(object sender, DetailsViewInsertedEventArgs e)
        {

            GridView1.DataBind();
            DetailsView2.DataBind();
            ConfigurareValidator();
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            ConfigurareValidator();
        }


        private void ConfigurareValidator()
        {
            // Căutăm HiddenFields în DetailsView2
            HiddenField hStart = (HiddenField)DetailsView2.FindControl("hdnStart");
            HiddenField hEnd = (HiddenField)DetailsView2.FindControl("hdnEnd");

            // Căutăm validatorul în DetailsView1
            RangeValidator rv = (RangeValidator)DetailsView1.FindControl("rvData");

            if (hStart != null && hEnd != null && rv != null)
            {
                if (!string.IsNullOrEmpty(hStart.Value) && !string.IsNullOrEmpty(hEnd.Value))
                {
                    // Resetăm și re-setăm limitele
                    rv.MinimumValue = hStart.Value;
                    rv.MaximumValue = hEnd.Value;
                    rv.Enabled = true;

                    // Linie magică: forțăm validatorul să se re-evalueze la nivel de proprietăți
                    rv.Type = ValidationDataType.Date;
                }
            }
        }
    }
}