//Temporary-ben az önnállóan futtatható verzió van.
report 50101 "SEI Reservation"
{
    Caption = 'SEI Reservation';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = '.src/report/rdlc/rep50101reservation.rdlc';

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {

            column(Item_No_; "Item No.") { }
            column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
            column(Cost_Amount__Expected_; "Cost Amount (Expected)") { }
        }


    }

    requestpage
    {
        layout
        {

        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    labels
    {


    }

    var




}
