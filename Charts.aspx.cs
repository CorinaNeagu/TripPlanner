using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Configuration;
using ZedGraph;
using ZedGraph.Web;

namespace TripPlanner
{
    public partial class Charts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string tripID = Request.QueryString["TripID"];
            if (!string.IsNullOrEmpty(tripID))
            {
                lnkBack.NavigateUrl = "Program.aspx?TripID=" + tripID;
            }
        }

        protected void ZedGraphWeb1_RenderGraph(ZedGraphWeb webObject, Graphics g, MasterPane pane)
        {
            GraphPane myPane = pane[0];
            myPane.CurveList.Clear();
            myPane.GraphObjList.Clear();

            string type = Request.QueryString["type"] ?? "Pie";
            string tripIDStr = Request.QueryString["TripID"];

            int tripID;
            if (!int.TryParse(tripIDStr, out tripID)) tripID = 1;

            string connStr = ConfigurationManager.ConnectionStrings["ConnectionStringCalatorii"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    switch (type)
                    {
                        case "Pie":
                            myPane.Title.Text = "Distribuție Buget Călătorie";

                            myPane.XAxis.IsVisible = false;
                            myPane.YAxis.IsVisible = false;
                            myPane.Legend.IsVisible = true;
                            myPane.Legend.Position = LegendPos.Right;

                            using (SqlCommand cmd = new SqlCommand("GetToateCosturile", conn))
                            {
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.AddWithValue("@TripID", tripID);
                                using (SqlDataReader dr = cmd.ExecuteReader())
                                {
                                    if (dr.Read())
                                    {
                                        double cazare = Convert.ToDouble(dr["CostCazare"] ?? 0);
                                        double transport = Convert.ToDouble(dr["CostTransport"] ?? 0);
                                        double activitati = Convert.ToDouble(dr["CostActivitati"] ?? 0);

                                        if (cazare + transport + activitati > 0)
                                        {
                                            if (cazare > 0)
                                                myPane.AddPieSlice(cazare, Color.Gold, 0.05, "Cazare (" + cazare + " €)");

                                            if (transport > 0)
                                                myPane.AddPieSlice(transport, Color.SkyBlue, 0.02, "Transport (" + transport + " €)");

                                            if (activitati > 0)
                                                myPane.AddPieSlice(activitati, Color.LimeGreen, 0.02, "Activități (" + activitati + " €)");
                                        }
                                        else
                                        {
                                            myPane.Title.Text = "Toate costurile sunt 0 pentru acest TripID!";
                                        }
                                    }
                                }
                            }
                            break;

                        case "Bars":
                            string numeDestinatie = "Destinația curentă";

                            myPane.Title.Text = "Distribuția Activităților - " + numeDestinatie;
                            myPane.XAxis.Title.Text = "Tip Activitate / Descriere";
                            myPane.YAxis.Title.Text = "De câte ori apare";

                            PointPairList barPoints = new PointPairList();
                            List<string> activityLabels = new List<string>();

                           
                            string sqlCount = @"
                            SELECT descriere, COUNT(itinerariu_id) as NrApariții
                            FROM Itinerariu 
                            WHERE trip_id = @id
                            GROUP BY descriere";

                            using (SqlCommand cmd = new SqlCommand(sqlCount, conn))
                            {
                                cmd.Parameters.AddWithValue("@id", tripID);
                                using (SqlDataReader dr = cmd.ExecuteReader())
                                {
                                    int i = 0;
                                    while (dr.Read())
                                    {
                                        string desc = dr["descriere"].ToString();
                                        if (desc.Length > 15) desc = desc.Substring(0, 12) + "...";

                                        activityLabels.Add(desc);
                                        barPoints.Add(i++, Convert.ToDouble(dr["NrApariții"]));
                                    }
                                }
                            }

                            if (barPoints.Count > 0)
                            {
                                BarItem myBar = myPane.AddBar("Frecvență", barPoints, Color.MediumSeaGreen);
                                myBar.Bar.Fill = new Fill(Color.MediumSeaGreen, Color.White, Color.MediumSeaGreen);

                                myPane.XAxis.Type = AxisType.Text;
                                myPane.XAxis.Scale.TextLabels = activityLabels.ToArray();

                                myPane.XAxis.Scale.FontSpec.Angle = 45;

                                myPane.YAxis.Scale.Min = 0;
                                myPane.YAxis.Scale.MagAuto = false;
                            }
                            else
                            {
                                myPane.Title.Text = "Nu există activități adăugate pentru această destinație.";
                            }
                            break;

                        case "Line":
                            myPane.Title.Text = "Evoluția Cheltuielilor Zilnice";
                            myPane.XAxis.Title.Text = "Data";
                            myPane.YAxis.Title.Text = "Total (€) / Zi";

                            PointPairList dailyPoints = new PointPairList();

                            string sqlLineAgregat = @"
                            SELECT data, SUM(cost_total) as TotalZi 
                            FROM Itinerariu 
                            WHERE trip_id = @id 
                            GROUP BY data 
                            ORDER BY data";

                            using (SqlCommand cmd = new SqlCommand(sqlLineAgregat, conn))
                            {
                                cmd.Parameters.AddWithValue("@id", tripID);
                                using (SqlDataReader dr = cmd.ExecuteReader())
                                {
                                    while (dr.Read())
                                    {
                                        DateTime zi = Convert.ToDateTime(dr["data"]);
                                        double xValue = new XDate(zi);
                                        double yValue = Convert.ToDouble(dr["TotalZi"]); 

                                        dailyPoints.Add(xValue, yValue);
                                    }
                                }
                            }

                            if (dailyPoints.Count > 0)
                            {
                                LineItem curve = myPane.AddCurve("Total Zilnic", dailyPoints, Color.Red, SymbolType.Diamond);
                                curve.Line.Width = 2.5F;
                                curve.Line.IsSmooth = true; // Face linia mai elegantă

                                myPane.XAxis.Type = AxisType.Date;
                                myPane.XAxis.Scale.Format = "dd/MM";
                            }
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                myPane.Title.Text = "Eroare: " + ex.Message;
            }

            myPane.AxisChange();
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            string tripID = Request.QueryString["TripID"];
            Response.Redirect("Program.aspx?TripID=" + tripID);
        }
    }
}